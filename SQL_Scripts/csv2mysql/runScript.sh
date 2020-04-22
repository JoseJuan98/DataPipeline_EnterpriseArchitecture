#!/bin/sh

python3 csv2mysql.py --user=root --password=rideordie12 --database=test RawData.csv --pkey=systemtype,system_id
#python3 csv2mysql.py --user=root  --password=rideordie12 --database=test Andre_Elements.csv --pkey=sid
