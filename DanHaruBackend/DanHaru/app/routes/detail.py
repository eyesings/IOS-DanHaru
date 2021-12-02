from datetime import datetime, timedelta
from typing import List
import bcrypt
import jwt
import os
from fastapi import APIRouter, Depends, File, UploadFile, Form
from fastapi.responses import FileResponse

from sqlalchemy.orm import Session
from app.database.conn import db
from starlette.responses import JSONResponse
from app.database.detail_schema import TodoDetail, ChallengeMem, Certification
from app.model.detail_model import DetailUpdateParam, DetailParam, ChallengeUserParam, ChallengeUserDeleteParam, CertificationParam

router = APIRouter(prefix="/todo")

PATHDIR = "/Users/radcns_kim_taewon/TaeWOn/IOS-DanHaru/DanHaruBackend/DanHaru/certification/"


@router.post("/detail/list", status_code=200)
async def todo_list_detail(reg_info: DetailParam):
    """
    `TODO 상세페이지 조회 API`\n
    :param todo_id: \n
    :return: \n
    """

    if not reg_info.todo_id:
        return JSONResponse(status_code=400, content=dict(msg="TODO_ID를 넘겨주세요.", result_code="9999"))

    if not reg_info.today_dt:
        return JSONResponse(status_code=400, content=dict(msg="현재날짜를 넘겨주세요.", result_code="9999"))

    todo = TodoDetail.get(todo_id=reg_info.todo_id)

    if not todo:
        return JSONResponse(status_code=400, content=dict(msg="존재하는 데이터가 없습니다.", result_code="9999"))

    chllenge = ChallengeMem.gets(todo_id=todo.todo_id)
    certification_data = Certification.get(todo_id=reg_info.todo_id, todo_date=reg_info.today_dt)

    # 백분율 계산
    await percentage_cal(todo.fr_date.replace("-", ""), todo.ed_date.replace("-", ""))


    todo_data_dic = {
        "msg": "Success",
        "result_code": "0000",
        "detail": {
            "todo_id": todo.todo_id,
            "mem_id": todo.mem_id,
            "title": todo.title,
            "fr_date": todo.fr_date,
            "ed_date": todo.ed_date,
            "noti_cycle": todo.noti_cycle,
            "noti_time": todo.noti_time,
            "todo_status": todo.todo_status,
            "challange_status": todo.challange_status,
            "chaluser_yn": todo.chaluser_yn,
            "certi_yn": todo.certi_yn,
            "created_at": todo.created_at,
            "created_user": todo.created_user,
            "updated_at": todo.updated_at,
            "updated_user": todo.updated_user,
            "certification_list": certification_data,
            "challenge_user": chllenge,
            "report_list": "report_data",
        },

    }

    if not todo_data_dic:
        return JSONResponse(status_code=400, content=dict(msg="존재하는 데이터가 없습니다.", result_code="9999"))

    return todo_data_dic

@router.put("/detail/update/{todo_id}", status_code=200)
async def todo_update_detail(reg_info: DetailUpdateParam, todo_id: int):
    """
    `TODO 상세페이지 업데이트 `\n
    :param todo_id: todo_id \n
    :return: \n
    """
    key_data = TodoDetail.filter(todo_id=todo_id)

    if key_data:
        print("key_data::", key_data)
        returnData = key_data.update(auto_commit=True, **reg_info.dict())
        print("returnData::", returnData.mem_id)
        if not returnData:
            return JSONResponse(status_code=400, content=dict(msg="존재하지 않는 데이터입니다.", result_code="9999"))
        return JSONResponse(status_code=200, content=dict(msg="Success", result_code="0000"))
    else:
        return JSONResponse(status_code=400, content=dict(msg="존재하지 않는 데이터입니다.", result_code="9999"))

    return JSONResponse(status_code=400, content=dict(msg="저장에 실패 하였습니다.", result_code="9999"))


@router.post("/challenge/create", status_code=200)
async def challenge_create(reg_info: ChallengeUserParam, session: Session = Depends(db.session)):
    """
    `ChallengeUser 생성 `\n
    :param todo_id: todo_id \n
    :param todo_mem_id: 등록자 \n
    :param chaluser_mem_id: 도전유저 (여러명 등록시 "test1, test2, test3")  \n
    :return: \n
    """
    chaluser_mem_id_Array = reg_info.chaluser_mem_id
    chaluser_mem_id_Array = chaluser_mem_id_Array.split(",")

    id_id_exist_cnt = 0
    save_chaluser_mem_id = []
    for mem_id in chaluser_mem_id_Array:
        mem_id = mem_id.strip()
        is_id_exist = await challenge_is_id_exist(reg_info.todo_id, mem_id)

        if is_id_exist:
            id_id_exist_cnt += 1
            continue

        ChallengeMem.create(session, auto_commit=True, todo_id=reg_info.todo_id, mem_id=mem_id,
                            created_user=reg_info.todo_mem_id, updated_user=reg_info.todo_mem_id)

        save_chaluser_mem_id.append(mem_id)
    if id_id_exist_cnt == len(chaluser_mem_id_Array):
        return JSONResponse(status_code=400, content=dict(msg="저장에 실패 하였습니다. 존재하는 데이터가 있습니다.", result_code="9999"))

    return JSONResponse(status_code=200, content=dict(msg="Success", result_code="0000",
                                                      save_chaluser_mem_id=save_chaluser_mem_id))


@router.delete("/challenge/delete", status_code=200)
async def challenge_delete(reg_info: ChallengeUserDeleteParam):
    """
    `ChallengeUser 삭제 `\n
    :param reg_info:
    :param todo_id: todo_id \n
    :param chaluser_mem_id: 도전유저 \n
    :return: \n
    """
    is_id_exist = await challenge_is_id_exist(reg_info.todo_id, reg_info.chaluser_mem_id)
    delete_challenge = ChallengeMem.filter(todo_id=reg_info.todo_id, mem_id=reg_info.chaluser_mem_id)

    if is_id_exist:
        delete_challenge.delete(auto_commit=True)
        return JSONResponse(status_code=200, content=dict(msg="Success", result_code="0000"))
    return JSONResponse(status_code=400, content=dict(msg="삭제에 실패 하였습니다.", result_code="9999"))


@router.post("/certification/create", status_code=200)
async def certification_create(todo_id: str = Form(...),
                               mem_id: str = Form(...),
                               certi_check: str = Form(None),
                               certi_img_file: List[UploadFile] = File(None),
                               certi_voice_file: UploadFile = File(None),
                               session: Session = Depends(db.session)):
    """
    `certification 생성 `\n
    :param session:
    :param todo_id: todo_id \n
    :param mem_id: 회원id \n
    :param certi_check: 인증여부 (체크) \n
    :param certi_img_file: 인증여부 (이미지, 멀티가능) \n
    :param certi_voice_file: 인증여부 (녹음, 멀티불가) \n
    :return: \n
    """

    today = datetime.today().strftime("%Y-%m-%d")
    exit_check = False

    search_certification = Certification.gets(todo_id=todo_id, mem_id=mem_id)
    for certification_todo_id in search_certification:
        certification_create_at = certification_todo_id.created_at.strftime("%Y-%m-%d")
        if today == certification_create_at:
            exit_check = True
            break

    if exit_check:
        return JSONResponse(status_code=400, content=dict(msg="현재 날짜에 등록된 데이터가 있습니다.", result_code="9999"))

    if certi_img_file:
        img_file_name: str = ""
        for idx, uploaded_file in enumerate(certi_img_file):
            # 이미지 저장
            file_nm = await save_file(uploaded_file, mem_id, "img", today)
            if idx == (len(certi_img_file) - 1):
                img_file_name += file_nm
            else:
                img_file_name += file_nm + ", "

    if certi_voice_file:
        # 파일 저장
        voice_file_name = await save_file(certi_voice_file, mem_id, "voice", today)

    if certi_img_file or certi_voice_file:
        certi_check = "Y"

    Certification.create(session, auto_commit=True, todo_id=todo_id, mem_id=mem_id, todo_date=today,
                         certi_img=str(img_file_name), certi_voice=voice_file_name, certi_check=certi_check,
                         created_user=mem_id, updated_user=mem_id)

    return JSONResponse(status_code=200, content=dict(msg="저장에 성공 하였습니다.", result_code="0000"))


# @router.post("/certification/list", status_code=200)
# async def certification_list(reg_info: CertificationParam):
#
#     if not reg_info.todo_id:
#         return JSONResponse(status_code=400, content=dict(msg="TODO_ID를 넘겨주세요.", result_code="9999"))
#     if not reg_info.today_dt:
#         return JSONResponse(status_code=400, content=dict(msg="현재날짜를 넘겨주세요.", result_code="9999"))
#
#     certification_data = Certification.get(todo_id=reg_info.todo_id, todo_date=reg_info.today_dt)
#
#     certification_data_dic = {
#         "detail": certification_data,
#         "msg": "Success",
#         "result_code": "0000"
#     }
#
#     return certification_data_dic


@router.get("/detail/getFile/{fileName}")
async def read_random_file(fileName: str):
    """
    `인증 파일 API`\n
    :param imageName: 파일명(필수)\n
    :return: \n
    """
    path = f"{PATHDIR}" + fileName
    return FileResponse(path)


async def save_file(uploaded_file: UploadFile, mem_id: str, uploaded_type, date):
    fname, ext = os.path.splitext(uploaded_file.filename)
    print("fname, ext::", fname, ext)
    if uploaded_file:
        uploaded_file.filename = f"{mem_id}_{uploaded_type}_certification_{date}{ext}"
        file_name = uploaded_file.filename

        contents = await uploaded_file.read()  # <-- Important!
    else:
        file_name = None

    try:
        os.mkdir("certification/")
    except Exception as e:
        print(e)

    if uploaded_file:
        # example of how you can save the file
        with open(f"{PATHDIR}{file_name}", "wb") as f:
            f.write(contents)

    return file_name

async def challenge_is_id_exist(todo_id: str, chaluser_mem_id: str):
    get_id = ChallengeMem.get(todo_id=todo_id, mem_id=chaluser_mem_id)
    if get_id:
        return True
    return False


async def percentage_cal(td: str, ed: str):
    total_value = int(ed) - int(td) + 1
    print("total_value::", total_value)
