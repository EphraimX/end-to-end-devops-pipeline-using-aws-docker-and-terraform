import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    

    DB_HOST = os.getenv("DB_HOST", "your-rds-endpoint.region.rds.amazonaws.com")
    DB_PORT = int(os.getenv("DB_PORT", 5432)) 
    DB_NAME = os.getenv("DB_NAME", "news_digest")
    DB_USER = os.getenv("DB_USER", "postgres")
    DB_PASSWORD = os.getenv("DB_PASSWORD", "your_password")
    DB_TYPE = os.getenv("DB_TYPE", "postgresql") 
    

    if DB_TYPE == "postgresql":
        DATABASE_URL = f"postgresql+asyncpg://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
        SYNC_DATABASE_URL = f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    elif DB_TYPE == "mysql":
        DATABASE_URL = f"mysql+aiomysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
        SYNC_DATABASE_URL = f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    else:
        # Fallback to PostgreSQL
        DATABASE_URL = f"postgresql+asyncpg://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
        SYNC_DATABASE_URL = f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    

    # Connection Pool Settings
    DB_POOL_SIZE = int(os.getenv("DB_POOL_SIZE", 20))
    DB_MAX_OVERFLOW = int(os.getenv("DB_MAX_OVERFLOW", 30))
    DB_POOL_TIMEOUT = int(os.getenv("DB_POOL_TIMEOUT", 30))
    DB_POOL_RECYCLE = int(os.getenv("DB_POOL_RECYCLE", 3600))
    
    
    HOST = os.getenv("HOST", "0.0.0.0")
    PORT = int(os.getenv("PORT", 8000))
    DEBUG = os.getenv("DEBUG", "True").lower() == "true"
    
    
    # Cache Settings
    CACHE_DURATION_MINUTES = 30
    

    # CORS Settings
    ALLOWED_ORIGINS = [
        "http://localhost",
        "http://localhost:3000",  # or the port your frontend uses
        "https://3000-ephraimx-staticroicalcu-ar07kphbms7.ws-eu120.gitpod.io"
    ]

    
    # AWS RDS SSL Settings
    DB_SSL_MODE = os.getenv("DB_SSL_MODE", "require")
    DB_SSL_CERT = os.getenv("DB_SSL_CERT", None)  # Path to RDS CA certificate

settings = Settings()