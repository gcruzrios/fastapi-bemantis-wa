from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker
import os

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./bemantis.db")

engine = create_engine(
    DATABASE_URL,
    connect_args={"check_same_thread": False},
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()


def get_db():
    """Dependency: provee sesion de BD y garantiza su cierre."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

