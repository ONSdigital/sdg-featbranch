FROM golang:1.13.5-alpine3.11
RUN /dist
WORKDIR /root/deploy
CMD go build && mv deploy /dist && /dist/deploy