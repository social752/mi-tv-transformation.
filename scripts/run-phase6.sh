#!/usr/bin/env bash
# Phase 6 in one command. READ-ONLY: connects to the TV, verifies it, backs it up,
# and writes one summary file to send to Claude. Nothing on the TV is changed.
#
#   bash scripts/run-phase6.sh <TV-IP>        e.g.  bash scripts/run-phase6.sh 192.168.1.50
set -euo pipefail

ip="${1:-}"
if [[ -z "$ip" ]]; then
  echo "Usage: bash scripts/run-phase6.sh <TV-IP>   (find it on the TV: Settings > Network & Internet > your Wi-Fi)"
  exit 1
fi
here="$(cd "$(dirname "$0")" && pwd)"

# Find adb, including the usual Windows place for platform-tools.
for d in /c/platform-tools "$HOME/platform-tools" "$HOME/Desktop/platform-tools" "$HOME/Downloads/platform-tools"; do
  if [[ -e "$d/adb" || -e "$d/adb.exe" ]]; then PATH="$PATH:$d"; fi
done
if ! command -v adb >/dev/null 2>&1; then
  echo "adb not found. Extract Google's SDK Platform-Tools to C:\\platform-tools (see docs/05-adb-workflow.md)."
  exit 1
fi

target="$ip"; [[ "$target" == *:* ]] || target="$ip:5555"
export ANDROID_SERIAL="$target"

echo "==> Connecting to the TV at $target"
adb connect "$target" || true
state=""
for _ in $(seq 1 45); do
  state=$(adb devices | tr -d '\r' | awk -v t="$target" '$1==t {print $2}')
  [[ "$state" == device ]] && break
  if [[ "$state" == unauthorized ]]; then
    echo "   On the TV: tick 'Always allow from this computer' and press OK..."
  else
    echo "   Waiting for the TV (status: ${state:-not connected})..."
    adb connect "$target" >/dev/null 2>&1 || true
  fi
  sleep 2
done
if [[ "$state" != device ]]; then
  echo
  echo "Could not connect. Check: USB debugging is On, the IP is correct, and the laptop is on the same Wi-Fi."
  echo "Nothing was changed. Send Claude the messages above."
  exit 1
fi
echo "==> Connected."
echo

run_verify() { bash "$here/00-verify-device.sh" 2>&1; }

if ! verify_out=$(run_verify); then
  echo "$verify_out"
  if grep -q "differ only by letter" <<<"$verify_out"; then
    model=$(adb shell getprop ro.product.model </dev/null | tr -d '\r')
    [[ "$model" =~ ^[A-Za-z0-9._-]+$ ]] || { echo "Unexpected model string. Nothing was changed."; exit 1; }
    echo
    read -r -p "The TV reports model '$model'. Does Settings > About show this model? (O and 0 look alike) [y/N] " a </dev/tty
    if [[ "$a" == y || "$a" == Y ]]; then
      sed "s/^EXPECTED_MODEL=.*/EXPECTED_MODEL=\"$model\"/" "$here/config.sh" > "$here/config.sh.tmp"
      mv "$here/config.sh.tmp" "$here/config.sh"
      echo "Saved EXPECTED_MODEL=\"$model\" in scripts/config.sh"
      verify_out=$(run_verify) || { echo "$verify_out"; echo "Verification still failed. Nothing was changed."; exit 1; }
    else
      echo "Stopped. Nothing was changed."; exit 1
    fi
  else
    echo
    echo "Verification stopped the process. Nothing was changed. Send Claude the lines above."
    exit 1
  fi
fi
echo "$verify_out"
echo

bash "$here/01-backup.sh"

dir=$(ls -dt "$here/../backups"/*/ | head -n 1); dir="$(cd "$dir" && pwd)"
summary="$dir/share-with-claude.txt"
{
  echo "### verify"; echo "$verify_out"
  for f in home-activity packages-system packages-third-party packages-disabled; do
    echo; echo "### $f"; cat "$dir/$f.txt"
  done
} > "$summary"

echo
echo "============================================================"
echo " PHASE 6 DONE. Nothing on the TV was changed."
echo " Send Claude this ONE file (it contains no serial number):"
echo "   $summary"
echo " Keep the whole backup folder safe (Google Drive or a USB stick):"
echo "   $dir"
echo "============================================================"
