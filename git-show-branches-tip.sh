#!/bin/bash

BASH_SCRIPT_DIR="/home/facundo/Documentos/Trabajos/bash_scripting"
#Imports
source "$BASH_SCRIPT_DIR"/git-check-git-repo-exists.sh
source "$BASH_SCRIPT_DIR"/message-print.sh

#Vars
TMP_DIR=$(mktemp -d)
params="-l"
interactive_mode=10
max_depth_look_behind_tip=0

#----------------------------------- FUNCTIONS -----------------------------------------------

help(){
	parameters="aih -d <depth>"
	defaultBehavior="This script iterates over all branches tips and applies a 'git show' over each.\n'"
	aOption="\t-a : show all branches instead only local branches."
	iOption="\t-i : activate de interactive mode. At every branch show, it let you select what branches to show.\n"
	dOption="\t-d <depth>: look back as far as <depth> commits behind the branch tips to show. <depth> is a number. P.e.: if '-d 4', the command will show master, master~1, master~2, master~3 and master~4 commits.\n"
	hOption="\t-h : show this help menu.\n"
	printf "{{git-show-branches-tip [-$parameters] }}: $defaultBehavior $iOption $dOption $hOption"
}


parseParam(){
    while getopts 'aihd:' OPTION; do
        case $OPTION in
            a)
                params=$(echo $params | tr '\-l' '\-a')
                ;;
            d)
                max_depth_look_behind_tip=$OPTARG
                if [ "$max_depth_look_behind_tip" -lt 0 ]; then
                    message_error "The <depth> passed to '-d' must be positive." 200 
                fi
                ;;
            i)
                interactive_mode=1
                ;;
            *)
                help
                exit 0
                ;;
        esac
    done
}

show_branches(){
	#Iterate over branches
	branch_tips=`git branch "$params" | tr -s ' ' | cut -d ' ' -f 2 | tr '\n' ' '`

	if [ "$interactive_mode" -gt 0 ]; then
            branches_numbered=`git branch "$params" | tr -s ' ' | cut -d ' ' -f 2 | gawk 'BEGIN{ a=1 }{ printf "%01d) %s \n", a++, $0 }'`
            message_important  "Select which branches you want to show, using a comma without interspaces beetwen numbers:"
            echo "$branches_numbered"
            #Show all branches in numeric menu form and let user select those he wants to print.
            printf "\nEnter selection: "; read selection
   	    #UPDATE the branch tips selected by the user
            branch_tips=$(echo "$branches_numbered" | egrep "[`echo "$selection" | tr ',' '|'` | sort]).*" | cut -d ' ' -f 2 | tr '\n' ' ')
            echo "$branches_numbered"
            echo $branch_tips; read
    fi
	
	#Iterate over branches
	for branch in $branch_tips; do
	    clear
	    message_question "Showing the \"$branch\" branch. Do you want to follow??? Please press 'N' if wants to exit; otherwise press any other key..."  100 "N"
            for position in $(seq -s ' ' 0 "$max_depth_look_behind_tip"); do 
                message_simple "--- @$branch~$position ---" "--color" "white"
                git show --format=oneline "$branch~$position"
            done
            message_important_wait "Press a key to continue..."
	done
}

#--------------------------------------------- MAIN ---------------------------------------------
parseParam $*

check_if_on_git_repository

show_branches $*
