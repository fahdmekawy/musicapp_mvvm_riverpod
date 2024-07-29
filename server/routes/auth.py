import uuid
import bcrypt
from fastapi import Depends, HTTPException
from database import get_db
from models.user import User
from pydantic_schemas.user_create import UserCreate
from fastapi import APIRouter
from sqlalchemy.orm import Session


router = APIRouter()


@router.post("/signup")
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