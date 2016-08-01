#!/bin/bash

#-------------------------
# Check if core.autocrlf is setted in input
#-------------------------
check_endline_config(){
	if [ -z "`git config --local core.autocrlf`" ] or [ "`git config --local core.autocrlf`" != "input" ]; then
		git config --local core.autocrlf input
	fi
}


#main
check_endline_config
#Save actual working tree state. The '-u' updates all the files in the index.
git add . -u
git commit -m "Saving files before refreshing line endings"

#Removing the cached files in the index with the CRLF endline.
git rm --cached -r .

#Getback the index state to the last commit state.
git reset --hard HEAD
