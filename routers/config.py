from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from database import get_db
from models.system_config import SystemConfig
from models.usuario import Usuario
from routers.auth import get_current_user
from schemas.system_config import SystemConfigResponse, SystemConfigUpdate

router = APIRouter()


def get_or_create_config(db: Session) -> SystemConfig:
    config = db.query(SystemConfig).first()
    if not config:
        config = SystemConfig()
        db.add(config)
        db.commit()
        db.refresh(config)
    return config


@router.get("", response_model=SystemConfigResponse)
def get_config(
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    return get_or_create_config(db)


@router.put("", response_model=SystemConfigResponse)
def update_config(
    payload: SystemConfigUpdate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    config = get_or_create_config(db)
    for field, value in payload.model_dump(exclude_none=True).items():
        setattr(config, field, value)
    config.updated_by = current_user.id
    db.commit()
    db.refresh(config)
    return config
