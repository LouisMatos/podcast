#!/usr/bin/env bash
#
# Codegen do build_runner (freezed, json_serializable, riverpod, drift).
#
# Uso:
#   ./scripts/gen.sh          # gera uma vez
#   ./scripts/gen.sh watch    # fica observando e regenerando
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$(dirname "$SCRIPT_DIR")"

MODE="${1:-build}"

flutter pub get
exec dart run build_runner "$MODE" --delete-conflicting-outputs
