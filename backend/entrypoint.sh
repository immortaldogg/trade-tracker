#!/bin/bash
set -e

# Wait for the DB to be ready (optional but good for Postgres timing issues)
# echo "Waiting for postgres..."
# until nc -z $DB_HOST $DB_PORT; do
#   sleep 0.5
# done

# Run migration (choose one of the two below)
alembic upgrade head
# python run_migrations.py  # if you're using Base.metadata.create_all()

# Start the backend server
exec uvicorn main:app --host 0.0.0.0 --port 8000