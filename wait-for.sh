#!/bin/sh
host="$1"
shift

echo "⏳ Waiting for $host to be ready..."
until nc -z $host 3306; do
  sleep 1
done

# Additional check: wait for MySQL init
echo "⏳ Waiting for MySQL to accept connections..."
until mysqladmin ping -h "$host" --silent; do
  sleep 1
done

echo "✅ $host is up!"
exec "$@"
