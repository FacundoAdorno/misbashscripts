#!/bin/bash

# This script updates the current version of ATOM IDE, if installed using github source code...
# The releases of ATOM in GitHub --> https://github.com/atom/atom/releases

ATOM_DIR=`pwd`/atom
function message(){
  echo "==================================="
  echo "$1"
  echo "==================================="
}

function simple_message(){
  echo "--> $1 ..."
}

function update_node(){
	. ~/.nvm/nvm.sh	
	#triming ending leading whitespaces
	#CURRENT_NODE_VERSION=`nvm ls | head -n 1 | awk '{$1=$1;print}' | sed 's/ v//g' | sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g'`
	CURRENT_NODE_VERSION="`node -v | sed 's/v//g'`"
	#CHECK NODE IF NECESSARY UPDATE
	message "UPDATING NODE"
	simple_message "Checking remote lts/boron versions"
	nvm ls-remote  | grep "LTS: Boron"

	simple_message "Your current version of node is $CURRENT_NODE_VERSION. Want to update? (y/n)" 
	read response

	if [ "$response" == 'y' ]; then
		nvm install lts/boron --reinstall-packages-from=$CURRENT_NODE_VERSION
		message "Please, CLOSE this tab and opens a new one. Then executes this command with the '--continue' flag"
		exit 1
	else
		simple_message "Preserving node to v$CURRENT_NODE_VERSION"
	fi
}

cd $ATOM_DIR
FLAG="$1"
if [ "$FLAG" != '--continue' ]; then
	update_node
fi

message "UPDATING ATOM EDITOR"
simple_message "Currently updating the '1.18-releases' branch"
#UPDATE GIT
git checkout 1.18-releases
git pull origin 1.18-releases

#UPDATE ATOM
script/build

simple_message "Exiting"
exit 0
