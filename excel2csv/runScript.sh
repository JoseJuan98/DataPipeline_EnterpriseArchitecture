#!/bin/sh

#LATER CHANGE TO DO IT WITH argv(1)
PATH_TO_EXCEL="/home/goldenfoxp/Documents/Project/SQL_Scripts/scriptExcel2CSV/test/FellesTjenester.xlsx"
name_csv_files="" #"`date '+%m-%d-%Y'`-" 
pwd="$(pwd)/db_test/"

python3 excel2csv.py $PATH_TO_EXCEL "$pwd$name_csv_files%s.csv"

chmod -R 777 "$pwd"
