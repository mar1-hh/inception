#!/bin/sh
set -e

DATADIR="/var/lib/mysql"
# Use the database name from .env
MYSQL_DATABASE=${MYSQL_DATABASE:-wordpress}

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Check if OUR specific database exists
if [ ! -d "$DATADIR/$MYSQL_DATABASE" ]; then
    echo "[mariadb] Initializing database (first run)..."
    mariadb-install-db --user=mysql --datadir="$DATADIR" >/dev/null

    echo "[mariadb] Starting temporary server for setup..."
    # Start temporary server without networking
    mysqld --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
    PID="$!"
    
    # Wait for server to start
    for i in {30..0}; do
        if mysql --socket=/run/mysqld/mysqld.sock -uroot -e "SELECT 1" >/dev/null 2>&1; then
            break
        fi
        echo "[mariadb] Waiting for server... ($i attempts left)"
        sleep 1
    done

    echo "[mariadb] Creating database and users..."
    # Run the SQL setup
    mysql --socket=/run/mysqld/mysqld.sock -uroot <<EOSQL
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOSQL

    # Shutdown temporary server
    mysqladmin --socket=/run/mysqld/mysqld.sock -uroot shutdown
    wait "$PID"
    
    echo "[mariadb] Setup complete! Database '$MYSQL_DATABASE' created."
else
    echo "[mariadb] Database '$MYSQL_DATABASE' already exists, skipping setup"
fi

chown -R mysql:mysql "$DATADIR"

echo "[mariadb] Starting mysqld..."
exec mysqld --user=mysql --bind-address=0.0.0.0