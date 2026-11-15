from backend.app.database import get_db_connection

def get_all_items() -> list[dict]:
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id, item_name, sku FROM item ORDER BY id;")
            return cur.fetchall()
