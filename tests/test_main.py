from fastapi.testclient import TestClient
from src.main import app, add

client = TestClient(app)

def test_add_function():
    assert add(1, 2) == 3

def test_read_root():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"Hello": "Gitea Actions + UV"}