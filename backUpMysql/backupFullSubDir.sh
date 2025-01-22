#!/bin/bash
# Define database credentials

DB_USER="[USER]"
DB_PASSWORD="[PASSWORD]"
DB_NAMES=(database1 database2 database3)
DB_HOST=[HOST]

# buat direktory backupDir terlebih dahulu
backup_dir="/root/backupDir"

day=$(date +"%Y-%m-%d")
hour_minute=$(date +"%H-%M")
backup_file="full-$hour_minute.sql"

# Create daily backup directory if it doesn't exist
if [ ! -d "$backup_dir/$day" ]; then
  mkdir "$backup_dir/$day"
fi

TODAY_DIR="$backup_dir/$day"

# Create hour-minute backup directory if it doesn't exist
if [ ! -d "$backup_dir/$day/$hour_minute" ]; then
  mkdir "$backup_dir/$day/$hour_minute"
fi

TODAY_DIR="$backup_dir/$day/$hour_minute"
TODAY_MIX="$backup_dir/SIMRSGOSV2-$day"

# Loop through each database and dump to separate backup files
for DB_NAME in "${DB_NAMES[@]}"; do
  #file backup
  BACKUP_FILE="$TODAY_DIR/$DB_NAME-$backup_file"

  #file backup yang definernya sudah dihapus
  BACKUP_FILE_SED="$TODAY_DIR/$DB_NAME-SED-$backup_file"
  
  mysqldump --host=$DB_HOST  -u $DB_USER -p$DB_PASSWORD $DB_NAME --add-drop-database --single-transaction --events --replace --routines > $BACKUP_FILE

  #proses penghapusan definer
  cp $BACKUP_FILE $BACKUP_FILE_SED
  sed 's/\sDEFINER=`[^`]*`@`[^`]*`//g' -i $BACKUP_FILE_SED
  
done

