#!/bin/sh

python3 csv2mysql.py --user=root --password=dani --database=test RawData.csv #--pkey=systemtype,system_id
python3 csv2mysql.py --user=root  --password=dani --database=test Andre_Elements.csv #--pkey=sid

sudo mysql -u root -pdani --local-infile test < Triggers.sql
