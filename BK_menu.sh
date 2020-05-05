#!/bin/bash
# A menu driven shell script sample template 
## ----------------------------------
# Step #1: Define variables
# ----------------------------------
EDITOR=vim
PASSWD=/etc/passwd
RED='\033[0;41;30m'
STD='\033[0;0;39m'
 
# ----------------------------------
# Step #2: User defined function
# ----------------------------------
pause(){
  echo " "
  read -p "Press [Enter] key to continue..." fackEnterKey
}

installSw(){
	echo "installSw called"
	cd csv2mysql/
	sudo ./instScript.sh
	cd ..
        pause
}
 
createRawDataTable(){
	echo "runScript called"
	cd csv2mysql/
	sudo ./runScript.sh
	cd ..        
	pause
}

generateNormalisedModel() {
	cd SQL_scripts/
	sudo mysql -u root -prideordie12 test < systemoversikten.sql
	cd ..
	pause
}

loadData() {
	cd SQL_scripts/
	sudo mysql -u root -prideordie12 test < loadRawData.sql
	cd ..
	pause
}

cleanDataFromTables() {
	cd SQL_scripts/
	sudo mysql -u root -prideordie12 test < cleanDB.sql
	cd ..
	pause
}
dropDB() {
	cd SQL_scripts/
	sudo mysql -u root -prideordie12 test < deleteDB.sql
	cd ..
	pause
}

printBanner() {
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
	echo " TESTING PHASE v0.1 - Working on DB test " 
	echo " "
}

# function to display menus
show_menus() {
	printBanner;
	echo " 1. Install required software"
	echo " X. Select DB to work with "
	echo " X. Generate RawData, Normalised and ArchiModel DB and LOAD data "
	echo " 2. Generate RawData DB from csv file"
	echo " 3. Generate Normalised DB Model "
	echo " X. Generate Archi DB Model "
	echo " 4. LOAD data "
	echo " 5. Clean tables "
	echo " 6. Drop database "
	echo " q. Exit"
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
	local choice
	read -p "Enter choice [ 1 - 7] -> " choice
	case $choice in
		1) installSw ;;
		2) createRawDataTable;;
		3) generateNormalisedModel;;
		4) loadData;;
		5) cleanDataFromTables;;
		6) dropDB;;
		q) exit 0;;
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
while true
do
 
	show_menus
	read_options
done
