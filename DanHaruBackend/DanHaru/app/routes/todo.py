import collections
from datetime import datetime, timedelta
import bcrypt
import jwt
import json
from fastapi import APIRouter, Depends

from sqlalchemy.orm import Session
from starlette.responses import JSONResponse

from app.common.consts import JWT_SECRET, JWT_ALGORITHM
from app.database.conn import db
from app.database.todo_schema import Todo
from app.database.mem_schema import Member
from app.database.detail_schema import ChallengeMem
from app.model.todo_models import TodoMe, TodoReturn, TodoRegister, TodoGet



router = APIRouter(prefix="/todo")


@router.post("/main/create", status_code=200, response_model=TodoReturn)
async def todo_register(reg_info: TodoRegister, session: Session = Depends(db.session)):
    """
    `todo Create API`\n
    :param reg_info: 저장할 모델\n
    :param session: DB세션\n
    :return:
    """
    print("reg_info::", reg_info)

    is_id_exist = await mem_is_id_exist(reg_info.mem_id)

    if not is_id_exist:
        return JSONResponse(status_code=400, content=dict(msg="등록된 회원이 존재 하지 않습니다.", result_code="9999"))

    Todo.create(session, auto_commit=True, mem_id=reg_info.mem_id, title=reg_info.title, fr_date=reg_info.fr_date,
                created_user=reg_info.mem_id, updated_user=reg_info.mem_id)

    result = dict(msg="Success", result_code="0000")
    return result

@router.post("/main/list", status_code=200)
async def todo_list(reg_info: TodoGet):
    """
    `todo List API`\n
    :param reg_info: mem_id, fr_date\n
    :return:
    """
    if not reg_info.mem_id:
        return JSONResponse(status_code=400, content=dict(msg="ID를 넘겨주세요.", result_code="9999"))
    if not reg_info.fr_date:
        return JSONResponse(status_code=400, content=dict(msg="시작 일자를 넘겨주세요.", result_code="9999"))

    todo_data = Todo.get_union_mem(reg_info.mem_id, reg_info.fr_date)

    challenge_user = ChallengeMem.gets(mem_id=reg_info.mem_id)
    for challenge_to in challenge_user:
        for todo_li in Todo.get_union_todo_id(challenge_to.todo_id, reg_info.fr_date):
            todo_data.append(todo_li)

    if not todo_data:
        return JSONResponse(status_code=200, content=dict(msg="존재하는 데이터가 없습니다.", result_code="9999"))

    return todo_data


async def mem_is_id_exist(id: str):
    get_id = Member.get(mem_id=id)
    if get_id:
        return True
    return False

