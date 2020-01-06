package main

import (
    "log"
    "net/http"
    "io/ioutil"
    "encoding/json"
    "os"
    "bytes"
)

type Branches struct {
    Branches []Branch
}

type Branch struct {
    Name string
    Commit Commit
}

type Commit struct{
    Sha string
}

type BuildResponse struct {
    BuiltSuccessfully bool
}

func main() {
    http.HandleFunc("/", deploy)
    log.Fatal(http.ListenAndServe(":80", nil))
}

func deploy(w http.ResponseWriter, r *http.Request) {
    updateRepositories()
    buildSiteBranches()
    buildDataBranches()
}

func updateRepositories(){
    http.PostForm("http://repo.update/site", nil)
    http.PostForm("http://repo.update/data",nil)
}

func buildSiteBranches() {
    repository := os.Getenv("siteRepo")
    serverUrl := os.Getenv("serverUrl")

    branches := getOutdatedBranches("site")

    for _,eachBranch := range branches.Branches{
        buildResponse := buildBranch("site", eachBranch.Name)
        addEntryToDeploymentDatabase(repository, eachBranch.Name, eachBranch.Commit.Sha)
        if buildResponse.BuiltSuccessfully {
            generateAccessibilityReport(eachBranch.Name)
            postMessageToSlack("updatedsitebranch", "repository="+repository+"&branchName="+eachBranch.Name+"&serverUrl="+serverUrl)
        }
    }
}

func buildDataBranches() {
    repository := os.Getenv("dataRepo")
    branches := getOutdatedBranches("data")
    serverUrl := os.Getenv("serverUrl")

    for _,eachBranch := range branches.Branches{
        buildResponse := buildBranch("data", eachBranch.Name)
        addEntryToDeploymentDatabase(repository, eachBranch.Name, eachBranch.Commit.Sha)
        if buildResponse.BuiltSuccessfully {
            generateDataPreviewSite(eachBranch.Name)
            postMessageToSlack("updateddata", "repository="+repository+"&branchName="+eachBranch.Name+"&serverUrl="+serverUrl)
        }
    }
}

func getOutdatedBranches(repositoryType string) Branches{
    repositoryOwner := os.Getenv("owner")
    repository := os.Getenv(repositoryType+"Repo")
    githubToken := os.Getenv("githubToken")

    githubApiResponse, _ := http.Get("http://githubapi/outdatedBranches/"+repositoryOwner+"/"+repository+"?token="+githubToken)
    branchesRawData, _ := ioutil.ReadAll(githubApiResponse.Body)
    var branches Branches
    branchesDataAsBytes := []byte(branchesRawData)
    json.Unmarshal(branchesDataAsBytes, &branches)

    return branches
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

func generateDataPreviewSite(dataBranchName string){
    http.Get("http://data.buildpreview/" + dataBranchName)
}

func postMessageToSlack(template string, content string){    
    var requestPayload = []byte(content)
	req, _ := http.NewRequest("POST", "http://slack/template/"+template, bytes.NewBuffer(requestPayload))
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")

	client := &http.Client{}
	resp, _ := client.Do(req)
	defer resp.Body.Close()
}

func addEntryToDeploymentDatabase(repositoryName string, branchName string, latestCommit string) {
    var requestPayload = []byte("branch="+branchName+"&repository="+repositoryName+"&latestCommit="+latestCommit)
    req, _ := http.NewRequest("POST", "http://tracking.deployments/add-entry", bytes.NewBuffer(requestPayload))
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")

	client := &http.Client{}
	resp, _ := client.Do(req)
	defer resp.Body.Close()
}