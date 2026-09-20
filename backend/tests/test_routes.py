from fastapi.testclient import TestClient

from app.main import app


def test_compute_route_returns_google_route(monkeypatch):
    monkeypatch.setattr(
        "app.routers.routes.compute_google_route",
        lambda waypoints, api_key: {
            "distance_meters": 12500,
            "duration_seconds": 1800,
            "encoded_polyline": "encoded-route",
        },
    )

    with TestClient(app) as client:
        response = client.post(
            "/api/v1/routes/compute",
            json={
                "waypoints": [
                    {"latitude": 3.86, "longitude": 11.51},
                    {"latitude": 3.90, "longitude": 11.55},
                ]
            },
        )

    assert response.status_code == 200
    assert response.json()["distance_meters"] == 12500
    assert response.json()["encoded_polyline"] == "encoded-route"


def test_compute_route_validates_waypoint_count():
    with TestClient(app) as client:
        response = client.post(
            "/api/v1/routes/compute",
            json={"waypoints": [{"latitude": 3.86, "longitude": 11.51}]},
        )

    assert response.status_code == 422