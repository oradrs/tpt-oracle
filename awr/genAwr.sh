#!/usr/bin/bash

# Usage : to generate and send AWR by mail : ./genAwr.sh Y
# Usage : to generate AWR : ./genAwr.sh
# Note : Modify snapshot date range in fndawrbld.sql file
# depend on : fndawrbld.sql and fndawrrpt.sql
#########################################

rm -fv fndawrbatch.sql
rm -fv *.html.gz *.html *.tar


dbname="[db TNS name]"
username="[ora username]"
passwd="[ora password]"

sendto="[add email id here]"

# generate AWR
sqlplus -L -F -S $username/$passwd@$dbname @fndawrbld.sql

pigz -v *.html

# send AWR by mail ?
if [[ $1 == 'Y' ]]; then
    for fname in *.gz
    do
        filelist="$filelist -a $fname "
    done

    # echo $filelist
	echo "AWR report from $dbname" | mail -s "AWR report from $dbname" $filelist $sendto
    echo	
    echo "AWR reports has been sent by email."
	echo
else
    echo
	ls -l *.gz
	tar -cvf awr_$dbname.tar *.gz
	echo
fi

