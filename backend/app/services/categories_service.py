from backend.app.database import get_db_connection

ALLOWED_SORT_COLUMNS = {
    "created_at": "created_at",
    "category_name": "category_name"
}
ALLOWED_SORT_ORDERS = {"asc": "ASC", "desc": "DESC"}

def get_all_categories(
    search: str | None = None,
    sort_by: str = "created_at",
    order: str = "asc",
    limit: int = 50,
    offset: int = 0,
) -> list[dict]:
    """Fetch all holiday inventory categories with optional searching, sorting, and pagination.
    Args:
        search: Partial keyword to match across category name. Defaults to None.
        sort_by: Column name to sort results by (e.g., "created_at", "category_name"). Defaults to "created_at".
        order: Sort direction, either "asc" or "desc". Defaults to "asc".
        limit: Maximum number of items to return per page. Defaults to 0
        offset: Number of items to skip before returning results. Defaults to 0
    """

    query = """
        SELECT 
            id, 
            category_name,
            created_at,
            updated_at,
            deleted_at
        FROM category  
    """
    conditions = []
    params = []

    if search:
        pattern = f"%{search}%"
        
        conditions.append("""(category_name ILIKE %s)""")
        params.extend([pattern])

    if conditions:
        query += " WHERE " + " AND ".join(conditions)

    safe_column = ALLOWED_SORT_COLUMNS.get(sort_by, "created_at")
    safe_order = ALLOWED_SORT_ORDERS.get(order.lower(), "ASC")

    # Single ORDER BY statement
    query += f" ORDER BY {safe_column} {safe_order}, id ASC"

    # Clean conditional handling for limit/offset
    if limit > 0 and offset > 0:
        query += f" LIMIT %s OFFSET %s;"
        params.extend([limit, offset])    
    elif limit > 0:
        query += f" LIMIT %s;"
        params.extend([limit])    
    elif offset > 0:
        query += f" OFFSET %s;"
        params.extend([offset])    
    else:
        query += ";"
    
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(query, params)
            return cur.fetchall()
        