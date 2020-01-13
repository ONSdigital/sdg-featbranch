package main

import(
	"fmt"
	"log"
	"bytes"
	"io/ioutil"
	"net/http"
	"encoding/json"
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
			detailsAsPayload := changeDetails.RepositoryName+"||"+changeDetails.BranchName+"||"+changeDetails.Author+"||"+changeDetails.Message
			var requestPayload = []byte(`{"message":"`+detailsAsPayload+`"}`)
			req, _ := http.NewRequest("POST", "http://deploy.queue.send/", bytes.NewBuffer(requestPayload))

			req.Header.Set("Content-Type", "application/json")

			client := &http.Client{}
			resp, _ := client.Do(req)

			defer resp.Body.Close()
			
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