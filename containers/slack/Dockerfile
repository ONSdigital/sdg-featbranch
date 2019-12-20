FROM alpine:3.10.3
RUN apk add curl
CMD curl -X POST -H 'Content-type: application/json' --data "{'text':'$message'}" $webHook