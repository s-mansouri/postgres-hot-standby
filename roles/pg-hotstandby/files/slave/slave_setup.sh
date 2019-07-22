#!/bin/bash
if [ ! -s "$PGDATA/PG_VERSION" ]; then
echo "*:*:*:$PG_REP_USER:$PG_REP_PASSWORD" > ~/.pgpass

chmod 0600 ~/.pgpass

rm -r ${PGDATA}

until pg_basebackup -h ${PG_MASTER_HOST} -D ${PGDATA} -U ${PG_REP_USER} -vP -W
    do
        echo "Waiting for master to connect..."
        sleep 1s
done

set -e

echo "host replication all $PG_MASTER_HOST/32 md5" >> "$PGDATA/pg_hba.conf"

cat > ${PGDATA}/recovery.conf <<EOF
standby_mode = on
primary_conninfo = 'host=$PG_MASTER_HOST port=${PG_MASTER_PORT:-5432} user=$PG_REP_USER password=$PG_REP_PASSWORD'
trigger_file = '/pgdata/data/failover.uygula'
restore_command = 'cp /data/ARCHIVELOG/%f %p'
archive_cleanup_command = '/usr/pgsql-9.5/bin/pg_archivecleanup /pgdata/ARCHIVELOG/%r'
EOF

chown postgres. ${PGDATA} -R
chmod 700 ${PGDATA} -R
fi

cat >> ${PGDATA}/postgresql.conf <<EOF
hot_standby = on
EOF

exec "$@"
