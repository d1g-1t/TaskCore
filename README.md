# TaskCore

**MVP-решение для REST API по управлению задачами**

## Технологический стек

**Backend:** Django 3.2 • Django REST Framework • PostgreSQL  
**Frontend:** React 18 • Bootstrap 5  
**DevOps:** Docker Compose • Nginx • Gunicorn  
**Практики:** Environment-based config • Healthchecks • Query optimization • Pagination • Caching

## Быстрый старт

```bash
git clone https://github.com/d1g-1t/taski-docker.git taskcore
cd taskcore
make setup
```

Приложение запустится на `http://localhost:8000`

## Команды

| Команда | Описание |
|---------|----------|
| `make setup` | Полная установка и запуск (первый раз) |
| `make up` | Запустить сервисы |
| `make down` | Остановить и удалить контейнеры |
| `make migrate` | Применить миграции БД |
| `make test` | Запустить тесты |
| `make logs` | Просмотр логов |

## API Endpoints

- `GET /api/tasks/` — Список задач (пагинация, кэш)
- `POST /api/tasks/` — Создание задачи
- `GET /api/tasks/{id}/` — Детали задачи
- `PUT /api/tasks/{id}/` — Обновление
- `DELETE /api/tasks/{id}/` — Удаление
- `GET /admin/` — Django Admin

## Архитектурные решения

### Backend
- **Оптимизация БД:** `.only()` для минимизации SELECT запросов
- **Кэширование:** 5-секундный кэш списка задач, инвалидация при записи
- **Пагинация:** 20 элементов/страница, настраиваемый `page_size`
- **Валидация:** Сериализаторы с кастомной логикой проверки

### DevOps
- **Docker:** Multi-stage builds, non-root user, healthchecks
- **Конфигурация:** 12-factor app principles, env-based settings
- **Безопасность:** Secrets в переменных окружения, ALLOWED_HOSTS

### Структура
```
taskcore/
├── backend/
│   ├── tasks/          # Приложение задач
│   ├── backend/        # Настройки проекта
│   └── Dockerfile
├── frontend/           # React SPA
├── gateway/            # Nginx reverse proxy
└── docker-compose.yml
```

## Конфигурация

Файл `.env` создается автоматически при `make setup`:

```env
POSTGRES_DB=taskcore
POSTGRES_USER=taskcore
POSTGRES_PASSWORD=taskcore
DJANGO_SECRET_KEY=<сгенерируйте для production>
DJANGO_DEBUG=True
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1
```
