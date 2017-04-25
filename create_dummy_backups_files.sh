#!/bin/bash
# Script que genera archivos falsos de backups

TMP_FILE=/tmp/test_file_safe_to_delete.txt
#Default number of copies to do
N_COPIES=90
#Default directory where put the copies
DIR_COPIES=/tmp/prueba
#Set to true if you want to create the files with modified creation date 
CHANGE_CREATION_DATE=0
#Set to true if you want to decrement days of creation instead of adding...
DECREMENT_DATES=0

DATESTR=`date +%C%y%m%d` 

#Si al menos existe un dummy backup, entonces tomamos la fecha de su nombre para generar los nuevos backups...

if [ ! -d $DIR_COPIES ]; then
    mkdir -p $DIR_COPIES
fi 

if [ ! -z `find $DIR_COPIES -maxdepth 1 -type f | sort -r | head -1` ]; then
    DATESTR=`find $DIR_COPIES -maxdepth 1 -type f | sort -r | head -1 | cut -d '_' -f 2 | xargs date +%C%y%m%d -d`
fi


while getopts ":cmd:" option; do
    case $option in
	c)
	   N_COPIES=$OPTARG
	   ;;
	m)
	   CHANGE_CREATION_DATE=1
	   ;;
    esac
done

#Populate TMP_FILE
ls --help > $TMP_FILE

if [ $DECREMENT_DATES -gt 0 ] ; then
   DATE_OPERATOR="-"
else
   DATE_OPERATOR="+"
fi

for i in `seq -w 1 $N_COPIES`
do
    FICT_DATE=`date -d "$DATESTR $DATE_OPERATOR $i days" +%Y-%m-%d_%H%M`
    cp "$TMP_FILE" "$DIR_COPIES/backup_$FICT_DATE.bkp.gz"
    if [ $CHANGE_CREATION_DATE -gt 0 ]; then 
    	CREATION_DATE_STR=`date -d "$DATESTR $DATE_OPERATOR $i days" +%Y-%m-%d`
	touch -a -m -d "$CREATION_DATE_STR" $DIR_COPIES/backup_$FICT_DATE.bkp
    fi
done

