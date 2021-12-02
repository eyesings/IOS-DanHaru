from dataclasses import dataclass
from os import path, environ
from app.common.consts import DB_SECRETS

base_dir = path.dirname(path.dirname(path.dirname(path.abspath(__file__))))


@dataclass
class Config:
    """
    기본 Configuration
    """
    BASE_DIR = base_dir
    DB_POOL_RECYCLE: int = 900
    DB_ECHO: bool = True
    DEBUG = False


@dataclass
class LocalConfig(Config):
    DB = DB_SECRETS
    # DB_URL: str = "mysql+pymysql://root:flemdhs@localhost/notification_api?charset=utf8mb4"
    DB_URL: str = f"mysql+pymysql://{DB.get('user')}:{DB.get('password')}@{DB.get('host')}/{DB.get('database')}?charset=utf8mb4"

    TRUSTED_HOSTS = ["*"]
    ALLOW_SITE = ["*"]
    DEBUG = True


@dataclass
class ProdConfig(Config):
    TRUSTED_HOSTS = ["*"]
    ALLOW_SITE = ["*"]


def conf():
    """
    환경 불러오기
    :return:
    """
    config = dict(prod=ProdConfig(), local=LocalConfig())
    return config.get(environ.get("API_ENV", "local"))