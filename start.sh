#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
PYTHON="${PYTHON:-python3}"
if [ ! -d ".venv" ]; then
  "$PYTHON" -m venv .venv
fi
. .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
python scripts/init_db.py
python scripts/train_model.py
echo "Starting STI Educational Inquiry System at http://127.0.0.1:8000"
exec uvicorn app.main:app --host 127.0.0.1 --port 8000
