from pydantic.main import BaseModel
from typing import List, Optional


class TodoReturn(BaseModel):
    result_code: str = None
    msg: str = None

    class Config:
        orm_mode = True

class TodoRegister(BaseModel):
    mem_id: str
    title: str
    fr_date: str

class TodoMe(BaseModel):
    title: str = None
    fr_date: str = None
    ed_date: str = None
    noti_cycle: str = None
    noti_time: str = None
    todo_status: str = None

class TodoGet(BaseModel):
    mem_id: str = None
    fr_date: str = None
