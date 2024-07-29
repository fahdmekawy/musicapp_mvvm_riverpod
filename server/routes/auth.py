import uuid
import bcrypt
from fastapi import Depends, HTTPException
from database import get_db
from models.user import User
from pydantic_schemas.user_create import UserCreate
from fastapi import APIRouter
from sqlalchemy.orm import Session

from pydantic_schemas.user_login import UserLogin


router = APIRouter()


@router.post("/signup",status_code=201)
def signup_user(user: UserCreate,db: Session = Depends(get_db)):
    # extract the data that coming from request
    user_db = db.query(User).filter(User.email == user.email).first()
    # check if the user already exists in database
    if  user_db:
        raise HTTPException(status_code=400, detail="User with this email already exists")
    
    hashed_password = bcrypt.hashpw(user.password.encode(),bcrypt.gensalt())

    user_db = User(id=str(uuid.uuid4()),name=user.name,email=user.email,password=hashed_password)
    # insert the user data in database
    db.add(user_db)
    db.commit()
    db.refresh(user_db)

    return user_db


@router.post("/login")
def login_user(user: UserLogin,db: Session = Depends(get_db)):
    # check if the user exists in database
    user_db = db.query(User).filter(User.email == user.email).first()
    if not user_db:
        raise HTTPException(status_code=400, detail="User with this email does not exist")
    # password matching or not
    is_match = bcrypt.checkpw(user.password.encode(),user_db.password)

    if not is_match:
        raise HTTPException(status_code=400, detail="Incorrect Password")

    return user_db