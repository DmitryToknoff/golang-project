include .env

export
export PROJECT_ROOT=$(shell pwd)

env-up:
	@docker-compose up -d postgres-user

env-down:
	@docker-compose down postgres-user


env-clean:
	docker-compose down postgres-user && \
	rm -rf out/pgdata

migrate-create:
	@if [ -z "$(seq)" ]; then \
		echo "Отсутствует параметр seq"; \
	fi; \
	docker compose run --rm app-migrate \
		create \
		-ext sql \
		-dir /migrations \
		-seq $(seq); \


migrate-action:
	@docker compose run --rm app-migrate \
		-path /migrations \
		-database postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@postgres-user:5432/${POSTGRES_DB}?sslmode=disable \
		$(action)

migrate-up:
	@make migrate-action action=up


migrate-down:
	@make migrate-action action=down

env-port-forwarder:
	@docker compose up -d port-forwarder

env-port-close:
	@docker compose down port-forwarder


app-run:
	@export LOGGER_FOLDER=$(PROJECT_ROOT)/out/logs && \
	go mod tidy && \
	go run cmd/app/main.go
