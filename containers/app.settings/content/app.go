package main

import (
    "fmt"
	"net/http"
	"io/ioutil"
)

func main() {
    http.HandleFunc("/", handle)
    http.ListenAndServe(":80", nil)
}

func handle(responseWriter http.ResponseWriter, request *http.Request){
	settingName := getSettingNameFromRequest(request)
	settingValue := getSettingValue(settingName)
	fmt.Fprintf(responseWriter, "%s", string(settingValue))
}

func getSettingNameFromRequest(request *http.Request) string{
	return request.URL.Path[1:]
}

func getSettingValue(name string) string{
	value, _ := ioutil.ReadFile("/settings/" + name)
	return string(value)
}