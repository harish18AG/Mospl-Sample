#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT_DIR="${1:-$ROOT_DIR/export}"
ZIP_NAME="MOSPL_complete_project.zip"
ZIP_PATH="$OUTPUT_DIR/$ZIP_NAME"

mkdir -p "$OUTPUT_DIR"
rm -f "$ZIP_PATH"

cd "$ROOT_DIR"

zip -r "$ZIP_PATH" . \
  -x '.git/*' \
  -x 'node_modules/*' \
  -x 'backend/node_modules/*' \
  -x 'export/*' \
  -x 'final/*.zip' \
  -x '.dart_tool/*' \
  -x 'build/*'

zip -T "$ZIP_PATH"
sha256sum "$ZIP_PATH"
stat -c '%n %s bytes' "$ZIP_PATH"
