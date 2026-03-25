#!/bin/bash

BACKUP_DIR="/opt/backups/mysql"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="db_warehouse"
DB_USER="root"
DB_PASS="ljh"
DB_HOST="localhost"
RETENTION_DAYS=7

mkdir -p ${BACKUP_DIR}

echo "[$(date)] Starting MySQL backup..."

docker exec wms_mysql mysqldump -u${DB_USER} -p${DB_PASS} ${DB_NAME} | gzip > ${BACKUP_DIR}/${DB_NAME}_${DATE}.sql.gz

if [ $? -eq 0 ]; then
    echo "[$(date)] MySQL backup completed: ${BACKUP_DIR}/${DB_NAME}_${DATE}.sql.gz"
else
    echo "[$(date)] MySQL backup failed!"
    exit 1
fi

echo "[$(date)] Cleaning up old backups (older than ${RETENTION_DAYS} days)..."
find ${BACKUP_DIR} -name "${DB_NAME}_*.sql.gz" -mtime +${RETENTION_DAYS} -delete

echo "[$(date)] Backup process completed!"
