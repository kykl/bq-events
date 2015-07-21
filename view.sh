#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Usage: $0 sqlfile"
	exit 1
fi

table=$(basename $1|sed -e"s/[.]sql//g"); 
bq mk --view="$(grep -v "^--" ${table}.sql |tr "\n" " ")" insight.$table
