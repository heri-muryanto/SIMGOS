#!/bin/bash
DB_USER="[USER]" 
DB_PASSWORD="[PASSWORD]" 
DB_HOST=[HOST]

# Buat direktory "backupSingle" di /root terlebih dahulu.
backup_dir="/root/backupSingle" 

day=$(date +"%Y-%m-%d") 
hour_minute=$(date +"%H-%M") 

#ketik semua nama database yang ingin di backup, sesuaikan dengan kondisi di lapangan
DB_NAMES2="database1 database2 database3" 

#nama file backup oroginal
BACKUP_MIX="$backup_dir/SIMGOSV2-full-$day-$hour_minute.sql" 

#nama file yang sudah di remove definer nya
BACKUP_SED="$backup_dir/SIMGOSV2-full-SED-$day-$hour_minute.sql" 

#proses backup
mysqldump --host=$DB_HOST -u $DB_USER -p$DB_PASSWORD --databases $DB_NAMES2 --add-drop-database --single-transaction --events --replace --routines > $BACKUP_MIX

#copy backup ory ke SED
cp $BACKUP_MIX $BACKUP_SED

#proses menghilangkan definer
sed 's/\sDEFINER=`[^`]*`@`[^`]*`//g' -i $BACKUP_SED


#procedure untuk hapus file yang usianya lebih dari 3 hari
# Batas usia file/direktori (dalam hari)
age_limit=$((3 * 24 * 60 * 60))

# Dapatkan daftar direktori
for delete_file in "$backup_dir"/*; 
do
	# Jika file adalah direktori dan usianya lebih dari batas, hapus
	if  [ $(( $(date +%s) - $(stat -c %Y "$delete_file") )) -gt $age_limit ]; then
		rm -rf "$delete_file"
	fi 
done
