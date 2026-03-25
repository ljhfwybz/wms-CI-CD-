#!/bin/bash

LOG_DIRS=(
    "/var/log/nginx"
    "/opt/app/logs"
)

RETENTION_DAYS=30

for log_dir in "${LOG_DIRS[@]}"; do
    if [ -d "$log_dir" ]; then
        echo "[$(date)] Cleaning up logs in $log_dir (older than ${RETENTION_DAYS} days)..."
        find "$log_dir" -type f -name "*.log" -mtime +${RETENTION_DAYS} -delete
        find "$log_dir" -type f -name "*.log.*" -mtime +${RETENTION_DAYS} -delete
    else
        echo "[$(date)] Log directory $log_dir does not exist, skipping..."
    fi
done

echo "[$(date)] Log cleanup completed!"
