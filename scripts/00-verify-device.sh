#!/usr/bin/env bash
# Read-only: confirms the connected TV is the expected model / Android 9 / PI.6681.
source "$(dirname "$0")/lib.sh"

require_adb
info "Reading device properties (read-only)..."
verify_device
info "OK. Next step: bash scripts/01-backup.sh"
