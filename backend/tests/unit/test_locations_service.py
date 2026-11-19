from unittest.mock import MagicMock, patch
from backend.app.services import locations_service


def _setup_mock_cursor(mock_get_conn, return_rows=None):
    """Helper to mock the psycopg connection and cursor context managers."""
    mock_cursor = MagicMock()
    mock_cursor.fetchall.return_value = return_rows or []
    mock_get_conn.return_value.__enter__.return_value.cursor.return_value.__enter__.return_value = mock_cursor
    return mock_cursor


@patch("backend.app.services.locations_service.get_db_connection")
def test_get_all_locations_default_query(mock_get_conn):
    """Test that get_all_locations constructs the correct SQL query with default parameters and returns expected results."""
    
    location_name = "Kitchen - Pantry" 
    fake_rows = [
        {
            "id": 1,
            "location_name": location_name,
            "created_at": "2026-11-15T12:00:00"
        }
    ]
    mock_cursor = _setup_mock_cursor(mock_get_conn, fake_rows)

    result = locations_service.get_all_locations()

    executed_sql, executed_params = mock_cursor.execute.call_args[0]
    assert "WHERE" not in executed_sql
    assert "ORDER BY created_at ASC, id ASC LIMIT %s;" in executed_sql
    assert executed_params == [50]  # Matches limit=50 default in service
    assert len(result) == 1
    assert result[0]["location_name"] == location_name


@patch("backend.app.services.locations_service.get_db_connection")  
def test_get_all_bins_with_search(mock_get_conn):
    """Test that get all locations based off of the exact search term integer and returns expected results."""
    mock_cursor = _setup_mock_cursor(mock_get_conn)

    search_term = "Downstairs - Tree"  # Passed as an integer now
    locations_service.get_all_locations(search=search_term)

    executed_sql, executed_params = mock_cursor.execute.call_args[0]
    assert "WHERE" in executed_sql
    assert "location_name = %s" in executed_sql  # Updated to check exact match
    assert executed_params == [search_term, 50]  # Exact value + default limit


@patch("backend.app.services.locations_service.get_db_connection")  
def test_get_all_locations_with_filters_sorting_and_pagination(mock_get_conn):
    """Test that get_all_locations constructs the correct SQL query with filters, sorting, and pagination."""
    mock_cursor = _setup_mock_cursor(mock_get_conn)

    location_name = "Kitchen - Fridge - Cabinet"  
    limit = 10
    offset = 20

    locations_service.get_all_locations(
        search=location_name,
        sort_by="location_name",
        order="desc",
        limit=limit,
        offset=offset,
    )

    executed_sql, executed_params = mock_cursor.execute.call_args[0]
    assert "location_name = %s" in executed_sql  # Updated to check exact match
    assert "ORDER BY location_name DESC, id ASC LIMIT %s OFFSET %s;" in executed_sql
    assert executed_params == [location_name, limit, offset]  # Exact value + limit + offset
    