#!/bin/bash

BASH_SCRIPT_DIR="/home/facundo/Documentos/Trabajos/bash_scripting"
#Imports
source "$BASH_SCRIPT_DIR"/git-check-git-repo-exists.sh
source "$BASH_SCRIPT_DIR"/log_system.sh

manage_modified=0
manage_deleted=0
manage_added=0
#manage_unresolved_conflicts=1
files_unmerged=
ask_for_checkout_files=0
diff_tool=kdiff3

help(){
	mOption="\t-m : add this flag to manage the modified files in your workspace.\n"
	dOption="\t-d : add this flag to manage the deleted files in your workspace.\n"
	aOption="\t-a : add this flag to manage the added files in your workspaces.\n"
	tOption="\t-t : use \'meld\' merge tool for diff merge, commonly used in GNOME enviroments. \'kdiff3\' is the default merge tool.\n"
	cOption="\t-c : check if you want to ask for reset files that are unmerged or 
ready for commit. Defaults to false.\n"
	helpMenu="\t-h : Show this help menu.\n"
	defaultBehauvior="By default, the manager reacts to \'U\' git status for files in workspace, this is, when exists a unresolved paths (i.e. when you pull content to your local repository and there is a conflict during merge). Informs of the \'U\' state of files, then open merging tools to resolve the conflict".

	printf "==={{{ status_manager [-mdatch] }}}===\n$defaultBehauvior \n $mOption $dOption $aOption $tOption $cOption $helpMenu"
}

message_important(){
 echo "<<<<< ========================MESSAGE==================================="
 echo "$1"
 echo "================================================================ >>>>>"
}


parseParam(){
	while getopts 'mdacth' OPTION; do
		case $OPTION in
			m)
				#TO-DO
				;;
			d)
				#TO-DO
				;;
			a)
				#TO-DO
				;;
			t)
				diff_tool=meld	
				;;
			c)
				ask_for_checkout_files=1
				;;
			*)
				help
				exit 0
				;;
		esac
	done
}

set_unmerged_paths(){
	files_unmerged=` git status --porcelain | tr -s ' ' ';' | grep -E U  |cut -d ';' -f 2`
	if [ -z "$files_unmerged" ]; then
		message_important "No se encontraron archivos en estado UNMERGED."
		exit 0
	fi
}

manage_unmerged_paths(){
	logsystem_do_log "git-status-manager:'''GIT STATUS output'''"
	logsystem_do_log "$(git status)"
	message_important "There is problems when merging files. The follow are the files 
with 
UNMERGED PATHS:"
	for i in $(seq 1 `echo "$files_unmerged" | wc -l`); do
		echo "$i --> " `echo "$files_unmerged" | sed "${i}q;d"` 
	done
	if [ $ask_for_checkout_files -gt 0 ]; then
		printf "Select the files you want to reset changes (separate the number 
with comma, p.e. 1,2,3,4,...):"
		read files_to_reset
		####TO-DO: Parse number of files selected, then do a 'git checkout' of those 
files, then update the list of files to do open in diff editor...
		#echo $files_to_reset
	fi
	for f in "$files_unmerged"; do
		logsystem_do_log "$(git diff "$f")" "$f: solving_unmerged_path_file"
		git mergetool --tool=$diff_tool "$f"
	done
	message_important "There was merged all files in conflict."
	
}

main(){
	check_if_on_git_repository
	logsystem_set_log_filename "git-status-manager-`date -I`.log"
	parseParam $*
	set_unmerged_paths
	manage_unmerged_paths
}

#Begin execution
main $*
