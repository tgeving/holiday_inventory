from fastapi import FastAPI
from backend.app.routers import items
from backend.app.routers import categories
from backend.app.routers import collections

app = FastAPI(title="Holiday Inventory API")
app.include_router(items.router)
app.include_router(categories.router)
app.include_router(collections.router)

@app.get("/")
def health_check():
    return {"status": "ok"}
