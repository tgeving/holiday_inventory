# Holiday Inventory
Welcome. I built this application to migrate a static Google Spreadsheet into a scalable, automated full-stack solution. The tech stack features a FastAPI and PostgreSQL backend, TypeScript and Playwright for web scraping and end-to-end testing, and Pytest for backend API validation.

A full-stack application for tracking and managing holiday decorations and supplies.

## Project Structure

```text
holiday_inventory/
├── automation/
│   └── api/
│       └── test_items_api.py     # End-to-end API contract & integration tests
├── backend/
│   ├── app/                      # FastAPI application (routers & services)
│   ├── tests/
│   │   └── unit/                 # Developer unit tests
│   └── README.md                 # Backend setup & API documentation
├── frontend/                     # Web user interface
├── pytest.ini                    # Configures root pythonpath for pytest
├── requirements.txt              # Python project dependencies
└── README.md
```

## Quick Start (Python Environment)

Install all backend and testing dependencies from the root folder:

```bash
pip install -r requirements.txt
```

## Running Tests

* **Run Unit Tests:** `pytest -v backend/tests/unit`
* **Run API Automation Tests** *(requires backend server running)*: `pytest -v automation/api`

See **[backend/README.md](./backend/README.md)** for server startup instructions and endpoint details.
