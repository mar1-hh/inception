#!/bin/sh
set -eu

mkdir -p /backups

echo "Starting backup loop..."

while true; do
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

    mysqldump \
        -h "$WORDPRESS_DB_HOST" \
        -u "$MYSQL_USER" \
        -p"$MYSQL_PASSWORD" \
        "$MYSQL_DATABASE" \
        > "/backups/backup_${TIMESTAMP}.sql"

    echo "Backup created: backup_${TIMESTAMP}.sql"

    sleep 3600
done