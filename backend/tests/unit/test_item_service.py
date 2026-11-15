from unittest.mock import MagicMock, patch
from backend.app.services import item_service

@patch("backend.app.services.item_service.get_db_connection")
def test_get_all_items_queries_database(mock_get_conn):
    # Setup fake database response
    mock_cursor = MagicMock()
    mock_cursor.fetchall.return_value = [
        {"id": 1, "name": "LED String Lights", "category": "Lighting", "quantity": 10}
    ]
    mock_get_conn.return_value.__enter__.return_value.cursor.return_value.__enter__.return_value = mock_cursor

    # Run service function
    items = item_service.get_all_items()

    # Verify SQL executed and returned expected rows
    mock_cursor.execute.assert_called_once_with(
        "SELECT id, name, category, quantity FROM items ORDER BY id;"
    )
    assert len(items) == 1
    assert items["name"] == "LED String Lights"
