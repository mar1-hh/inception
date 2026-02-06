#!/bin/sh
set -e

DATADIR="/var/lib/mysql"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

if [ ! -d "$DATADIR/mysql" ]; then
    echo "[mariadb] Initializing database..."
    mariadb-install-db --user=mysql --datadir="$DATADIR" >/dev/null

    echo "[mariadb] Creating database and users..."
    mysqld --user=mysql --bootstrap <<EOSQL
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOSQL
fi

chown -R mysql:mysql "$DATADIR"

echo "[mariadb] Starting mysqld..."
exec mysqld --user=mysql --bind-address=0.0.0.0
