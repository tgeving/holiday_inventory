from unittest.mock import MagicMock, patch
from backend.app.services import item_service


def _setup_mock_cursor(mock_get_conn, return_rows=None):
    """Helper to mock the psycopg connection and cursor context managers."""
    mock_cursor = MagicMock()
    mock_cursor.fetchall.return_value = return_rows or []
    mock_get_conn.return_value.__enter__.return_value.cursor.return_value.__enter__.return_value = mock_cursor
    return mock_cursor


@patch("backend.app.services.item_service.get_db_connection")
def test_get_all_items_default_query(mock_get_conn):
    """Test that get_all_items constructs the correct SQL query with default parameters and returns expected results."""
    
    item_name = "Santa & Mrs. Clause"
    fake_rows = [
        {
            "id": 1,
            "manufacturer_id": 1,
            "collection_id": 2,
            "category_id": 3,
            "bin_id": 11,
            "manufacturer_name": "Department 56",
            "category_name": "House",
            "collection_name": "North Pole Series",
            "created_at": "2026-11-15T12:00:00",
            "sku": "NP-101",
            "item_name": item_name,
            "full_set": True,
            "org_total_no": 1,
            "actual_total_no": 1,
            "total_missing_no": 0,
            "notes": "Includes light cord",
        }
    ]
    mock_cursor = _setup_mock_cursor(mock_get_conn, fake_rows)

    result = item_service.get_all_items()

    executed_sql, executed_params = mock_cursor.execute.call_args[0]
    assert "WHERE" not in executed_sql
    assert "ORDER BY i.created_at ASC, i.id ASC LIMIT %s;" in executed_sql
    # Updated: removed duplicate line and set params to match [limit, offset] logic ([50])
    assert executed_params == [50]
    assert len(result) == 1
    assert result[0]["item_name"] == item_name


@patch("backend.app.services.item_service.get_db_connection")
def test_get_all_items_with_multi_column_search(mock_get_conn):
    """Test that get_all_items constructs the correct SQL query when a search term is provided and returns expected results."""
    mock_cursor = _setup_mock_cursor(mock_get_conn)

    search_term = "North Pole Series"
    item_service.get_all_items(search=search_term)

    executed_sql, executed_params = mock_cursor.execute.call_args[0]
    assert "WHERE (" in executed_sql
    assert "i.item_name ILIKE %s" in executed_sql
    assert "c2.collection_name ILIKE %s" in executed_sql
    assert "b.bin_no::text ILIKE %s" in executed_sql
    # Updated: Waterfall block expects 7 pattern parameters + default [50] pagination = 9 items total
    assert executed_params == [f"%{search_term}%"] * 7 + [50]


@patch("backend.app.services.item_service.get_db_connection")
def test_get_all_items_with_filters_sorting_and_pagination(mock_get_conn):
    """Test that get_all_items constructs the correct SQL query with filters, sorting, and pagination."""
    mock_cursor = _setup_mock_cursor(mock_get_conn)

    category = "House"
    limit = 10
    offset = 20

    item_service.get_all_items(
        search=category,
        sort_by="item_name",
        order="desc",
        limit=limit,
        offset=offset,
    )

    executed_sql, executed_params = mock_cursor.execute.call_args[0]
    assert "c.category_name ILIKE %s" in executed_sql
    assert "c2.collection_name ILIKE %s" in executed_sql
    assert "b.bin_no::text ILIKE %s" in executed_sql
    assert "ORDER BY i.item_name DESC, i.id ASC LIMIT %s OFFSET %s;" in executed_sql
    # Updated: Waterfall check sends the search pattern 7 times + explicit limit and offset
    assert executed_params == [f"%{category}%"] * 7 + [limit, offset]