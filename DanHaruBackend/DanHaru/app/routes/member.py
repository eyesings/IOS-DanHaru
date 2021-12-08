from datetime import datetime, timedelta
import bcrypt
import jwt

from fastapi.responses import FileResponse

import logging
import os
from fastapi import APIRouter, Depends, File, UploadFile, Form

import re

# TODO:
from sqlalchemy.orm import Session
from starlette.responses import JSONResponse

from app.common.consts import JWT_SECRET, JWT_ALGORITHM, FILE_FATH
from app.database.conn import db
from app.database.mem_schema import Member
from app.model.mem_models import MemberRegister, MemberToken, MemberMe, MemberLogin, ValidationType, MemberValidation, \
    MemberReturn, SnsType

log = logging.getLogger(__name__)

DESTINATION = "/"
CHUNK_SIZE = 2 ** 20  # 1MB

PATHDIR = FILE_FATH + "profile/"

router = APIRouter(prefix="/auth")
# Email 정규식
regex = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'


@router.post("/validation/member/{type}", status_code=200, response_model=MemberMe)
async def mem_validation(type: ValidationType, user_info: MemberValidation):
    """
    `회원가입 Validation EMAIL, ID CheckAPI`\n
    :param type:email, id\n
    :param user_info:
    :return: [result_code="0000"] 성공, [result_code="9999"] 실패
    """
    if type == ValidationType.email:
        is_email_exist = await mem_is_email_exist(user_info.email)
        if is_email_exist:
            return JSONResponse(status_code=400, content=dict(msg="EMAIL이 존재합니다.", result_code="9999"))

        return JSONResponse(status_code=400, content=dict(msg="사용가능합니다.", result_code="0000"))
    elif type == ValidationType.id:
        is_id_exist = await mem_is_id_exist(user_info.id)
        if is_id_exist:
            return JSONResponse(status_code=400, content=dict(msg="ID가 존재합니다.", result_code="9999"))

        return JSONResponse(status_code=200, content=dict(msg="사용가능합니다.", result_code="0000"))
    return JSONResponse(status_code=400, content=dict(msg="NOT_SUPPORTED", result_code="9999"))


@router.post("/register/member/{sns_type}", status_code=200, response_model=MemberReturn)
async def mem_register(sns_type: SnsType, reg_info: MemberRegister, session: Session = Depends(db.session)):
    """
    `회원가입 API`\n
    :param sns_type: 현재는 email만 사용\n
    :param reg_info: 저장할 모델\n
    :param session: DB세션\n
    :return: 토큰 (현재는 사용안함 확장성 위해 리턴)\n
    """
    if sns_type == SnsType.email:
        is_email_exist = await mem_is_email_exist(reg_info.email)
        is_id_exist = await mem_is_id_exist(reg_info.id)

        if not reg_info.id:
            return JSONResponse(status_code=400, content=dict(msg="ID를 입력해주세요", result_code="9999"))
        if not reg_info.pw:
            return JSONResponse(status_code=400, content=dict(msg="PW를 입력해주세요", result_code="9999"))
        if not reg_info.email:
            return JSONResponse(status_code=400, content=dict(msg="Email을 입력해주세요", result_code="9999"))
        if is_id_exist:
            return JSONResponse(status_code=400, content=dict(msg="ID가 존재합니다.", result_code="9999"))
        if is_email_exist:
            return JSONResponse(status_code=400, content=dict(msg="EMAIL이 존재합니다.", result_code="9999"))

        hash_pw = bcrypt.hashpw(reg_info.pw.encode("utf-8"), bcrypt.gensalt())
        new_user = Member.create(session, auto_commit=True, mem_id=reg_info.id, mem_pw=hash_pw,
                                 mem_email=reg_info.email, created_user=reg_info.id, updated_user=reg_info.id)
        token = dict(
            Authorization=f"Bearer {create_access_token(data=MemberToken.from_orm(new_user).dict(exclude={'pw', 'mem_id'}), )}")
        print("token::", token)
        return JSONResponse(status_code=200, content=dict(msg="Success", result_code="0000"))
    return JSONResponse(status_code=400, content=dict(msg="NOT_SUPPORTED", result_code="9999"))


@router.post("/login/member/{sns_type}", status_code=200, response_model=MemberMe)
async def login(sns_type: SnsType, user_info: MemberLogin):
    """
    `로그인 API`\n
    :param sns_type: 현재는 email만 사용\n
    :param user_info: 유저정보\n
    :return: 회원정보\n
    """
    if sns_type == SnsType.email:
        if not user_info.id:
            return JSONResponse(status_code=400, content=dict(msg="ID를 입력해주세요.", result_code="9999"))
        if not user_info.pw:
            return JSONResponse(status_code=400, content=dict(msg="PW를 입력해주세요.", result_code="9999"))

        user = Member.get(mem_id=user_info.id)
        if not user:
            return JSONResponse(status_code=400, content=dict(msg="ID가 존재 하지 않습니다.", result_code="9999"))

        is_verified = bcrypt.checkpw(user_info.pw.encode("utf-8"), user.mem_pw.encode("utf-8"))
        if not is_verified:
            return JSONResponse(status_code=400, content=dict(msg="일치하는 회원이 없습니다.", result_code="9999"))

        return user
    return JSONResponse(status_code=400, content=dict(msg="NOT_SUPPORTED", result_code="9999"))


@router.put("/myPage/update/{mem_id}", status_code=200)
async def create_upload_file(mem_id: str,
                             mem_email: str = Form(None),
                             profile_nm: str = Form(None),
                             profile_into: str = Form(None),
                             uploaded_file: UploadFile = File(None)):
    """
    `마이페이지 Update API`\n
    :param mem_id: 회원ID(필수)\n
    :param mem_email: 이메일(선택)\n
    :param profile_nm: 프로필명(선택)\n
    :param profile_into: 한줄소개(선택)\n
    :param uploaded_file: 회원이미지(선택)\n
    :return:\n
    { \n
      msg = Success\n
      result_code = 0000\n
      detail=
        user_data_dic = {\n
            mem_id : user_data.mem_id\n
            mem_email : user_data.mem_email\n
            profile_nm : user_data.profile_nm\n
            profile_img : user_data.profile_img\n
            profile_into : user_data.profile_into\n
        }\n
    }\n
    """

    # 이미지 저장
    file_name = await save_image(uploaded_file, mem_id)
    print("file_name::", file_name)

    key_data = Member.filter(mem_id=mem_id)

    user_info = {
        "mem_email": mem_email,
        "profile_nm": profile_nm,
        "profile_img": file_name,
        "profile_into": profile_into,
    }

    user_info_dic = my_page_dic(**user_info)
    print("my_page_dic::", user_info_dic)

    if key_data:
        user_data = key_data.update(auto_commit=True, **user_info_dic)

        user_data_dic = {
            "mem_id": user_data.mem_id,
            "mem_email": user_data.mem_email,
            "profile_nm": user_data.profile_nm,
            "profile_img": user_data.profile_img,
            "profile_into": user_data.profile_into
        }
        if not user_data:
            return JSONResponse(status_code=400, content=dict(msg="존재하지 않는 데이터입니다.", result_code="9999"))
        return JSONResponse(status_code=200,
                            content=dict(
                                msg="Success.",
                                result_code="0000",
                                detail=user_data_dic
                            )
                            )

    return {"filename": file_name}


@router.get("/myPage/getImages/{imageName}")
async def read_random_file(imageName: str):
    """
    `마이페이지 이미지 API`\n
    :param imageName: 이미지(필수)\n
    :return: \n
    """
    path = f"{PATHDIR}" + imageName
    return FileResponse(path)


async def save_image(uploaded_file: UploadFile, mem_id: str):
    if uploaded_file:
        uploaded_file.filename = f"{mem_id}_profile_img.jpeg"
        file_name = uploaded_file.filename

        contents = await uploaded_file.read()  # <-- Important!
    else:
        file_name = None

    try:
        os.mkdir("profile/")
    except Exception as e:
        print(e)

    if uploaded_file:
        # example of how you can save the file
        with open(f"{PATHDIR}{file_name}", "wb") as f:
            f.write(contents)

    return file_name


def my_page_dic(params):
    dic_param = {}
    for key, value in params.items():
        if value:
            dic_param[key] = value
        else:
            dic_param[key] = ""

    return dic_param


async def mem_is_email_exist(email: str):
    get_email = Member.get(mem_email=email)
    if get_email:
        return True
    return False


def mem_is_email_validate(email: str):
    valide = re.match(email)
    print("valide::", valide)
    return valide


async def mem_is_id_exist(id: str):
    get_id = Member.get(mem_id=id)
    if get_id:
        return True
    return False


def create_access_token(*, data: dict = None, expires_delta: int = None):
    to_encode = data.copy()
    if expires_delta:
        to_encode.update({"exp": datetime.utcnow() + timedelta(hours=expires_delta)})
    encoded_jwt = jwt.encode(to_encode, JWT_SECRET, algorithm=JWT_ALGORITHM)
    return encoded_jwt
