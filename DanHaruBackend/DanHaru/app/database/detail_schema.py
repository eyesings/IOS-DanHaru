from sqlalchemy import (
    Column,
    Integer,
    String,
    DateTime,
    func,
    Enum,
    Boolean,
    ForeignKey,
    CHAR,
)

from sqlalchemy.orm import relationship
from sqlalchemy.orm import Session
# from peewee import *

from app.database.conn import Base, db


class BaseMixin:
    created_at = Column(DateTime, nullable=False, default=func.utc_timestamp())
    updated_at = Column(DateTime, nullable=False, default=func.utc_timestamp(), onupdate=func.utc_timestamp())

    def __init__(self):
        self._q = None
        self._session = None
        self.served = None

    def all_columns(self):
        # return [c for c in self.__table__.columns if c.primary_key is False and c.name != "created_at"]
        return [c for c in self.__table__.columns if c.name != "created_at"]

    @classmethod
    def create(cls, session: Session, auto_commit=False, **kwargs):
        """
        테이블 데이터 적재 전용 함수
        :param session:
        :param auto_commit: 자동 커밋 여부
        :param kwargs: 적재 할 데이터
        :return:
        """
        obj = cls()
        for col in obj.all_columns():
            col_name = col.name
            if col_name in kwargs:
                setattr(obj, col_name, kwargs.get(col_name))

        session.add(obj)
        session.flush()
        if auto_commit:
            session.commit()
        return obj

    @classmethod
    def get(cls, **kwargs):
        """
        Simply get a Row
        :param kwargs:
        :return:
        """
        session = next(db.session())
        query = session.query(cls)
        for key, val in kwargs.items():
            col = getattr(cls, key)
            query = query.filter(col == val)

        if query.count() > 1:
            raise Exception("Only one row is supposed to be returned, but got more than one.")
        return query.first()

    @classmethod
    def gets(cls, **kwargs):
        """
        Simply get a Row
        :param kwargs:
        :return:
        """
        session = next(db.session())
        query = session.query(cls)
        for key, val in kwargs.items():
            col = getattr(cls, key)
            query = query.filter(col == val)

        return query.all()

    @classmethod
    def filter(cls, session: Session = None, **kwargs):
        """
        Simply get a Row
        :param session:
        :param kwargs:
        :return:
        """
        cond = []
        for key, val in kwargs.items():
            key = key.split("__")
            if len(key) > 2:
                raise Exception("No 2 more dunders")
            col = getattr(cls, key[0])
            if len(key) == 1:
                cond.append((col == val))
            elif len(key) == 2 and key[1] == 'gt':
                cond.append((col > val))
            elif len(key) == 2 and key[1] == 'gte':
                cond.append((col >= val))
            elif len(key) == 2 and key[1] == 'lt':
                cond.append((col < val))
            elif len(key) == 2 and key[1] == 'lte':
                cond.append((col <= val))
            elif len(key) == 2 and key[1] == 'in':
                cond.append((col.in_(val)))
        obj = cls()
        if session:
            obj._session = session
            obj.served = True
        else:
            obj._session = next(db.session())
            obj.served = False
        query = obj._session.query(cls)
        query = query.filter(*cond)
        obj._q = query
        return obj

    def update(self, auto_commit: bool = False, **kwargs):
        print("kwargs:::", kwargs)
        qs = self._q.update(kwargs)
        get_id = self.todo_id
        ret = None

        self._session.flush()
        if qs > 0:
            ret = self._q.first()
        if auto_commit:
            self._session.commit()
        return ret

    def delete(self, auto_commit: bool = False):
        self._q.delete()
        if auto_commit:
            self._session.commit()


class TodoDetail(Base, BaseMixin):
    __tablename__ = "tb_todo"
    __table_args__ = {'extend_existing': True}
    todo_id = Column(Integer, primary_key=True, index=True)
    mem_id = Column(String(length=255), nullable=True)
    title = Column(String(length=2000), nullable=True)
    fr_date = Column(String(length=255), nullable=True)
    ed_date = Column(String(length=2000), nullable=True)
    noti_cycle = Column(String(length=255), nullable=True)
    noti_time = Column(String(length=255), nullable=True)
    todo_status = Column(String(length=255), nullable=True)
    challange_status = Column(String(length=255), nullable=True)
    chaluser_yn = Column(String(length=255), nullable=True)
    certi_yn = Column(String(length=255), nullable=True)
    created_user = Column(String(length=255), nullable=True)
    updated_user = Column(String(length=255), nullable=True)

    # RelationShip
    # challenge_mem = relationship("ChallengeMem", back_populates="todoDetails")

    def __repr__(self):
        return "<TodoDetaildd %r>" % self.todo_id


class ChallengeMem(Base, BaseMixin):
    __tablename__ = "tb_challengeUser"
    chaluser_id = Column(Integer, primary_key=True, index=True)
    todo_id = Column(Integer, ForeignKey("tb_todo.todo_id"), nullable=True)
    mem_id = Column(String(length=255), nullable=True)
    created_user = Column(String(length=255), nullable=True)
    updated_user = Column(String(length=255), nullable=True)

    # RelationShip
    # todoDetails = relationship("TodoDetail", back_populates="challenge_mem")


class Certification(Base, BaseMixin):
    __tablename__ = "tb_certification"
    certi_id = Column(Integer, primary_key=True, index=True)
    todo_id = Column(Integer, ForeignKey("tb_todo.todo_id"), nullable=True)
    mem_id = Column(String(length=255), nullable=True)
    todo_date = Column(String(length=255), nullable=True)
    certi_img = Column(String(length=255), nullable=True)
    certi_voice = Column(String(length=255), nullable=True)
    certi_check = Column(CHAR(length=1), default="N")
    created_user = Column(String(length=255), nullable=True)
    updated_user = Column(String(length=255), nullable=True)
