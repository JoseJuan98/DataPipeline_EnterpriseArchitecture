#!/bin/sh

python3 csv2mysql.py --user=root --password=rideordie12 --database=test RawData.csv --pkey=systemtype,system_id
python3 csv2mysql.py --user=root  --password=rideordie12 --database=test Andre_Elements.csv --pkey=sid

#mysql -u root -prideordie12 test < Triggers.sql
#sudo mv /tmp/Property.csv /home/goldenfox/Escritorio/
#sudo mv /tmp/Element.csv /home/goldenfox/Escritorio/
#sudo mv /tmp/Relation.csv /home/goldenfox/Escritorio/
