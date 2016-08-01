#!/bin/bash
installed=`pacman -Q | sed -e "s|\(.*[^ ]*\) .*|\1|g" `
repos=`pacman -Sl | sed -e "s|[^ ]* \(.*[^ ]*\) .*|\1|g"`

for pkg in $installed
do
    found=`echo $repos | grep $pkg`
    if [ "$found" == "" ]; then
        echo $pkg
    fi
done
# end
