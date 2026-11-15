from fastapi import FastAPI
from backend.app.routers import items

app = FastAPI(title="Holiday Inventory API")
app.include_router(items.router)

@app.get("/")
def health_check():
    return {"status": "ok"}
