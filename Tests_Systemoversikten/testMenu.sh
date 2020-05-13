#!/bin/bash
# A menu driven shell script sample template 
## ----------------------------------
# Step #1: Define variables
# ----------------------------------
EDITOR=vim
PASSWD=/etc/passwd
RED='\033[0;41;30m'
GREEN='\e[32m'
STD='\033[0;0;39m'
 
EXIT=true
DB_test='test_Systems'
# ----------------------------------
# Step #2: User defined function
# ----------------------------------
pause(){
  echo " "
  read -p "Press [Enter] key to continue..." fackEnterKey
}

printBanner2() {
	clear
	echo " "
	echo " Software design and implemented by Team D24."
	echo " Database Modelling Enterprise Architecture Command-line Utility"
	echo " "
	echo "	 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"	
	echo "	|  ____                              _  __                                            |"
	echo "	| |  _ \                            | |/ /                                            |"
	echo "	| | |_) | ___ _ __ __ _  ___ _ __   | ' / ___  _ __ ___  _ __ ___  _   _ _ __   ___   |"
	echo "	| |  _ < / _ \ '__/ _' |/ _ \ '_ \  |  < / _ \| '_ ' _ \| '_ ' _ \| | | | '_ \ / _ \  |"
	echo "	| | |_) |  __/ | | (_| |  __/ | | | | . \ (_) | | | | | | | | | | | |_| | | | |  __/  |"
	echo "	| |____/ \___|_|  \__, |\___|_| |_| |_|\_\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|\___|  |"
	echo "	|                  __/ |                                                              |"
	echo "	|                 |___/                                                               |"
	echo "	 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo " "		
	echo " TESTING PHASE v0.1 - Working on DB $DB_test for TESTING" 
	echo " "
}
exitM () {
	echo " Droping database of testing before leaving..."
	mysql -u $USER -p$PASSW -e "DROP DATABASE $DB_test;"
	EXIT=false
	pause
}
exitN() {
	exitM
	exit 0
}
createDB_Test() {	
	echo -e " 				$GREEN Model Systemoversikten $STD"
	echo -e " Creating tables, inserting manual data and creating triggers for $RED TESTING $STD the model"

	mysql -u $USER -p$PASSW -e "CREATE DATABASE $DB_test;"

	cd Tests_Systemoversikten/
	mysql -u $USER -p$PASSW < createDB_Tables_Test.sql
	cd ..
	cd SQL_scripts/systemoversikten/
	mysql -u $USER -p$PASSW $DB_test < insertManuelt.sql
	mysql -u $USER -p$PASSW $DB_test < createTriggers.sql

	echo " This are the tables that have been created: "
	mysql -u $USER -p$PASSW $DB_test -e "Use $DB_test; Show tables;"
	cd ..
	cd ..
	pause
}
loadData_Test() {
	cd Tests_Systemoversikten/
#	mysql -u $USER -p$PASSW $DB_test -e "LOAD DATA LOCAL INFILE '$(pwd)/test_RawData' INTO TABLE $DB_test.RawData
#									FIELDS TERMINATED BY ','
#									OPTIONALLY ENCLOSED BY ''' 
#									LINES TERMINATED BY '\n'
#									IGNORE 1 LINES
#									(systemtype, system_id, navn, beskrivelse,systemeier,  systemkoordinator, admsone, sikker_sone, elevnett,tu_nett , internettviktighet, personopplysninger,  sensitive_personopplysninger);"

	echo -e " Loading data into $GREEN RawData $STD, which will display all the triggers to insert in the rest of tables"

	mysql -u $USER -p$PASSW $DB_test < loadRawData_Test.sql
	cd ..
	pause
}
update_test() {
	echo " Updating model via RawData table. "
	cd SQL_scripts/systemoversikten/
	mysql -u $USER -p$PASSW $DB < Update.sql
	cd ..
	cd ..
	pause
}
# function to display menus
show_menus1() {
	printBanner2;
	echo "TESTs avalaible for the DB $DB_test"
	echo " 1. Create Database $DB_test for testing "
	echo " 2. Load data to start"
	echo " 3. Update systemoversikten (Load)"
	echo " X. Generate Normalised DB Model "
	echo " X. Generate Archi DB Model "
	echo " X. LOAD data "
	echo " X. Clean tables "
	echo " 8. Drop database "
	echo " 9. "
	echo " c. Cancel"
	echo " q. Exit"
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select q form the menu option.
read_options1(){
	local choice
	read -p "Enter choice [ 1 - X] -> " choice
	case $choice in
		1) createDB_Test;;
		2) loadData_Test;;
		3) update_test;;
		4) ;;
		5) ;;
		6) ;;
		7) ;;
		8) mysql -u $USER -p$PASSW -e "DROP DATABASE $DB_test;";pause;;
		exit) exitN;;
		9) ;;
		q) exitN;;
		c) exitM;;
		pwd) echo $(pwd); pause;;
		*) echo -e "${RED}Error...${STD}" && sleep 1
	esac
}
 
# ----------------------------------------------
# Step #3: Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP

# -----------------------------------
# Step #4: Main logic - infinite loop
# ------------------------------------
testMenu() {
	while $EXIT
	do	 
		show_menus1
		read_options1
	done
}

