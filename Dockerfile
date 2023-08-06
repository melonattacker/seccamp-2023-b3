FROM golang:1.20 AS build

WORKDIR /src

COPY . .

RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o server cmd/server/main.go

FROM alpine:latest

WORKDIR /app

RUN apk --no-cache add wget bash

COPY --from=build /src/server .

RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
    chmod +x /app/wait-for-it.sh
