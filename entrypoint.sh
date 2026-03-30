#!/bin/sh
set -e

# Wait for database to be ready (retries up to 30 seconds)
echo "Waiting for database..."
attempts=0
max_attempts=6
until bin/adam_journal eval "AdamJournal.Release.migrate()" 2>/dev/null; do
  attempts=$((attempts + 1))
  if [ $attempts -ge $max_attempts ]; then
    echo "Database not available after ${max_attempts} attempts, trying migration anyway..."
    bin/adam_journal eval "AdamJournal.Release.migrate()"
    break
  fi
  echo "Database not ready, retrying in 5s... (attempt $attempts/$max_attempts)"
  sleep 5
done
echo "Migrations complete."

echo "Running seeds..."
bin/adam_journal eval "AdamJournal.Release.seed()"
echo "Seeds complete."

echo "Starting server..."
exec bin/adam_journal start
