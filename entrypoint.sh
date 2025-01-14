#!/bin/sh -l

#set -e at the top of your script will make the script exit with an error whenever an error occurs (and is not explicitly handled)
set -eu


TEMP_SSH_PRIVATE_KEY_FILE='../private_key.pem'
TEMP_SFTP_FILE='../sftp'

# keep string format
printf "%s" "$4" >$TEMP_SSH_PRIVATE_KEY_FILE
# avoid Permissions too open
chmod 600 $TEMP_SSH_PRIVATE_KEY_FILE

echo 'sftp start'
# create a temporary file containing sftp commands
touch $TEMP_SFTP_FILE
if [ -d "$5" ] 
then
  printf "%s\n" "-mkdir $6" >$TEMP_SFTP_FILE
  (cd $5; find * -type d -exec echo -mkdir $6/{} \;) >>$TEMP_SFTP_FILE
  printf "%s" "put -r $5* $6" >>$TEMP_SFTP_FILE
else
  printf "%s" "put $5 $6" >>$TEMP_SFTP_FILE
fi
# upload actual data

#-o StrictHostKeyChecking=no avoid Host key verification failed.
sftp -b $TEMP_SFTP_FILE -P $3 $7 -o StrictHostKeyChecking=no -i $TEMP_SSH_PRIVATE_KEY_FILE $1@$2

echo 'deploy success'
exit 0

