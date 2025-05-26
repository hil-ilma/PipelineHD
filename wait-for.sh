#!/bin/sh

# wait-for.sh host:port -- command
# Example: ./wait-for.sh test-mysql:3306 -- npm test

HOSTPORT=$1
shift
CMD="$@"

HOST=$(echo "$HOSTPORT" | cut -d: -f1)
PORT=$(echo "$HOSTPORT" | cut -d: -f2)

echo "⏳ Waiting for $HOST:$PORT to be available..."

while ! nc -z "$HOST" "$PORT"; do
  sleep 1
done

echo "✅ $HOST:$PORT is available. Running command..."
exec $CMD
