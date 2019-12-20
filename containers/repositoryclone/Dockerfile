FROM alpine:3.10.3
RUN apk add git
WORKDIR /root
CMD git clone https://github.com/$owner/$siteRepo.git && git clone https://github.com/$owner/$dataRepo.git