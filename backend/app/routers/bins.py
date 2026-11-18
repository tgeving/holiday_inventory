from typing import Literal
from fastapi import APIRouter, Query
from backend.app.services import bins_service

router = APIRouter(prefix="/bins", tags=["Bins"])

@router.get("/")
def read_all_bins(
    search: int | None = Query(default=None, description="Search by exact bin number"),
    sort_by: Literal["created_at", "bin_no"] = Query(
        default="created_at", description="Column to sort by"
    ),
    order: Literal["asc", "desc"] = Query(
        default="asc", description="Sort direction"
    ),
    limit: int = Query(default=0, ge=1, le=100, description="Max items to return"),
    offset: int = Query(default=0, ge=0, description="Number of items to skip"),
):
    """Fetch all holiday inventory bins with optional filtering, sorting, and pagination.
    Args:
        search: Exact bin number to match.
        sort_by: Column name to sort results by (e.g., "created_at", "bin_no").
        order: Sort direction, either "asc" or "desc".
        limit: Maximum number of items to return per page.
        offset: Number of items to skip before returning results.
    """
    return bins_service.get_all_bins(
        search=search,
        sort_by=sort_by,
        order=order,
        limit=limit,
        offset=offset,
    )