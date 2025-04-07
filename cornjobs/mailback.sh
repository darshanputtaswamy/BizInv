#!/bin/sh
date=`date "+%Y-%d-%m"`
backupfolder="/data/app/backup"
bizInvDB=`minikube kubectl -- get pods | grep bizinv-db | cut -d' ' -f1`
if [ -z "$bizInvDB" ]
then
      echo "Backup zip file was not created, Database seems to down" | mail -s "Failed: DataBackup - $date"  3weitsolutions@gmail.com
      exit 1
fi
minikube kubectl -- exec -it $bizInvDB -- bash /var/script/backupBizInvDB.sh
sqlfile=$backupfolder/all-database-$(date +%d-%m-%Y).sql
zipfile=$backupfolder/all-database-$(date +%d-%m-%Y).zip
#checkexistence of today's backup and mail
if [ -f $sqlfile ]
then
    zip $zipfile $sqlfile
    if [ -f $zipfile ]
    then
    echo "backup file attached" | mail -s "DataBackup - $date" -a $zipfile 3weitsolutions@gmail.com
    else
    echo "backup zip file was not created" | mail -s "Failed: DataBackup - $date"  3weitsolutions@gmail.com
    fi
else
echo "backup sql file was not created" | mail -s "Failed: DataBackup - $date"  3weitsolutions@gmail.com
fi

find $backupfolder -mtime +3 -delete
exit 0