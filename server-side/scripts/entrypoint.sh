#!/bin/bash

set -e
set -x

alembic -c /app/alembic.ini upgrade head

exec uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4