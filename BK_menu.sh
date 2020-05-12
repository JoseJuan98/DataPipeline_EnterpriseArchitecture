#!/bin/bash
# A menu driven shell script sample template 
## ----------------------------------
# Step #1: Define variables
# ----------------------------------
EDITOR=vim
PASSWD=/etc/passwd
RED='\033[0;41;30m'
STD='\033[0;0;39m'
pwd=$(pwd)

USER=''
PASSW=''
DB=''
CONTINUE=true
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
update() {
	cd SQL_scripts/systemoversikten/
	sudo mysql -u root -prideordie12 test < Update.sql
	cd ..
	cd ..
	pause
}
generateNormalisedModel() {
	cd SQL_scripts/systemoversikten/
	sudo mysql -u root -prideordie12 < createDB_Tables.sql
	sudo mysql -u root -prideordie12 test < insertManuelt.sql
	sudo mysql -u root -prideordie12 test < createTriggers.sql
	cd ..
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
test1() {
	echo $(pwd)
	echo $pwd/Tests_Systemoversikten/testMenu.sh
	pause
	. Tests_Systemoversikten/testMenu.sh
	testMenu
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
logUsr() {
	printBanner;
	echo " Enter credentials for login into the DB "
	local usr
	read -p "	Enter user -> " usr
	USER=$usr
	local passwd
	read -p "	Enter passw -> " passwd
	PASSW=$passwd

#DO THE SAME WITH DB AND HOST

	echo "The user and pass selected are:" $USER "," $PASSW
	echo " "

	mysql -u $USER -p$PASSW -e "SELECT 'This are the databases that this user have access to' as Message; show databases;"
#	mysql -h HOST -P PORT_NUMBER -u USERNAME -p	
	EXITSTATUS=$?
	if [ "$EXITSTATUS" -ne "0" ]
   		then 
       		ERRORS=$EXITSTATUS\
			echo "" 
			echo -e " ${RED} Provide the correct credentials for this DB${STD}"
			echo "	1. Try again"
			echo "	q. Exit"
			local choice
			read -p " " choice
			case $choice in
				1) ;;
				q) exit 0;;		
				*) echo -e "${RED}Error...${STD}" && sleep 1
			esac
	else			
			local choice1
			echo " "
			read -p "Continue or exit. (Y/q) -> " choice1
			case $choice1 in
				y) CONTINUE=false;;
				q) exit 0;;		
				*) echo -e "${RED}Error...${STD}" && sleep 1
			esac
	fi
}
# function to display menus
show_menus() {
	printBanner;
	echo " 1. Change User"
	echo " 2. Install required software"
	echo " X. Select DB to work with "
	echo " X. Generate RawData, Normalised and ArchiModel DB and LOAD data "
	echo " X. Generate RawData DB from csv file"
	echo " 3. Generate Normalised DB Model "
	echo " X. Generate Archi DB Model "
	echo " 4. LOAD data "
	echo " 5. Clean tables "
	echo " 6. Drop database "
	echo " 7. Update systemoversikten (Load)"
	echo " 8. TESTs of this DB "
	echo " q. Exit"
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
	local choice
	read -p "Enter choice [ 1 - 8] -> " choice
	case $choice in
		1) logUsr;;
		2) installSw ;;
#		X) createRawDataTable;;
		3) generateNormalisedModel;;
		4) loadData;;
		5) cleanDataFromTables;;
		6) dropDB;;
		7) update;;
		8) test1;;
		q) exit 0;;
		d) exitM;;
		*) echo -e "${RED}Error...${STD}" && sleep 1
	esac
}
EXIT=true
exitM () {
	echo " Canceling "
	EXIT=false
	pause
} 
# ----------------------------------------------
# Step #3: Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP

# -----------------------------------
# Step #4: Main logic - infinite loop
# ------------------------------------
while $CONTINUE
do
	logUsr
done
while true
do 
	show_menus
	read_options
done
