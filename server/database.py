from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql://fahd:fahd@localhost:5432/musicapp"
engine = create_engine(DATABASE_URL);
SessionLocal = sessionmaker(autoflush= False,expire_on_commit=False,bind=engine)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()     
