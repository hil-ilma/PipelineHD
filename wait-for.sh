#!/bin/sh

echo "⏳ Waiting for MySQL at db:3306..."
# Loop until MySQL is ready
while ! nc -z db 3306; do
  sleep 2
done

echo "✅ MySQL is up! Running tests..."
npm test
