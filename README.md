# STI Educational Inquiry System

A small, self-contained reference implementation of:

**User → STI Inquiry → NLP Preprocessing → Intent Classification + Entity Extraction → Safety Layer → STI Knowledge Base → Personalized Educational Content → Feedback → Model/System Evaluation**

## What is included

- SQLite database with STI knowledge-base content in **English and Swahili**
- FastAPI application with:
  - user inquiry endpoint
  - simple browser UI
  - feedback capture
  - admin dashboard
  - admin content management endpoint
  - health/safety response handling
- Lightweight NLP pipeline:
  - text normalization
  - TF-IDF + logistic-regression intent classifier
  - dictionary/regex entity extraction
- Safety layer that:
  - avoids diagnosis
  - detects urgent red-flag language and recommends urgent professional care
  - detects crisis/self-harm language and routes to immediate local emergency/support services
  - handles sexual-health questions in an educational, non-judgmental way
- Evaluation dataset and evaluation script
- One-command startup scripts
- No external database server required

## Quick start

### Linux/macOS

```bash
./start.sh
```

### Windows

```bat
start.bat
```

The script creates `.venv`, installs dependencies, initializes the SQLite database, trains the NLP model, and starts the server.

Open:

- http://127.0.0.1:8000
- Admin: http://127.0.0.1:8000/admin

Default admin credentials come from `.env`:
- username: `admin`
- password: `change-me`

**Change the default password before deployment.**

## Manual setup

```bash
python -m venv .venv
# Linux/macOS
source .venv/bin/activate
# Windows
# .venv\Scripts\activate

pip install -r requirements.txt
python scripts/init_db.py
python scripts/train_model.py
uvicorn app.main:app --reload
```

## Test the system

```bash
python evaluation/evaluate.py
```

## API examples

### Inquiry

```bash
curl -X POST http://127.0.0.1:8000/api/inquiry \
  -H "Content-Type: application/json" \
  -d '{"text":"What are common symptoms of chlamydia?","language":"en"}'
```

### Feedback

```bash
curl -X POST http://127.0.0.1:8000/api/feedback \
  -H "Content-Type: application/json" \
  -d '{"inquiry_id":1,"rating":5,"comment":"Clear and useful"}'
```

## Architecture

1. **Inquiry** enters through the UI/API.
2. **Preprocessing** normalizes text.
3. **Intent classification** predicts an educational intent.
4. **Entity extraction** finds STI names and symptom terms.
5. **Safety layer** checks for urgent/crisis language and prevents diagnostic claims.
6. **Knowledge base** retrieves bilingual educational content.
7. **Personalization** selects language and adds context based on detected entities/intent.
8. **Feedback** is stored in SQLite.
9. **Evaluation** measures intent accuracy/F1 and produces a JSON report.

## Health/safety note

This is an educational software reference implementation, not a medical diagnostic or treatment system. It should not be used to determine whether a person has an STI or to replace professional medical care. For production use, have the content and safety rules reviewed by qualified clinicians and adapt emergency/service-routing information to the deployment country.

## Flowchart

```text
┌─────────────┐
│    User     │
└──────┬──────┘
       │ STI inquiry
       ▼
┌────────────────────┐
│ NLP Preprocessing  │
└────────┬───────────┘
         ▼
┌────────────────────────────────┐
│ Intent Classification +        │
│ Entity Extraction              │
└───────────────┬────────────────┘
                ▼
┌────────────────────┐
│    Safety Layer    │
└────────┬───────────┘
         ▼
┌────────────────────┐
│ STI Knowledge Base │
└────────┬───────────┘
         ▼
┌──────────────────────────────┐
│ Personalized Educational     │
│ Content                      │
└──────────────┬───────────────┘
               ▼
┌────────────────────┐
│      Feedback      │
└────────┬───────────┘
         ▼
┌──────────────────────────────┐
│ Model/System Evaluation      │
└──────────────────────────────┘
```
