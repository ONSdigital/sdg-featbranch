package main

import(
	"fmt"
	"log"
	"net/http"
	"io/ioutil"
	"encoding/json"
	"time"
)

type ChangeDetails struct{
	RepositoryName string
	BranchName string
	Author string
	Message string
}

func main() {
	http.HandleFunc("/", respond)
    log.Fatal(http.ListenAndServe(":80", nil))
}

func respond(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
		case http.MethodPost:
			changeDetails := getChangeDetails(r)
			fmt.Fprintf(w, changeDetails.RepositoryName)
			
		default:
			fmt.Fprintf(w, "Invalid")
	}
}

func getChangeDetails(request *http.Request) ChangeDetails {
	body, _ := ioutil.ReadAll(request.Body)
	var changeDetails ChangeDetails
	json.Unmarshal([]byte(body), &changeDetails)

	return changeDetails
}