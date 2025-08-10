import pytest
from app.main import app  # This should now work with __init__.py in app/

@pytest.fixture
def client():
    app.config['TESTING'] = True
    return app.test_client()

def test_home(client):
    response = client.get('/')
    assert response.status_code == 200
    assert b'Hello, World!' in response.data  # Adjust based on your app
