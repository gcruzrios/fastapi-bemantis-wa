from datetime import datetime, timedelta
import os

from dotenv import load_dotenv
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt
from passlib.context import CryptContext
from sqlalchemy.orm import Session

from database import get_db
from models.usuario import Usuario
from schemas.auth import LoginRequest, TokenResponse, UsuarioCreate, UsuarioResponse, UsuarioUpdate

load_dotenv()

router = APIRouter()

SECRET_KEY = os.getenv("SECRET_KEY", "cambiar-en-produccion-min-32-chars")
ALGORITHM = os.getenv("ALGORITHM", "HS256")
TOKEN_HOURS = int(os.getenv("ACCESS_TOKEN_EXPIRE_HOURS", "96"))

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")


def hash_password(password: str) -> str:
    """Genera hash bcrypt del password en texto plano."""
    return pwd_context.hash(password)


def verify_password(plain: str, hashed: str) -> bool:
    """Verifica password plano contra hash bcrypt almacenado."""
    return pwd_context.verify(plain, hashed)


def create_access_token(data: dict) -> str:
    """Crea JWT con expiracion de TOKEN_HOURS horas."""
    payload = data.copy()
    payload["exp"] = datetime.utcnow() + timedelta(hours=TOKEN_HOURS)
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)


def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db),
) -> Usuario:
    """Dependency: valida JWT y retorna usuario autenticado."""
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Token invalido o expirado",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id = payload.get("sub")
        if user_id is None:
            raise credentials_exception
        user_id = int(user_id)
    except (JWTError, TypeError, ValueError):
        raise credentials_exception

    usuario = db.query(Usuario).filter(Usuario.id == user_id).first()
    if usuario is None:
        raise credentials_exception
    return usuario


@router.post("/register", response_model=UsuarioResponse, status_code=201)
def register(payload: UsuarioCreate, db: Session = Depends(get_db)):
    """Registra un nuevo usuario. Correo debe ser unico."""
    existing = db.query(Usuario).filter(Usuario.correo == payload.correo).first()
    if existing:
        raise HTTPException(status_code=400, detail="El correo ya esta registrado")
    usuario = Usuario(
        correo=payload.correo,
        password=hash_password(payload.password),
        nombre=payload.nombre,
        telefono=payload.telefono,
        empresa=payload.empresa,
    )
    db.add(usuario)
    db.commit()
    db.refresh(usuario)
    return usuario


@router.post("/login", response_model=TokenResponse)
def login(payload: LoginRequest, db: Session = Depends(get_db)):
    """Autentica usuario con correo + password y retorna JWT de 96h."""
    usuario = db.query(Usuario).filter(Usuario.correo == payload.correo).first()
    if not usuario or not verify_password(payload.password, usuario.password):
        raise HTTPException(status_code=401, detail="Credenciales incorrectas")
    token = create_access_token({"sub": str(usuario.id)})
    return TokenResponse(access_token=token, usuario=usuario)


@router.get("/me", response_model=UsuarioResponse)
def get_me(current_user: Usuario = Depends(get_current_user)):
    """Retorna perfil del usuario autenticado."""
    return current_user


@router.put("/me", response_model=UsuarioResponse)
def update_me(
    payload: UsuarioUpdate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    """Actualiza nombre, empresa, telefono o password del usuario autenticado."""
    if payload.nombre is not None:
        current_user.nombre = payload.nombre
    if payload.telefono is not None:
        current_user.telefono = payload.telefono
    if payload.empresa is not None:
        current_user.empresa = payload.empresa
    if payload.password_new is not None:
        current_user.password = hash_password(payload.password_new)
    db.commit()
    db.refresh(current_user)
    return current_user

