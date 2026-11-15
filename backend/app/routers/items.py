from fastapi import APIRouter
from backend.app.services import item_service

router = APIRouter(prefix="/items", tags=["Items"])

@router.get("/")
def read_all_items():
    return item_service.get_all_items()
