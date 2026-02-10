#!/usr/bin/env bash
set -e

DB_HOST=${DB_HOST:-db}
DB_PORT=${DB_PORT:-5432}

echo "Waiting for postgres to connect at ${DB_HOST}:${DB_PORT} ..."

while ! nc -z "${DB_HOST}" "${DB_PORT}"; do
  sleep 0.1
done

echo "PostgreSQL is active"

python manage.py makemigrations
python manage.py migrate
python manage.py collectstatic --noinput

# createsuperuser (idempotent, gesteuert über Env-Vars)
if [ -n "${DJANGO_SUPERUSER_USERNAME}" ] && [ -n "${DJANGO_SUPERUSER_EMAIL}" ] && [ -n "${DJANGO_SUPERUSER_PASSWORD}" ]; then
  echo "Ensuring superuser ${DJANGO_SUPERUSER_USERNAME} exists..."
  python manage.py shell <<EOF
from django.contrib.auth import get_user_model
User = get_user_model()
username = "${DJANGO_SUPERUSER_USERNAME}"
email = "${DJANGO_SUPERUSER_EMAIL}"
password = "${DJANGO_SUPERUSER_PASSWORD}"
if not User.objects.filter(username=username).exists():
    User.objects.create_superuser(username=username, email=email, password=password)
EOF
fi

echo "Starting Gunicorn..."
gunicorn truck_signs_designs.wsgi:application --bind 0.0.0.0:8020
