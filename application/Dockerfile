FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main ./cmd/main.go

FROM alpine:3.19
RUN apk --no-cache add ca-certificates && \
    adduser -D -s /bin/sh appuser
WORKDIR /home/appuser
COPY --from=builder --chown=appuser:appuser /app/main .
USER appuser
EXPOSE 8080
CMD ["./main"]