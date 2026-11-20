from typing import Literal
from fastapi import APIRouter, Query
from backend.app.services import themes_service 

router = APIRouter(prefix="/themes", tags=["Themes"])

@router.get("/")
def read_all_themes(
    search: str | None = Query(default=None, description="Search by exact theme name"),
    sort_by: Literal["created_at", "theme_name"] = Query(
        default="created_at", description="Column to sort by"
    ),
    order: Literal["asc", "desc"] = Query(
        default="asc", description="Sort direction"
    ),
    limit: int = Query(default=0, ge=1, le=100, description="Max items to return"),
    offset: int = Query(default=0, ge=0, description="Number of items to skip"),
):
    """Fetch all holiday inventory themes with optional filtering, sorting, and pagination.
    Args:
        search: Exact theme name to match.
        sort_by: Column name to sort results by (e.g., "created_at", "theme_name").
        order: Sort direction, either "asc" or "desc".
        limit: Maximum number of items to return per page.
        offset: Number of items to skip before returning results.
    """
    return themes_service.get_all_themes(
        search=search,
        sort_by=sort_by,
        order=order,
        limit=limit,
        offset=offset,
    )