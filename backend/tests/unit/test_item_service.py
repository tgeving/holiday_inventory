from backend.app.services import item_service

def test_get_all_items_returns_expected_data():
    items = item_service.get_all_items()

    assert isinstance(items, list)
    assert len(items) == 3
    assert items[0]["name"] == "LED String Lights"
