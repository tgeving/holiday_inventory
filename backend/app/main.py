from fastapi import FastAPI
from backend.app.routers import items
from backend.app.routers import categories

app = FastAPI(title="Holiday Inventory API")
app.include_router(items.router)
app.include_router(categories.router)

@app.get("/")
def health_check():
    return {"status": "ok"}
