#!/usr/bin/env bash
set -euo pipefail

# Usage: scripts/run-e2e.sh
# Requires Docker with compose plugin and Node.js.

docker compose up -d --build

# Give GeoNetwork extra time for initial setup/migrations.
sleep 30

GN_BASE_URL="${GN_BASE_URL:-http://127.0.0.1:8080}" npx playwright test
