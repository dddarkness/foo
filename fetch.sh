#!/bin/bash

TOKEN=05d81acc4d9f
DATADIR=./data
RS_DATA=./rs-data.txt
AMT_RS=$(wc -l rs-data.txt | awk '{ print $1}' )

[[ ! -d $DATADIR ]] && mkdir -p $DATADIR

if [[ ! -f $RS_DATA ]]; then
	echo No input data $RS_DATA, abort.
	exit 1
fi

which dos2unix > /dev/null
[[ $? -ne 0 ]] && sudo apt install dos2unix
dos2unix $RS_DATA

i=1
for RS_VAR in $(cat $RS_DATA); do
	clear
	echo "Fetching $RS_VAR ($i/$AMT_RS)..."
	URI="https://ldlink.nci.nih.gov/LDlinkRest/ldproxy?var=${RS_VAR}&pop=CEU&r2_d=r2&token=${TOKEN}"
	CMD="curl -k -X GET $URI -o $DATADIR/$RS_VAR"
	echo $URI
	echo $CMD
	$CMD
	i=$((i=i+1))
done
