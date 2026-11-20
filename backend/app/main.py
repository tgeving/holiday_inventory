from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from backend.app.routers import items
from backend.app.routers import categories
from backend.app.routers import collections
from backend.app.routers import bins
from backend.app.routers import locations
from backend.app.routers import themes

app = FastAPI(title="Holiday Inventory API")
app.include_router(items.router)
app.include_router(categories.router)
app.include_router(collections.router)
app.include_router(bins.router)
app.include_router(locations.router)
app.include_router(themes.router)

@app.get("/")
def health_check():
    return {"status": "ok"}


origins = [
    "http://localhost:5173",
    "http://127.0.0.1:5173",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)