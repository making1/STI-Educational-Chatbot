@echo off
cd /d %~dp0
if not exist .venv (
  py -m venv .venv
)
call .venv\Scripts\activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
python scripts\init_db.py
python scripts\train_model.py
echo Starting STI Educational Inquiry System at http://127.0.0.1:8000
uvicorn app.main:app --host 127.0.0.1 --port 8000
