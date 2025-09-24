# Build stage
FROM golang:1.25.1-alpine AS build

WORKDIR /app
COPY go.mod go.sum ./

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o hello

# Final stage
FROM alpine:edge
LABEL org.opencontainers.image.authors="steve@wordtothewise.com"
LABEL org.opencontainers.image.description="AboutMy.email API server"
WORKDIR /app
COPY --from=build /app/hello .

RUN apk --no-cache add ca-certificates tzdata
EXPOSE 8080
ENTRYPOINT ["/app/hello"]
