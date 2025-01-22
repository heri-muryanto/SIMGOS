#!/bin/bash
# Define database credentials
#username="your_username"
#password="your_password"
#database="your_database_name"

DB_USER="admin"
DB_PASSWORD="S!MRSGos2"
DB_NAMES=(addOnJP addOnRSUD antara_pacs aplikasi berkas_klaim berkas_rekammedis bpjs bridge cetakan document-storage dukcapil gambar generator gudang h2h_bjt icliptron inacbg informasi inventory jadwal_operasi kemkes kemkes-ihs kemkes-rsonline kemkes-sirs laporan layanan lis master medicalrecord migrasi mutu pacs pegawai pembatalan pembayaran pendaftaran penjamin_rs penjualan ppi procedure regonline replicatest sai sakti satset)
DB_HOST=192.168.13.2

# Define backup directory and file names
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
  BACKUP_FILE="$TODAY_DIR/$DB_NAME-$backup_file"
  BACKUP_FILE_SED="$TODAY_DIR/$DB_NAME-SED-$backup_file"
  mysqldump --host=$DB_HOST  -u $DB_USER -p$DB_PASSWORD $DB_NAME --add-drop-database --single-transaction --events --replace --routines > $BACKUP_FILE
  #gzip $BACKUP_FILE
  
  cp $BACKUP_FILE $BACKUP_FILE_SED
  
  sed 's/\sDEFINER=`[^`]*`@`[^`]*`//g' -i $BACKUP_FILE_SED
  
done

