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

echo "Starting Gunicorn..."
gunicorn truck_signs_designs.wsgi:application --bind 0.0.0.0:8020
