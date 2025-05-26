#!/bin/sh

HOST="$1"
PORT="$2"

echo "⏳ Waiting for $HOST:$PORT to be ready..."

while ! nc -z "$HOST" "$PORT"; do
  sleep 1
done

# Additional check: wait for MySQL init
echo "⏳ Waiting for MySQL server to respond to ping..."

until mysqladmin ping -h "$HOST" --silent; do
  sleep 1
done

echo "✅ $HOST:$PORT is ready!"
exec "${@:3}"
