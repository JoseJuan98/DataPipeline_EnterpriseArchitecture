#!/usr/bin/python
# -*- coding: utf-8 -*-

#pip install sqlalchemy

from sqlalchemy import create_engine, Column, Integer, String, ForeignKey, MetaData, Table
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import mapper, sessionmaker, relationship
import csv

#DB_URL = 'mysql+mysqldb://aaa@testing1238:Abc12345@testing1238.mysql.database.azure.com:3306/mydatabase'
DB_URL = 'mysql+mysqldb://dani:Dani1234!@localhost/test'
ENGINE = create_engine(DB_URL)

Base = declarative_base()


class Elements(Base):
    __tablename__ = "Element"

    idEl = Column('idEl', Integer, primary_key=True)
    id = Column('ID', String)
    type = Column('TYPE', String)
    name = Column('NAME', String)
    documentation = Column('DOCUMENTATION', String)

class Andre_Elements(Base):
    __tablename__ = "Andre_Elements"

    id = Column('id', Integer, primary_key=True)
    sid = Column('sid', String)
    type = Column('type', String)
    name = Column('name', String)
    documentation = Column('documentation', String)

class Properties(Base):
    __tablename__ = "Property"

    id = Column('ID', String, primary_key=True)
    key = Column('KEY_P', String)
    value = Column('VALUE_P', String)


class Relations(Base):
    __tablename__ = "Relation"

    id = Column('ID', String, primary_key=True)
    type = Column('TYPE', String)
    name = Column('NAME', String)
    documentation = Column('DOCUMENTATION', String)
    source = Column('SOURCE', String)
    target = Column('TARGET', String)


Session = sessionmaker(bind=ENGINE)
session = Session()

 #cursor = ENGINE.connect()
 #query = 'select * from properties;'
 #result = cursor.execute(query)

elements = session.query(Elements).all()
andre_elements = session.query(Andre_Elements).all()

with open('atest_elements.csv', 'w') as file:
    writer = csv.writer(file)
    writer.writerow(["ID", "Type", "Name", "Documentation"])
    for e in elements:
        writer.writerow([e.id, e.type, e.name, e.documentation])
    for a in andre_elements:
        writer.writerow([a.sid, e.type, a.name, e.documentation])



properties = session.query(Properties, Elements).filter(Properties.id == Elements.idEl).all()

with open('atest_properties.csv', 'w') as file:
    writer = csv.writer(file)
    writer.writerow(["ID", "Key", "Value"])
    for p, e in properties:
        writer.writerow([e.id, p.key, p.value])


relations = session.query(Relations, Elements, Andre_Elements).filter(Relations.target == Elements.idEl).filter(Relations.source == Andre_Elements.id).all()

with open('atest_relations.csv', 'w') as file:
    writer = csv.writer(file)
    writer.writerow(["ID", "Type", "Name", "Documentation", "Source", "Target"])
    for r, e, a in relations:
        writer.writerow([r.id, r.type, r.name, r.documentation, a.sid, e.id])


#ID Type Name Documentation - elements
#ID Type Name Documentation Source Target - relations
#ID Key Value - properties

#workbook = xlsxwriter.Workbook('demo.xlsx')
#worksheet = workbook.add_worksheet('Elements')
#worksheet = workbook.add_worksheet('Properties')
#worksheet = workbook.add_worksheet('Relations')
#worksheet = workbook.add_worksheet('Rådata')
#worksheet = workbook.add_worksheet('Fellestjenester')
#worksheet = workbook.add_worksheet('Andre Elementer')
#worksheet.write('A1', 'Hello world')
#workbook.close()
