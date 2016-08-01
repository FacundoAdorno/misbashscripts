#!/bin/bash

check_if_on_git_repository(){
    git status &> /dev/null
    #If we aren't at a git repository, then exits the program...
    if [ `echo $?` -gt 0 ]; then
      echo "<<<-------------- [[ERROR]] --------------------------"
	  echo "Tiene que posicionarse sobre un repositorio git local."
	  echo "--------------------------------------------------->>>"
      exit 5
    fi
}
