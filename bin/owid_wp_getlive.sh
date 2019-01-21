#!/bin/bash -e

RSYNC="rsync -havz --progress"
HOST="owid@terra"

ssh $HOST "mysqldump --default-character-set=utf8mb4 owid_wordpress -r /home/owid/dev_wordpress.sql"
$RSYNC $HOST:/home/owid/owid_wordpress.sql ~/backup/
$RSYNC --delete $HOST:/home/owid/owid.cloud/wp-content/plugins ~/owid.cloud/wp-content/
$RSYNC --delete $HOST:/home/owid/owid.cloud/wp-content/uploads ~/owid.cloud/wp-content/
mysql -e "DROP DATABASE dev_wordpress;"
mysql --default-character-set="utf8mb4" -e "CREATE DATABASE dev_wordpress;"
mysql --default-character-set="utf8mb4" -D dev_wordpress -e "source ~/backup/owid_wordpress.sql;"
echo "UPDATE wp_options SET option_value='http://localhost:8080' WHERE option_name='siteurl';" | mysql -D dev_wordpress 
echo "UPDATE wp_options SET option_value='http://localhost:8080' WHERE option_name='home';" | mysql -D dev_wordpress 
