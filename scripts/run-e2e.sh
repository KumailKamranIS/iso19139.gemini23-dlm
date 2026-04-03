#!/usr/bin/env bash
set -euo pipefail

# Usage: scripts/run-e2e.sh
# Requires Docker with compose plugin.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

docker compose up -d --build

# Give GeoNetwork extra time for initial setup/migrations.
sleep 90

# Run script to test the schemas have loaded
"$SCRIPT_DIR/test-schemas.sh"

if [ $? -ne 0 ]; then
  echo "Schema validation failed"
  exit 1
fi

docker compose down -v
