# Makefile - convenience commands for local development with Docker

.PHONY: setup build up down logs migrate createsuperuser test shell clean

COMPOSE_FILE ?= docker-compose.yml

# One-command setup for portfolio demo
setup:
	@echo "🚀 Настройка TaskCore..."
	@if [ ! -f .env ]; then \
		echo "📝 Создание .env файла..."; \
		cp .env.example .env; \
	else \
		echo "✅ .env файл уже существует"; \
	fi
	@echo "🏗️  Сборка Docker образов..."
	docker compose -f $(COMPOSE_FILE) build
	@echo "🐳 Запуск сервисов..."
	docker compose -f $(COMPOSE_FILE) up -d
	@echo "⏳ Ожидание готовности БД..."
	sleep 5
	@echo "🔄 Применение миграций..."
	docker compose -f $(COMPOSE_FILE) exec backend python manage.py migrate
	@echo "📊 Создание тестовых данных..."
	docker compose -f $(COMPOSE_FILE) exec backend python manage.py shell -c "from tasks.models import Task; Task.objects.get_or_create(title='Добро пожаловать в TaskCore', defaults={'description': 'Система управления задачами готова к работе!', 'completed': False})"
	@echo "✨ Готово! Откройте http://localhost:8000"
	@echo "💡 Админ-панель: http://localhost:8000/admin (создайте суперпользователя: make createsuperuser)"

build:
	docker compose -f $(COMPOSE_FILE) build --no-cache

up:
	docker compose -f $(COMPOSE_FILE) up -d

down:
	docker compose -f $(COMPOSE_FILE) down --volumes --remove-orphans

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

migrate:
	docker compose -f $(COMPOSE_FILE) exec backend python manage.py migrate

createsuperuser:
	docker compose -f $(COMPOSE_FILE) exec backend python manage.py createsuperuser

test:
	docker compose -f $(COMPOSE_FILE) run --rm backend python manage.py test

shell:
	docker compose -f $(COMPOSE_FILE) exec backend python manage.py shell

clean:
	@echo "🧹 Cleaning up containers, volumes, and images..."
	docker compose -f $(COMPOSE_FILE) down --volumes --remove-orphans
	docker system prune -f
