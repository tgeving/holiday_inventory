from backend.app.database import get_db_connection

ALLOWED_SORT_COLUMNS = {
    "created_at": "i.created_at",
    "item_name": "i.item_name",
    "sku": "i.sku",
    "actual_total_no": "i.actual_total_no",
}
ALLOWED_SORT_ORDERS = {"asc": "ASC", "desc": "DESC"}

def get_all_items(
    search: str | None = None,
    sort_by: str = "created_at",
    order: str = "asc",
    limit: int = 50,
    offset: int = 0,
) -> list[dict]:
    """Fetch all holiday inventory items with optional filtering, sorting, and pagination.
    Args:
        search: Partial keyword to match across item name, SKU, category,
            collection, manufacturer, or bin number. Defaults to None.
        sort_by: Column name to sort results by (e.g., "created_at", "item_name"). Defaults to "created_at".
        order: Sort direction, either "asc" or "desc". Defaults to "asc".
        limit: Maximum number of items to return per page. Defaults to 0
        offset: Number of items to skip before returning results. Defaults to 0
    """

    query = """
        SELECT 
            i.id as item_id,
            m.id as manufacturer_id,
            m.manufacturer_name, 
            c.id as category_id,
            c.category_name, 
            c2.id as collection_id,
            c2.collection_name, 
            b.id as bin_id,
            b.bin_no, 
            i.created_at, 
            i.sku, 
            i.item_name, 
            i.full_set, 
            i.org_total_no, 
            i.actual_total_no, 
            i.total_missing_no, 
            i.notes 
        FROM item i 
        LEFT JOIN bin b ON i.bin_id = b.id 
        LEFT JOIN category c ON i.category_id = c.id
        LEFT JOIN collection c2 ON i.collection_id = c2.id
        LEFT JOIN manufacturer m ON i.manufacturer_id = m.id
    """
    conditions = []
    params = []

    if search:
        pattern = f"%{search}%"
        
        # Strict Hierarchical (Waterfall) Logic:
        # 1. Checks if collection name matches.
        # 2. If NO items match the collection name, it falls back to checking 
        #    categories, item names, manufacturers, and bins (blocking lower noise 
        #    if a higher tier match is active).
        conditions.append("""(
            c2.collection_name ILIKE %s
            OR (
                NOT EXISTS (
                    SELECT 1 
                    FROM item sub_i 
                    LEFT JOIN collection sub_c2 ON sub_i.collection_id = sub_c2.id 
                    WHERE sub_c2.collection_name ILIKE %s
                ) 
                AND (
                    c.category_name ILIKE %s 
                    OR i.item_name ILIKE %s 
                    OR m.manufacturer_name ILIKE %s 
                    OR b.bin_no::text ILIKE %s
                    OR i.sku ILIKE %s
                )
            )
        )""")
        params.extend([pattern, pattern, pattern, pattern, pattern, pattern, pattern])

    if conditions:
        query += " WHERE " + " AND ".join(conditions)

    safe_column = ALLOWED_SORT_COLUMNS.get(sort_by, "i.created_at")
    safe_order = ALLOWED_SORT_ORDERS.get(order.lower(), "ASC")

    # Single ORDER BY statement
    query += f" ORDER BY {safe_column} {safe_order}, i.id ASC"

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
        