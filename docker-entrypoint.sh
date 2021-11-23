#!/bin/ash

set -e

echo "-- Waiting for database..."
while ! pg_isready -U ${DB_USER:-example} -d postgres://${DB_HOST:-example-db}:5432/${DB_NAME:-example} -t 1; do
    sleep 1s
done

#echo "-- Running migrations..."
$HOME/bin/migrate.sh

echo "-- Starting!"
exec $HOME/bin/example start
