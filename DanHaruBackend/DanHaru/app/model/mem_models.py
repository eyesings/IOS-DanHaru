from enum import Enum
from typing import List

from pydantic.main import BaseModel
from pydantic.networks import EmailStr

class MemberValidation(BaseModel):
    id: str
    email: EmailStr = None

class MemberRegister(BaseModel):
    id: str
    email: EmailStr = None
    pw: str = None

class MemberLogin(BaseModel):
    id: str
    pw: str = None

class SnsType(str, Enum):
    email: str = "email"
    facebook: str = "facebook"
    google: str = "google"
    kakao: str = "kakao"

class ValidationType(str, Enum):
    id: str = "id"
    email: str = "email"


class Token(BaseModel):
    Authorization: str = None

class MemberReturn(BaseModel):
    result_code: str = None
    msg: str = None

    class Config:
        orm_mode = True

class MemberToken(BaseModel):
    mem_id: str
    mem_pw: str = None
    mem_email: str = None

    class Config:
        orm_mode = True


class MemberMe(BaseModel):
    mem_id: str
    mem_email: EmailStr = None
    profile_nm: str = None
    profile_img: str = None
    profile_into: str = None

    class Config:
        orm_mode = True
