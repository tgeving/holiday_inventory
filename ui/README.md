# Holiday Inventory — Frontend & Playwright UI Tests

This folder contains the TypeScript frontend for **Holiday Inventory**[cite: 1, 2], starting with **Get All Items** as a template for adding remaining endpoints (`bins`, `categories`, `collections`, `items`, `locations`, and `themes`)[cite: 1, 2]. Playwright UI specs live under `automation/ui/items.spec.ts` and are configured from the repository root via `playwright.config.ts`[cite: 1, 2].

## Project Layout

```text
holiday_inventory/
├── automation/
│   ├── api/
│   ├── lib/
│   │   ├── bins.py
│   │   ├── category.py
│   │   ├── collections.py
│   │   ├── items.py
│   │   ├── locations.py
│   │   └── themes.py
│   └── ui/
│       └── items.spec.ts         # Playwright UI test spec for Get All Items
├── backend/
│   ├── app/
│   │   ├── routers/
│   │   │   ├── bins.py
│   │   │   ├── categories.py
│   │   │   ├── collections.py
│   │   │   ├── items.py
│   │   │   ├── locations.py
│   │   │   └── themes.py
│   │   ├── services/
│   │   │   ├── bins_service.py
│   │   │   ├── categories_service.py
│   │   │   ├── collections_service.py
│   │   │   ├── item_service.py
│   │   │   ├── locations_service.py
│   │   │   └── themes_service.py
│   │   ├── database.py
│   │   └── main.py               # FastAPI app (CORS configured for Vite dev server)
│   └── README.md
├── db/
├── tests/
├── ui/
│   ├── index.html                # Served at / by Vite
│   ├── README.md                 # This file
│   ├── tsconfig.json             # ESM + Vite client TypeScript config for UI code
│   ├── styles/
│   │   └── styles.css            # Form, status banner, and table styling
│   └── src/
│       ├── api/
│       │   └── apiItems.ts       # Typed fetch client for items endpoints
│       ├── pages/
│       │   └── itemsPage.ts      # DOM rendering, filtering, and status handling
│       ├── types/
│       │   └── itemTypes.ts      # TypeScript interfaces for items
│       └── vite-env.d.ts         # Vite client type declarations (import.meta.env)
├── .env
├── .gitignore                    # Ignores node_modules/, test-results/, reports
├── package.json                  # Node/TypeScript/Playwright/Vite dependencies
├── package-lock.json
├── playwright.config.ts          # Playwright config (testDir: './automation/ui')
├── pytest.ini                    # Pytest configuration for backend/API tests
├── README.md
├── requirements.txt              # Python backend and API test dependencies
└── tsconfig.json                 # Root TypeScript config (Playwright/Node; excludes ui/)
```[cite: 1, 2]

## Prerequisites & Setup

From the **repository root** (`holiday_inventory/`)[cite: 1, 2]:

1. Install Node dev dependencies and Playwright browsers:
   ```bash
   npm install
   npx playwright install
