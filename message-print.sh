#!/bin/sh

#This library is used to print diferent types of messages in the terminal output.

#Printf - FORMATING_COLORS
colors='RED \e[31m
YELLOW \e[33m
GREEN \e[32
BLUE \e[34m
WHITE \e[97m'
DEFAULT="\e[39m"

#Used to format to ouput color of printfl
PRE_FORMAT=
POS_FORMAT=


color_parser(){
    if [ -n "$1" ]; then
        PRE_FORMAT=$(echo "$colors" | grep -i "$3" | cut -d ' ' -f 2)
        POS_FORMAT=$DEFAULT
    fi
}

#Possible params
#1) $1 is a exit_code
#2) $1 is '-t', $2 and $3 are '-t' params, and $4 is the exit_code
check_if_exit(){
	if [ "$1" == '-t' ]; then
		expected_to_end="$2"
		user_answer="$3"
		#If the answer is as expected; then exits 
		if [ "$2" == "$3" ]; then
			exit $4
		fi
	else 
		if [ -n "$1" ]; then
			exit $1
		
		fi
	fi
}

do_message(){
    message="$1"
    printf "${PRE_FORMAT} $message ${POS_FORMAT}"
}


message_important(){
	MSG_FORMAT="<<<<< ========================MESSAGE!===================================\n$1\n================================================================ >>>>>\n"
	do_message "$MSG_FORMAT"
	#printf "<<<<< ========================MESSAGE!===================================\n"
	#printf "$1\n"
	#printf "================================================================ >>>>>\n"
	check_if_exit "$2"
}

#Use this message function if you want wait for a user key input to continue with some processing
message_important_wait(){
	message_important "$1"
	#waiting...
	read
}

message_simple(){
    if [ "$2" == "--color" -a -n "$3" ]; then
        color_parser "$3"
    fi
    MSG_FORMAT="\n<<<<<<<<<<<  $1  >>>>>>>>>>>\n"
    do_message "$MSG_FORMAT"
    #printf "\n${PRE_FORMAT}<<<<<<<<<<<  $1  >>>>>>>>>>>\n${POS_FORMAT}"
}

message_error(){
    MSG_FORMAT="<<<<< ========================ERROR!===================================\n$1\n================================================================ >>>>>\n"
    do_message "$MSG_FORMAT"
    #echo "<<<<< ========================ERROR!==================================="
    #echo "$1"
    #echo "================================================================ >>>>>"
    check_if_exit "$2"
}

# To invoke:
# message_question "<question_message>" "<expected_exit_answer>" "<exit_code>"
# This question have two outcomes: it exits other not.
message_question(){
    input_to_exit="$3"
    MSG_FORMAT="<<<<< =======================QUESTION!=================================\n$1\n================================================================ >>>>>\n"
    do_message "$MSG_FORMAT"
    #echo "<<<<< =======================QUESTION!================================="
    #echo "$1"
    #echo "================================================================ >>>>>"
    
    #read_for_user_input
    read answer
    check_if_exit "-t" "$input_to_exit" "$answer" $2
}

