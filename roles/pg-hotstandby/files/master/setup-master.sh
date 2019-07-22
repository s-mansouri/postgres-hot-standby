#!/bin/bash
echo "host replication $PG_REP_USER $PG_SLAVE_HOST/32  md5" >> "$PGDATA/pg_hba.conf"

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER $PG_REP_USER REPLICATION LOGIN CONNECTION LIMIT 100 ENCRYPTED PASSWORD '$PG_REP_PASSWORD';
EOSQL

cat >> ${PGDATA}/postgresql.conf <<EOF
listen_addresses = '*' 
wal_level = hot_standby
archive_mode = on
archive_command = 'rsync -a %p -e "ssh -o StrictHostKeyChecking=no" root@$PG_SLAVE_HOST:/root/pg-hotstandby-slave/data/ARCHIVELOG/%f '
max_wal_senders = 3 
wal_keep_segments = 8
EOF



echo "Creating database for harbor"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE notarysigner;
    CREATE DATABASE registry ENCODING 'UTF8';
    CREATE DATABASE clair;
    GRANT ALL PRIVILEGES ON DATABASE notaryserver TO $POSTGRES_USER;
    GRANT ALL PRIVILEGES ON DATABASE notarysigner TO $POSTGRES_USER;
    GRANT ALL PRIVILEGES ON DATABASE registry TO $POSTGRES_USER;
    GRANT ALL PRIVILEGES ON DATABASE clair to $POSTGRES_USER;
EOSQL