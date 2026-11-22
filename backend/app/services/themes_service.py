from backend.app.database import get_db_connection

ALLOWED_SORT_COLUMNS = {
    "created_at": "created_at",
    "theme_name": "theme_name"
}
ALLOWED_SORT_ORDERS = {"asc": "ASC", "desc": "DESC"}

def get_all_themes(
    search: int | None = None,
    sort_by: str = "created_at",
    order: str = "asc",
    limit: int = 50,
    offset: int = 0,
) -> list[dict]:
    """Fetch all holiday inventory theme name with optional searching, sorting, and pagination.
    Args:
        search: Theme name to match. Defaults to None.
        sort_by: Column name to sort results by (e.g., "created_at", "theme_name"). Defaults to "created_at".
        order: Sort direction, either "asc" or "desc". Defaults to "asc".
        limit: Maximum number of items to return per page. Defaults to 50
        offset: Number of items to skip before returning results. Defaults to 0
    """
    query = """
      SELECT 
            t.id as theme_id,
            m.id as manufacturer_id,
            m.manufacturer_name, 
            c.id as category_id,
            c.category_name, 
            c2.id as collection_id,
            c2.collection_name, 
            b.id as bin_id,
            b.bin_no, 
            t.created_at, 
            t.theme_name, 
            t.theme_year 
        FROM theme t 
        LEFT JOIN bin b ON t.bin_id = b.id 
        LEFT JOIN category c ON t.category_id = c.id
        LEFT JOIN collection c2 ON t.collection_id = c2.id
        LEFT JOIN manufacturer m ON t.manufacturer_id = m.id
        LEFT JOIN item i ON t.item_id = i.id
    """

    query_back = """
        SELECT 
            id, 
            collection_id,
            category_id,
            item_id,
            location_id,
            line_no,
            theme_name,
            theme_year,
            created_at,
            updated_at,
            deleted_at
        FROM theme  
    """
    conditions = []
    params = []

    if search is not None:
        conditions.append("theme_name = %s")
        params.append(search)

    if conditions:
        query += " WHERE " + " AND ".join(conditions)

    safe_column = ALLOWED_SORT_COLUMNS.get(sort_by, "created_at")
    safe_order = ALLOWED_SORT_ORDERS.get(order.lower(), "ASC")

    query += f" ORDER BY {safe_column} {safe_order}, t.id ASC"

    if limit > 0 and offset > 0:
        query += " LIMIT %s OFFSET %s;"
        params.extend([limit, offset])    
    elif limit > 0:
        query += " LIMIT %s;"
        params.extend([limit])    
    elif offset > 0:
        query += " OFFSET %s;"
        params.extend([offset])    
    else:
        query += ";"
    
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(query, params)
            return cur.fetchall()