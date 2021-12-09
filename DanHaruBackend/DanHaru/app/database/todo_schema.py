
from sqlalchemy import (
    Column,
    Integer,
    String,
    DateTime,
    func,
    Enum, Boolean,
)

from sqlalchemy.orm import Session
from datetime import datetime
from app.database.conn import Base, db

class BaseMixin:
    todo_id = Column(Integer, primary_key=True, index=True)
    created_at = Column(DateTime, nullable=False, default=datetime.today().strftime("%Y-%m-%d %H:%M:%S"))
    updated_at = Column(DateTime, nullable=False, default=datetime.today().strftime("%Y-%m-%d %H:%M:%S"), onupdate=datetime.today().strftime("%Y-%m-%d %H:%M:%S"))

    def all_columns(self):

        return [c for c in self.__table__.columns if c.primary_key is False and c.name != "created_at"]
        # return [c for c in self.__table__.columns if c.name != "created_at"]

    # def __hash__(self):
    #     return hash(self.id)

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
    def get_union_mem(cls, mem_id, fr_date):
        session = next(db.session())
        query1 = session.query(cls).filter(getattr(cls, "mem_id") == mem_id)\
            .filter(getattr(cls, "fr_date") == fr_date)\
            .filter(getattr(cls, "use_yn") == 'Y')
        query2 = session.query(cls).filter(getattr(cls, "mem_id") == mem_id)\
            .filter(getattr(cls, "ed_date") >= fr_date)\
            .filter(getattr(cls, "use_yn") == 'Y')

        query = query1.union(query2)

        return query.all()

    @classmethod
    def get_union_todo_id(cls, todo_id, fr_date):
        session = next(db.session())
        query1 = session.query(cls).filter(getattr(cls, "todo_id") == todo_id)\
            .filter(getattr(cls, "fr_date") == fr_date)\
            .filter(getattr(cls, "use_yn") == 'Y')
        query2 = session.query(cls).filter(getattr(cls, "todo_id") == todo_id)\
            .filter(getattr(cls, "ed_date") >= fr_date)\
            .filter(getattr(cls, "use_yn") == 'Y')

        query = query1.union(query2)

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
        qs = self._q.update(kwargs)
        # get_id = self.id
        ret = None

        self._session.flush()
        if qs > 0:
            ret = self._q.first()
        if auto_commit:
            self._session.commit()
        return ret

class Todo(Base, BaseMixin):
    __tablename__ = "tb_todo"
    mem_id = Column(String(length=255), nullable=True)
    title = Column(String(length=2000), nullable=True)
    fr_date = Column(String(length=255), nullable=True)
    ed_date = Column(String(length=255), nullable=True)
    noti_cycle = Column(String(length=255), nullable=True)
    noti_time = Column(String(length=255), nullable=True)
    todo_status = Column(String(length=255), default="N")
    challange_status = Column(String(length=255), default="N")
    chaluser_yn = Column(String(length=255), default="N")
    certi_yn = Column(String(length=255), default="N")
    created_user = Column(String(length=255), nullable=True)
    updated_user = Column(String(length=255), nullable=True)
    use_yn = Column(String(length=10), default="Y")
