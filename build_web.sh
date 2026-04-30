#!/usr/bin/env bash
set -euo pipefail

flutter pub get
if flutter build web -h | grep -q -- '--web-renderer'; then
  flutter build web --release --web-renderer html
else
  flutter build web --release
fi
