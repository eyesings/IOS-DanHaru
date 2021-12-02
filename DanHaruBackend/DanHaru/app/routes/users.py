from fastapi import APIRouter

router = APIRouter()


# @router.get("/me", response_model=UserMe)
# async def get_user(request: Request):
#     """
#     get my info
#     :param request:
#     :return:
#     """
#     user = request.state.user
#     user_info = Users.get(id=user.id)
#     return user_info