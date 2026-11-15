from backend.app.database import get_db_connection

ALLOWED_SORT_COLUMNS = {
    "created_at": "i.created_at",
    "item_name": "i.item_name",
    "sku": "i.sku",
    "actual_total_no": "i.actual_total_no",
}
ALLOWED_SORT_ORDERS = {"asc": "ASC", "desc": "DESC"}

def get_all_items(
    category: str | None = None,
    collection: str | None = None,
    bin_no: str | None = None,
    search: str | None = None,
    sort_by: str = "created_at",
    order: str = "asc",
    limit: int = 50,
    offset: int = 0,
) -> list[dict]:
    query = """
        SELECT 
            i.id,
            m.manufacturer_name, 
            c.category_name, 
            c2.collection_name, 
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

    if category:
        conditions.append("c.category_name ILIKE %s")
        params.append(category)

    if collection:
        conditions.append("c2.collection_name ILIKE %s")
        params.append(collection)

    if bin_no:
        conditions.append("b.bin_no ILIKE %s")
        params.append(bin_no)

    if search:
        conditions.append("(i.item_name ILIKE %s OR i.sku ILIKE %s)")
        params.extend([f"%{search}%", f"%{search}%"])

    if conditions:
        query += " WHERE " + " AND ".join(conditions)

    safe_column = ALLOWED_SORT_COLUMNS.get(sort_by, "i.created_at")
    safe_order = ALLOWED_SORT_ORDERS.get(order.lower(), "ASC")
    query += f" ORDER BY {safe_column} {safe_order}, i.id ASC LIMIT %s OFFSET %s;"
    params.extend([limit, offset])

    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(query, params)
            return cur.fetchall()
