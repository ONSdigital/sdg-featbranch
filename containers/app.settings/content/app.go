package main

import (
    "fmt"
    "log"
	"net/http"
	"io/ioutil"
)

func main() {
    http.HandleFunc("/", getSetting)
    log.Fatal(http.ListenAndServe(":80", nil))
}

func getSetting(w http.ResponseWriter, r *http.Request){
	name := r.URL.Path[1:]

	value, _ := ioutil.ReadFile("/settings/" + name)

	fmt.Fprintf(w, "%s", string(value))
}