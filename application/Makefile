.PHONY: build run clean deps docker-up docker-down wait-for-db

APP_NAME := quotes-app
MAIN_FILE := cmd/main.go

build:
	go build -o $(APP_NAME) $(MAIN_FILE)

run:
	export $$(grep -v '^#' .env | xargs) && go run $(MAIN_FILE)

deps:
	go mod tidy

clean:
	rm -f $(APP_NAME)

wait-for-db:
	@echo "Waiting for PostgreSQL to be ready..."
	@until docker-compose exec postgres pg_isready -U postgres > /dev/null 2>&1; do \
		echo "PostgreSQL is not ready yet, waiting..."; \
		sleep 2; \
	done
	@echo "PostgreSQL is ready!"

docker-up:
	docker-compose up -d
	@echo "Waiting for PostgreSQL to start..."
	@sleep 5
	@echo "PostgreSQL should be ready!"

docker-down:
	docker-compose down

docker-reset:
	docker-compose down
	docker volume rm application_postgres_data || true
	@echo "Docker volumes cleared"

dev: docker-up deps wait-for-db
	$(MAKE) run

test:
	go test ./...

install:
	go install $(MAIN_FILE)

help:
	@echo "Available commands:"
	@echo "  build      - Build the application"
	@echo "  run        - Run the application"
	@echo "  deps       - Download dependencies"
	@echo "  clean      - Remove built binaries"
	@echo "  docker-up  - Start PostgreSQL with Docker"
	@echo "  docker-down- Stop Docker containers"
	@echo "  dev        - Start Docker and run app"
	@echo "  test       - Run tests"
	@echo "  install    - Install the application"
	@echo "  help       - Show this help message"