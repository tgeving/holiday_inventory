from fastapi.testclient import TestClient
from backend.app.main import app

client = TestClient(app)

def test_get_all_items_endpoint_contract():
    response = client.get("/items/")

    # 1. Verify HTTP status and headers
    assert response.status_code == 200
    assert response.headers["content-type"] == "application/json"

    # 2. Verify payload structure
    data = response.json()
    assert isinstance(data, list)
    assert len(data) > 0

    # 3. Validate every item's schema and data types
    required_keys = {"id", "name", "category", "quantity"}
    for item in data:
        assert required_keys.issubset(item.keys())
        assert isinstance(item["id"], int)
        assert isinstance(item["name"], str) and len(item["name"]) > 0
        assert isinstance(item["category"], str)
        assert isinstance(item["quantity"], int) and item["quantity"] >= 0

def test_get_all_items_method_not_allowed():
    # Ensure unsupported HTTP methods on this route are rejected properly
    response = client.delete("/items/")
    assert response.status_code == 405
