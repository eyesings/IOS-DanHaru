from typing import List, Optional
from datetime import datetime
from pydantic.main import BaseModel


class CertificationParam(BaseModel):
    todo_id: int
    today_dt: str


class DetailParam(BaseModel):
    todo_id: int
    today_dt: str

class ChallengeUserDeleteParam(BaseModel):
    todo_id: int
    chaluser_mem_id: str


class ChallengeUserParam(BaseModel):
    todo_id: int
    todo_mem_id: str
    chaluser_mem_id: str

    class Config:
        orm_mode = True


class DetailUpdateParam(BaseModel):
    title: str = None
    fr_date: str = None
    ed_date: str = None
    noti_cycle: str = None
    noti_time: str = None
    todo_status: str = None
    challange_status: str = None
    chaluser_yn: str = None
    certi_yn: str = None

    class Config:
        orm_mode = True


class DetailBase(BaseModel):
    todo_id: int
    mem_id: str
    title: str = None
    fr_date: str = None
    ed_date: str = None
    noti_cycle: str = None
    noti_time: str = None
    todo_status: str = None
    challange_status: str = None
    chaluser_yn: str = None
    certi_yn: str = None

    class Config:
        orm_mode = True

#
# class ChallengeMemBase(BaseModel):
#     mem_id: str
#     # created_user: str
#     # updated_user: str
#
# class ChallengeCreate(ChallengeMemBase):
#     pass
#
# class ChallengeMem(ChallengeMemBase):
#     chaluser_id: int
#     todo_id: int
#
#     class Config:
#         orm_mode = True
#
#
# class TodoDetailBase(BaseModel):
#     mem_id: str
#     title: str = None
#     fr_date: str = None
#     ed_date: str = None
#     noti_cycle: str = None
#     noti_time: str = None
#     todo_status: str = None
#     challange_status: str = None
#     chaluser_yn: str = None
#     certi_yn: str = None
#
#
# class TodoDetailCreate(TodoDetailBase):
#     pass
#
# class TodoDetailModel(TodoDetailBase):
#     todo_id: int
#     todoDetails: List[ChallengeMem] = []
#
#     class Config:
#         orm_mode = True




