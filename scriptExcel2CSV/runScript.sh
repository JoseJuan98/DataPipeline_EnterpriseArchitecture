#!/bin/sh

PATH_TO_EXCEL="/home/goldenfox/Documentos/Project/scriptExcel2CSV/test/FellesTjenester.xlsx"
#name_csv_files="`date '+%m-%d-%Y'`-"

python3 excel2csv.py $PATH_TO_EXCEL "$name_csv_files%s.csv"
