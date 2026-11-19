from unittest.mock import MagicMock, patch
from backend.app.services import categories_service


def _setup_mock_cursor(mock_get_conn, return_rows=None):
    """Helper to mock the psycopg connection and cursor context managers."""
    mock_cursor = MagicMock()
    mock_cursor.fetchall.return_value = return_rows or []
    mock_get_conn.return_value.__enter__.return_value.cursor.return_value.__enter__.return_value = mock_cursor
    return mock_cursor


@patch("backend.app.services.categories_service.get_db_connection")
def test_get_all_categories_default_query(mock_get_conn):
    """Test that get_all_categories constructs the correct SQL query with default parameters and returns expected results."""
    
    category_name = "Accessories"
    fake_rows = [
        {
            "id": 1,
            "category_name": category_name,
            "created_at": "2026-11-15T12:00:00"
        }
    ]
    mock_cursor = _setup_mock_cursor(mock_get_conn, fake_rows)

    # Note: If service default limit is 50, executed_params will be [50]. 
    # If service default limit is 0, it will be []. Let's match whatever your service defaults to.
    result = categories_service.get_all_categories()

    executed_sql, executed_params = mock_cursor.execute.call_args[0]
    assert "WHERE" not in executed_sql
    assert "ORDER BY created_at ASC, id ASC LIMIT %s;" in executed_sql
    assert executed_params == [50]  # Matches limit=50 default in service
    assert len(result) == 1
    assert result[0]["category_name"] == category_name


@patch("backend.app.services.categories_service.get_db_connection")  
def test_get_all_categories_with_search(mock_get_conn):
    """Test that get all categories based off of the search term 'Trees' and returns expected results."""
    mock_cursor = _setup_mock_cursor(mock_get_conn)

    search_term = "Trees"
    categories_service.get_all_categories(search=search_term)

    executed_sql, executed_params = mock_cursor.execute.call_args[0]
    assert "WHERE (" in executed_sql
    assert "category_name ILIKE %s" in executed_sql
    # Fixed: Categories only search 1 field, so 1 pattern parameter + default [50] limit = 2 params total
    assert executed_params == [f"%{search_term}%", 50]


@patch("backend.app.services.categories_service.get_db_connection")  
def test_get_all_categories_with_filters_sorting_and_pagination(mock_get_conn):
    """Test that get_all_categories constructs the correct SQL query with filters, sorting, and pagination."""
    mock_cursor = _setup_mock_cursor(mock_get_conn)

    category = "Figurine"
    limit = 10
    offset = 20

    categories_service.get_all_categories(
        search=category,
        sort_by="category_name",
        order="desc",
        limit=limit,
        offset=offset,
    )

    executed_sql, executed_params = mock_cursor.execute.call_args[0]
    assert "category_name ILIKE %s" in executed_sql
    assert "ORDER BY category_name DESC, id ASC LIMIT %s OFFSET %s;" in executed_sql
    # Fixed: 1 search pattern + explicit limit and offset
    assert executed_params == [f"%{category}%", limit, offset]
    