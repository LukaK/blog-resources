import requests

# Replace with your actual deployed API URL
API_URL = "https://your-api-id.execute-api.region.amazonaws.com/prod/items/"

def test__should_create_item_successfully():
    data = {"item": {"name": "test item", "price": 10, "description": "test description"}}
    response = requests.post(API_URL, json=data)

    assert response.status_code == 201
    response_data = response.json()
    assert data["item"].items() <= response_data.items()

def test__should_retrieve_item_successfully():
    data = {"item": {"name": "test item", "price": 10, "description": "test description"}}
    response = requests.post(API_URL, json=data)
    assert response.status_code == 201

    item = response.json()
    response = requests.get(f"{API_URL}{item['id']}")
    assert response.status_code == 200
    assert item == response.json()

def test__should_delete_item_successfully():
    data = {"item": {"name": "test item", "price": 10, "description": "test description"}}
    response = requests.post(API_URL, json=data)
    assert response.status_code == 201

    item = response.json()
    response = requests.delete(f"{API_URL}{item['id']}")
    assert response.status_code == 204

    response = requests.get(f"{API_URL}{item['id']}")
    assert response.status_code == 404

def test__should_list_empty_items_successfully():
    response = requests.get(API_URL)
    assert response.status_code == 200
    assert isinstance(response.json(), list)
