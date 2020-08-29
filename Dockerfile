FROM golang:1.9.6-alpine3.7

RUN mkdir -p /go/src/web-app
WORKDIR /go/src/web-app
COPY . /go/src/web-app
RUN go-wrapper download
RUN go-wrapper install
ENV PORT 8082
EXPOSE 8082

CMD ["go-wrapper", "run"]
