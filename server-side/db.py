from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from config import settings


user = settings.DB_USER
password = settings.DB_PASSWORD
host = settings.DB_HOST
port = settings.DB_PORT
database = settings.DB_NAME


DATABASE_URL = f"postgresql://{user}:{password}@{host}:{port}/{database}"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)