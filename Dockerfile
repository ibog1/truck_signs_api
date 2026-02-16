# Base image
FROM python:3.8-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Arbeitsverzeichnis
WORKDIR /app

# System-Dependencies (psycopg2 etc.)
RUN apt-get update && apt-get install -y \
    netcat-openbsd \
    build-essential \
    libpq-dev \
 && rm -rf /var/lib/apt/lists/*

# Requirements
COPY requirements.txt /app/
RUN pip install --upgrade pip && pip install -r requirements.txt

# Projektcode
COPY . /app/

# Port im Container (für Gunicorn)
EXPOSE 8020

# Entrypoint-Script
RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]
