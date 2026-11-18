from fastapi import FastAPI
from backend.app.routers import items
from backend.app.routers import categories
from backend.app.routers import collections
from backend.app.routers import bins

app = FastAPI(title="Holiday Inventory API")
app.include_router(items.router)
app.include_router(categories.router)
app.include_router(collections.router)
app.include_router(bins.router)

@app.get("/")
def health_check():
    return {"status": "ok"}
