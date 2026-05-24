import os

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from database import Base, engine
from models import interaccion, lead, usuario  # noqa: F401
from routers import auth, interacciones, leads

Base.metadata.create_all(bind=engine)

cors_origins = [
    origin.strip()
    for origin in os.getenv(
        "CORS_ORIGINS",
        "http://localhost:5173,http://127.0.0.1:5173,https://tu-dominio.com",
    ).split(",")
    if origin.strip()
]

app = FastAPI(
    title="Bemantis API",
    description="Plataforma de gestion de leads con integracion WhatsApp IA",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=cors_origins,
    allow_origin_regex=r"https?://(localhost|127\.0\.0\.1)(:\d+)?",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, prefix="/auth", tags=["Autenticacion"])
app.include_router(leads.router, prefix="/leads", tags=["Leads"])
app.include_router(interacciones.router, prefix="/interacciones", tags=["Interacciones"])


@app.get("/")
def root():
    return {"message": "Bemantis API activa", "docs": "/docs"}
