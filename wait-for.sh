#!/bin/sh
echo " Waiting for MySQL at $DB_HOST:$DB_PORT..."

until nc -z "$DB_HOST" "$DB_PORT"; do
  >&2 echo " MySQL is unavailable - sleeping"
  sleep 2
done

echo " MySQL is up - executing command"
exec "$@"
