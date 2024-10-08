FROM golang:1.22-alpine AS build

WORKDIR /app

COPY go.mod go.sum ./ 

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /app/my_app .

FROM scratch

WORKDIR /app

# Копируем скомпилированное приложение из этапа сборки
COPY --from=build /app/my_app /app/my_app

# Копируем базу данных
COPY tracker.db /app/tracker.db

EXPOSE 8080

CMD ["/app/my_app"]