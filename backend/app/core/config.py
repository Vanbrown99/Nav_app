from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "Nyetam Tourism API"
    api_v1_prefix: str = "/api/v1"
    secret_key: str = "replace-this-development-secret-with-32-plus-bytes"
    jwt_algorithm: str = "HS256"
    access_token_expire_minutes: int = 60
    google_client_id: str = ""
    google_routes_api_key: str = ""
    database_url: str = "sqlite:///./nyetam.db"
    cors_origins: list[str] = [
        "http://localhost:8123",
        "http://127.0.0.1:8123",
    ]

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )


@lru_cache
def get_settings() -> Settings:
    return Settings()