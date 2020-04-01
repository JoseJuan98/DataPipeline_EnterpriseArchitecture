#!/usr/bin/python
# -*- coding: utf-8 -*-

#pip install sqlalchemy

from sqlalchemy import create_engine, Column, Integer, String, ForeignKey, MetaData, Table
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import mapper, sessionmaker, relationship
import csv

DB_URL = 'mysql+mysqldb://aaa@testing1238:Abc12345@testing1238.mysql.database.azure.com:3306/mydatabase'
ENGINE = create_engine(DB_URL)

Base = declarative_base()


class Elements(Base):
    __tablename__ = "elements"

    id = Column('ID', String, primary_key=True)
    type = Column('Type', String)
    name = Column('Name', String)
    documentation = Column('Documentation', String)


class Properties(Base):
    __tablename__ = "properties"

    id = Column('ID', String, primary_key=True)
    key = Column('Key', String)
    value = Column('Value', String)


class Relations(Base):
    __tablename__ = "relations"

    id = Column('ID', String, primary_key=True)
    type = Column('Type', String)
    name = Column('Name', String)
    documentation = Column('Documentation', String)
    source = Column('Source', String)
    target = Column('Target', String)


Session = sessionmaker(bind=ENGINE)
session = Session()

 #cursor = ENGINE.connect()
 #query = 'select * from properties;'
 #result = cursor.execute(query)

elements = session.query(Elements).all()

with open('atest_elements.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["ID", "Type", "Name", "Documentation"])
    for e in elements:
        writer.writerow([e.id, e.type, e.name, e.documentation])


properties = session.query(Properties).all()

with open('atest_properties.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["ID", "Key", "Value"])
    for p in properties:
        writer.writerow([p.id, p.key, p.value])


relations = session.query(Relations).all()

with open('atest_relations.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["ID", "Type", "Name", "Documentation", "Source", "Target"])
    for e in relations:
        writer.writerow([e.id, e.type, e.name, e.documentation, e.source, e.target])


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