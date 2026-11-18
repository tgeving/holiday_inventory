from typing import Literal
from fastapi import APIRouter, Query
from backend.app.services import collections_service

router = APIRouter(prefix="/collections", tags=["Collections"])

@router.get("/")
def read_all_collections(
    search: str | None = Query(default=None, description="Search by collection name"),
    sort_by: Literal["created_at", "collection_name"] = Query(
        default="created_at", description="Column to sort by"
    ),
    order: Literal["asc", "desc"] = Query(
        default="asc", description="Sort direction"
    ),
    limit: int = Query(default=0, ge=1, le=100, description="Max items to return"),
    offset: int = Query(default=0, ge=0, description="Number of items to skip"),
):
    """Fetch all holiday inventory collecitons with optional filtering, sorting, and pagination.
    Args:
        search: Partial keyword to match across colleciton name.
        sort_by: Column name to sort results by (e.g., "created_at", "collection_name").
        order: Sort direction, either "asc" or "desc".
        limit: Maximum number of items to return per page.
        offset: Number of items to skip before returning results.
    """
    return collections_service.get_all_collections(
        search=search,
        sort_by=sort_by,
        order=order,
        limit=limit,
        offset=offset,
    )
