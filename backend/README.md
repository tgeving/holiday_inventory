# Holiday Inventory API

A Python backend built with FastAPI to manage holiday inventory items.

## Project Structure

```text
backend/
├── app/
│   ├── __init__.py
│   ├── main.py              # Initializes FastAPI and connects routers
│   ├── routers/
│   │   ├── __init__.py
│   │   └── items.py         # HTTP endpoints (GET, POST, etc.)
│   └── services/
│       ├── __init__.py
│       └── item_service.py  # Business logic and SQL database queries
├── tests/
│   └── unit/
│       └── test_item_service.py  # Isolated service unit tests
└── README.md
```

### Architecture Overview
* **`routers/`** — Handles incoming HTTP requests, validates inputs, and returns JSON responses.
* **`services/`** — Contains core business logic and SQL queries separated from web routing.
* **`tests/unit/`** — Holds fast, isolated developer unit tests for service functions.

## Setup & Installation

From the root `holiday_inventory` directory, install the dependencies listed in `requirements.txt`:

```bash
pip install -r requirements.txt
```

*(Note: `fastapi` and `uvicorn` are installed individually instead of `fastapi[standard]` to avoid `PyYAML` wheel build errors on newer Python versions on Windows.)*

## Running the Development Server

From the root `holiday_inventory` directory, start the server with auto-reload enabled:

```bash
uvicorn backend.app.main:app --reload
```

* **API Base URL:** `http://127.0.0.1:8000`
* **Interactive API Docs (Swagger UI):** `http://127.0.0`

## Running Backend Unit Tests

From the root `holiday_inventory` directory:

```bash
pytest -v backend/tests/unit
```
