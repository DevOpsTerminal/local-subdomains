.PHONY: help dev build start stop restart logs test test-ansible clean push

# Help target
help:
	@echo "Available commands:"
	@echo "  make dev     Start development environment"
	@echo "  make build   Build all services"
	@echo "  make start   Start all services"
	@echo "  make stop    Stop all services"
	@echo "  make restart Restart all services"
	@echo "  make logs    Show logs"
	@echo "  make test    Run tests"
	@echo "  make clean   Clean up Docker resources"
	@echo "  make push    Build, test, and push changes"

# Development
dev:
	@echo "🚀 Starting development environment..."
	@cp .env.dev .env
	@docker-compose up -d

# Build
build:
	@echo "🔨 Building services..."
	@docker-compose build

# Start/Stop/Restart
start:
	@echo "🚀 Starting services..."
	@docker-compose up -d

stop:
	@echo "🛑 Stopping services..."
	@docker-compose down

restart: stop start

# Logs
logs:
	@docker-compose logs -f

# Testing
test: test-ansible

# Run Ansible tests
test-ansible:
	@echo "🧪 Running Ansible tests..."
	@if [ -f "tests/ansible/playbook.yml" ]; then \
		cd tests/ansible && ansible-playbook playbook.yml; \
	else \
		echo "⚠️ Ansible tests not found. Skipping..."; \
	fi

# Cleanup
clean:
	@echo "🧹 Cleaning up..."
	@docker-compose down -v

# Build and push git changes
push:
	@echo "🚀 Starting build and push process..."
	@if [ ! -f "scripts/build.sh" ]; then \
		echo "❌ Error: build.sh not found in scripts/ directory"; \
		exit 1; \
	fi
	@./scripts/build.sh
	@echo "📦 Committing changes..."
	@git add .
	@if ! git diff-index --quiet HEAD --; then \
		git commit -m "[auto] Update at $$(date '+%Y-%m-%d %H:%M:%S')"; \
		git push; \
	else \
		echo "ℹ️ No changes to commit"; \
	fi
