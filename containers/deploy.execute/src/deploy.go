package main

import (
	"net/http"
	"io/ioutil"
	"encoding/json"
	"log"
	"strings"
	"bytes"
)

type Deployment struct{
	RepositoryName string
	BranchName string
}

type BuildResponse struct {
    BuiltSuccessfully bool
}

func main(){
	http.HandleFunc("/", handle)
    log.Fatal(http.ListenAndServe(":80", nil))
}

func handle(w http.ResponseWriter, r *http.Request){
	body, _ := ioutil.ReadAll(r.Body)
	var deployment Deployment
	json.Unmarshal([]byte(body), &deployment)
	deploy(deployment.RepositoryName, deployment.BranchName)
}

func deploy(repositoryName string, branchName string) {
	siteRepository := getSetting("siteRepo")
	dataRepository := getSetting("dataRepo")
	serverUrl := getSetting("serverUrl")

	if repositoryName == siteRepository{
		deploySiteBranch(siteRepository, branchName, serverUrl)
	}else if repositoryName == dataRepository{
		deployDataBranch(dataRepository, branchName, serverUrl)
	}
}

func deploySiteBranch(repositoryName string, branchName string, serverUrl string){
	response := buildBranch("site", branchName)

	if response.BuiltSuccessfully {
		generateAccessibilityReport(branchName)
		postMessageToSlack("updatedsitebranch", "repository="+repositoryName+"&branchName="+branchName+"&serverUrl="+serverUrl)
	}
}

func deployDataBranch(repositoryName string, branchName string, serverUrl string){
	response := buildBranch("data", branchName)
	if response.BuiltSuccessfully {
		generateDataPreviewSite(branchName, serverUrl)
		postMessageToSlack("updateddata", "repository="+repositoryName+"&branchName="+branchName+"&serverUrl="+serverUrl)
	}
}

func getSetting(settingName string) string{
    response, _ := http.Get("http://app.settings/" + settingName)
	body, _ := ioutil.ReadAll(response.Body)
	response.Body.Close()
	return strings.TrimSpace(string(body))
}

func buildBranch(repositoryType string, branchName string) BuildResponse {
    branchBuildResponse, _ := http.Get("http://"+repositoryType+".buildbranch/" +  branchName)
    responseContent, _ := ioutil.ReadAll(branchBuildResponse.Body)
    responseContentAsBytes := []byte(responseContent)
    var buildResponse BuildResponse
    json.Unmarshal(responseContentAsBytes, &buildResponse)
    return buildResponse
}

func generateAccessibilityReport(branchName string) {
    http.Get("http://site.a11yreport/" + branchName)
}

func generateDataPreviewSite(dataBranchName string, serverUrl string){
    http.Get("http://data.buildpreview/" + dataBranchName + "?serverUrl=" + serverUrl)
}

func postMessageToSlack(template string, content string){    
    var requestPayload = []byte(content)
	req, _ := http.NewRequest("POST", "http://slack/template/"+template, bytes.NewBuffer(requestPayload))
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")

	client := &http.Client{}
	resp, _ := client.Do(req)
	defer resp.Body.Close()
}