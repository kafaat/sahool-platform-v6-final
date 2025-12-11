from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import os

SERVICE_NAME = os.getenv("SERVICE_NAME", "agent-service")

app = FastAPI(
    title=f"{SERVICE_NAME.replace('-', ' ').title()} API",
    version="1.0.0",
    description=f"API for {SERVICE_NAME.replace('-', ' ').title()}"
)

class HealthCheck(BaseModel):
    status: str
    service: str
    version: str

@app.get("/health", response_model=HealthCheck)
async def health_check():
    return {
        "status": "ok",
        "service": SERVICE_NAME,
        "version": "1.0.0"
    }

@app.get("/")
async def root():
    return {"message": f"Welcome to the {SERVICE_NAME.replace('-', ' ').title()}!"}

# Add specific logic for the service
if SERVICE_NAME == "auth-service":
    @app.post("/api/v1/auth/login")
    async def login():
        return {"token": "mock_jwt_token", "user_id": 1}
elif SERVICE_NAME == "geo-service":
    @app.get("/api/v1/fields/{field_id}")
    async def get_field(field_id: int):
        return {"id": field_id, "name": "Mock Field A", "area": 100}
elif SERVICE_NAME == "agent-service":
    @app.get("/api/v1/agent/advice/{field_id}")
    async def get_advice(field_id: int):
        return {"advice": "Based on NDVI, apply nitrogen fertilizer.", "field_id": field_id}
elif SERVICE_NAME == "imagery-service":
    @app.get("/api/v1/imagery/ndvi/{field_id}")
    async def get_ndvi(field_id: int):
        return {"ndvi_value": 0.75, "field_id": field_id, "image_url": "http://minio:9000/ndvi/mock.png"}
elif SERVICE_NAME == "weather-service":
    @app.get("/api/v1/weather/{field_id}")
    async def get_weather(field_id: int):
        return {"temperature": 25.5, "condition": "Sunny", "field_id": field_id}

