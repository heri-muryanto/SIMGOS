#!/bin/bash
DB_USER="admin" 
DB_PASSWORD="S!MRSGos2" 
DB_HOST=192.168.13.2
# Define backup directory and file names
backup_dir="/root/backupSingle" 
day=$(date +"%Y-%m-%d") 
hour_minute=$(date +"%H-%M") 

DB_NAMES2="addOnJP addOnRSUD antara_pacs aplikasi berkas_klaim berkas_rekammedis bpjs bridge cetakan document-storage dukcapil gambar generator gudang h2h_bjt icliptron inacbg informasi inventory jadwal_operasi kemkes kemkes-ihs kemkes-rsonline kemkes-sirs laporan layanan lis master medicalrecord migrasi mutu pacs pegawai pembatalan pembayaran pendaftaran penjamin_rs penjualan ppi procedure regonline replicatest sai sakti satset" 

BACKUP_MIX="$backup_dir/SIMGOSV2-full-$day-$hour_minute.sql" 
BACKUP_SED="$backup_dir/SIMGOSV2-full-SED-$day-$hour_minute.sql" 

mysqldump --host=$DB_HOST -u $DB_USER -p$DB_PASSWORD --databases $DB_NAMES2 --add-drop-database --single-transaction --events --replace --routines > $BACKUP_MIX

cp $BACKUP_MIX $BACKUP_SED

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
