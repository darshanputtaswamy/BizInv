# Backup storage directory 
backupfolder=/var/backup
# MySQL user
user=root       
# MySQL password
password=testing
# Number of days to store the backup 
sqlfile=$backupfolder/all-database-$(date +%d-%m-%Y).sql
# Create a backup 
mysqldump -u $user -p$password --databases BizInvDB > $sqlfile 
if [ $? == 0 ]; then
  echo 'Sql dump created' 
else
  exit 
fi 