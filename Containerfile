# Build stage
FROM docker.io/golang:1.25.1-alpine AS build
WORKDIR /app
COPY go.mod go.sum ./

COPY . .

RUN CGO_ENABLED=0 go build -o hello

# Final stage
FROM scratch
LABEL org.opencontainers.image.authors="steve@wordtothewise.com"
LABEL org.opencontainers.image.description="AboutMy.email API server"
WORKDIR /app
COPY --from=build /app/hello .

EXPOSE 8080
ENTRYPOINT ["/app/hello"]
