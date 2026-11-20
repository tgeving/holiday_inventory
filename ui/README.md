# Holiday Inventory — Frontend & Playwright UI Tests

This folder contains the TypeScript frontend for **Holiday Inventory**, starting with **Get All Items** as a template for adding remaining endpoints. Playwright UI specs live under `automation/ui/items.spec.ts` and are configured from the repository root via `playwright.config.ts`.

## Project Layout

```text
holiday_inventory/
├── automation/
│   └── ui/
│       └── items.spec.ts         # Playwright UI test spec for Get All Items
├── backend/
│   └── app/
│       └── main.py               # FastAPI app (CORS configured for Vite dev server)
├── ui/
│   ├── index.html                # Served at / by Vite
│   ├── README.md                 # This file
│   ├── tsconfig.json             # ESM + Vite client TypeScript config for UI code
│   ├── styles/
│   │   └── styles.css            # Form, status banner, and table styling
│   └── src/
│       ├── apiClient.ts          # Typed fetch client for backend endpoints
│       ├── itemsPage.ts          # DOM rendering, filtering, and status handling
│       ├── type.ts               # TypeScript interfaces
│       └── vite-env.d.ts         # Vite client type declarations (import.meta.env)
├── .gitignore                    # Ignores node_modules/, test-results/, reports
├── package.json                  # Node/TypeScript/Playwright/Vite dependencies
├── playwright.config.ts          # Playwright config (testDir: './automation/ui')
├── pytest.ini                    # Pytest configuration for backend/API tests
├── requirements.txt              # Python backend and API test dependencies
└── tsconfig.json                 # Root TypeScript config (Playwright/Node; excludes ui/)
```

## Prerequisites & Setup

From the **repository root** (`holiday_inventory/`):

1. Install Node dev dependencies and Playwright browsers:
   ```bash
   npm install
   npx playwright install
   ```
   *(Keep Python backend and `pytest` packages in `requirements.txt`—do not add npm packages to `requirements.txt`.)*

2. Ensure `.gitignore` excludes generated and dependency directories:
   ```gitignore
   node_modules/
   test-results/
   playwright-report/
   blob-report/
   playwright/.cache/
   ```

3. Optionally configure `VITE_API_BASE_URL` in `ui/.env` (defaults to `http://localhost:8001` if unset):
   ```env
   VITE_API_BASE_URL=http://localhost:8001
   ```

## Running Locally

You need both the backend API server and the Vite UI server running:

1. **Start the backend API** (running on port `8001`):
   ```bash
   uvicorn backend.app.main:app --reload --port 8001
   ```

2. **Start the Vite UI server**:
   ```bash
   npx vite ui
   ```
   Open `http://localhost:5173` in your browser.

3. **Run Playwright UI tests**:
   ```bash
   npx playwright test automation/ui/items.spec.ts
   ```

## Troubleshooting & Lessons Learned

- **`process` not found in `playwright.config.ts`**: Installed `@types/node` (`npm install -D @types/node`) and ensured Node types were available to the root TypeScript config.
- **TypeScript `moduleResolution` deprecation error**: Updated `"moduleResolution"` from `"node"` (`node10`) to `"bundler"` in `tsconfig.json`.
- **`404 Not Found` at `http://localhost:5173`**: Vite serves `/` from `index.html` inside the target folder (`ui/index.html`) rather than `ui/src/index.html`. Moved `index.html` to `ui/index.html` and updated `<script type="module" src="./src/itemsPage.ts"></script>`.
- **Requests hitting `http://localhost:3000/items` or failing to connect**: Updated `ApiClient` and `itemsPage.ts` to default to `http://localhost:8001` (matching the backend port), then restarted Vite and hard-refreshed the browser.
- **CORS errors in the browser console**: Because the UI (`http://localhost:5173`) calls the API on another port (`http://localhost:8001`), added `CORSMiddleware` in `backend/app/main.py` allowing `http://localhost:5173` and `http://127.0.0.1:5173`.
- **Missing `./types` import and `import.meta` / `import.meta.env` errors**: Updated the import in `ui/src/itemsPage.ts` to `./type` (matching `ui/src/type.ts`), added `ui/src/vite-env.d.ts` with `/// <reference types="vite/client" />`, and created `ui/tsconfig.json` (`"module": "ESNext"`, `"moduleResolution": "bundler"`, `"types": ["vite/client"]`) while excluding `ui` from the root `tsconfig.json`.
- **Page loads styled HTML without rendering data (and no JS console error)**: `ui/src/itemsPage.ts` selects DOM elements via `data-testid` (`item-search`, `status-message`, `items-tbody`) and exits early if any are missing. Keep those `data-testid` attributes intact when editing `ui/index.html` or adding CSS classes.

## Adding More Endpoints

To replicate this pattern for additional resources (such as themes, categories, bins, locations, or collections):

1. Add the TypeScript interfaces to `ui/src/type.ts`.
2. Add typed methods to `ApiClient` in `ui/src/apiClient.ts` (note: FastAPI collection routes use a trailing slash like `/items/` to avoid `307` redirects).
3. Create the UI module/page in `ui/src/`, reuse `ui/styles/styles.css`, and add a matching Playwright test in `automation/ui/`.
