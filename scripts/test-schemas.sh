#!/usr/bin/env bash

BASE="http://localhost:8081/geonetwork"
USER="admin"
PASS="admin"

EXPECTED_SCHEMAS=(
  "iso19139.gemini23"
  "iso19139.gemini23-dlm"
)

SCHEMAS=$(curl -s \
-u "$USER:$PASS" \
-H "X-XSRF-TOKEN: test" \
"$BASE/srv/eng/info?type=schemas")

FAIL=0

for schema in "${EXPECTED_SCHEMAS[@]}"; do
  if echo "$SCHEMAS" | grep -q "$schema"; then
    echo "PASS: $schema loaded"
  else
    echo "FAIL: $schema missing"
    FAIL=1
  fi
done

exit $FAIL
