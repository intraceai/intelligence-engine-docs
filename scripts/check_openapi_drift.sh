#!/usr/bin/env bash
set -euo pipefail

DOCS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
API_DIR="${API_DIR:-$(cd "$DOCS_DIR/../intelligence-api" && pwd)}"
TMP_FILE="$(mktemp)"
trap 'rm -f "$TMP_FILE"' EXIT

cd "$API_DIR"
uv run python scripts/export_openapi.py --output "$TMP_FILE"

if ! cmp -s "$TMP_FILE" "$DOCS_DIR/openapi.yaml"; then
  echo "openapi.yaml is out of sync with intelligence-api." >&2
  echo "Refresh it with:" >&2
  echo "  cd $API_DIR" >&2
  echo "  uv run python scripts/export_openapi.py --output $DOCS_DIR/openapi.yaml" >&2
  exit 1
fi

echo "openapi.yaml is in sync with intelligence-api."
