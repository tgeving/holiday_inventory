from typing import Literal
from fastapi import APIRouter, Query
from backend.app.services import item_service

router = APIRouter(prefix="/items", tags=["Items"])

@router.get("/")
def read_all_items(
    category: str | None = Query(default=None, description="Filter by category name"),
    collection: str | None = Query(default=None, description="Filter by collection name"),
    bin_no: str | None = Query(default=None, description="Filter by storage bin number"),
    search: str | None = Query(default=None, description="Search by item name or SKU"),
    sort_by: Literal["created_at", "item_name", "sku", "actual_total_no"] = Query(
        default="created_at", description="Column to sort by"
    ),
    order: Literal["asc", "desc"] = Query(
        default="asc", description="Sort direction"
    ),
    limit: int = Query(default=50, ge=1, le=200, description="Max items to return"),
    offset: int = Query(default=0, ge=0, description="Number of items to skip"),
):
    return item_service.get_all_items(
        category=category,
        collection=collection,
        bin_no=bin_no,
        search=search,
        sort_by=sort_by,
        order=order,
        limit=limit,
        offset=offset,
    )
