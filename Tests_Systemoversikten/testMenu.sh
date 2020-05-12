#!/bin/bash
# A menu driven shell script sample template 
## ----------------------------------
# Step #1: Define variables
# ----------------------------------
EDITOR=vim
PASSWD=/etc/passwd
RED='\033[0;41;30m'
STD='\033[0;0;39m'
 
EXIT=true
# ----------------------------------
# Step #2: User defined function
# ----------------------------------
pause(){
  echo " "
  read -p "Press [Enter] key to continue..." fackEnterKey
}


test() {

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
	echo " TESTING PHASE v0.1 - Working on DB test " 
	echo " "
}
exitM () {
	echo " Canceling Testing"
	EXIT=false
	pause
}
# function to display menus
show_menus1() {
	printBanner2;
	echo "TESTs avalaible for this DB"
	echo " 1.  "
	echo " 2. Generate RawData, Normalised and ArchiModel DB and LOAD data "
	echo " 3. Generate RawData DB from csv file"
	echo " 4. Generate Normalised DB Model "
	echo " 5. Generate Archi DB Model "
	echo " 6. LOAD data "
	echo " 7. Clean tables "
	echo " 8. Drop database "
	echo " 9. Update systemoversikten (Load)"
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
		1) ;;
		2) ;;
		3) ;;
		4) ;;
		5) ;;
		6) ;;
		7) ;;
		8) test;;
		q) exit 0;;
		c) exitM;;
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

