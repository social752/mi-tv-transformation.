# shellcheck shell=bash
# Shared helpers. Sourced by the other scripts; not meant to be run directly.

set -euo pipefail
export LC_ALL=C   # stable sort/comm ordering across Linux, macOS and Termux

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
# shellcheck source=config.sh
source "$SCRIPT_DIR/config.sh"

DENYLIST_FILE="$REPO_DIR/lists/essential-denylist.txt"

die()  { echo "ERROR: $*" >&2; exit 1; }
info() { echo "==> $*"; }

# Run a shell command on the TV and strip Windows-style CRs.
# stdin is /dev/null so adb never swallows the input of a surrounding `while read` loop.
tv() { adb shell "$@" </dev/null | tr -d '\r'; }

require_adb() {
  command -v adb >/dev/null 2>&1 || die "adb not found. See docs/05-adb-workflow.md"
  local n
  n=$(adb devices | awk 'NR>1 && $2=="device"' | wc -l | tr -d ' ')
  if [[ -z "${ANDROID_SERIAL:-}" && "$n" != "1" ]]; then
    die "Expected exactly one connected device (found $n). Set ANDROID_SERIAL=<ip>:5555."
  fi
  adb get-state >/dev/null 2>&1 || die "Device not reachable or unauthorized. Accept the prompt on the TV."
}

# Verify model, Android version and build. Exits on any mismatch.
verify_device() {
  local model release sdk display buildid incr fp
  model=$(tv getprop ro.product.model)
  release=$(tv getprop ro.build.version.release)
  sdk=$(tv getprop ro.build.version.sdk)
  display=$(tv getprop ro.build.display.id)
  buildid=$(tv getprop ro.build.id)
  incr=$(tv getprop ro.build.version.incremental)
  fp=$(tv getprop ro.build.fingerprint)

  echo "  ro.product.model            = $model"
  echo "  ro.product.device           = $(tv getprop ro.product.device)"
  echo "  ro.product.manufacturer     = $(tv getprop ro.product.manufacturer)"
  echo "  ro.build.version.release    = $release (sdk $sdk)"
  echo "  ro.build.display.id         = $display"
  echo "  ro.build.id                 = $buildid"
  echo "  ro.build.version.incremental= $incr"
  echo "  ro.build.fingerprint        = $fp"
  echo "  ro.build.version.security_patch = $(tv getprop ro.build.version.security_patch)"

  local ok=1
  if [[ "$model" != "$EXPECTED_MODEL" ]]; then
    ok=0
    echo "MISMATCH: model '$model' != expected '$EXPECTED_MODEL'"
    if [[ "${model//O/0}" == "${EXPECTED_MODEL//O/0}" ]]; then
      echo "  Note: these differ only by letter 'O' vs digit '0'. Confirm on the TV's About"
      echo "  screen, then set EXPECTED_MODEL=\"$model\" in scripts/config.sh."
    fi
  fi
  [[ "$release" == "$EXPECTED_ANDROID_RELEASE" ]] || { ok=0; echo "MISMATCH: Android $release != $EXPECTED_ANDROID_RELEASE"; }
  [[ "$sdk" == "$EXPECTED_SDK" ]] || { ok=0; echo "MISMATCH: SDK $sdk != $EXPECTED_SDK"; }
  if [[ "$display $buildid $incr $fp" != *"$EXPECTED_BUILD_TOKEN"* ]]; then
    ok=0
    echo "MISMATCH: build token '$EXPECTED_BUILD_TOKEN' not found in display id / build id / incremental / fingerprint."
    echo "  Send the values above for review before changing config.sh."
  fi
  [[ $ok == 1 ]] || die "Device verification failed. Nothing was changed."
  info "Device verified: $model, Android $release, build contains $EXPECTED_BUILD_TOKEN"
}

# Returns 0 if the package is protected (exact name or regex line prefixed with 're:').
is_denied() {
  local pkg="$1" line
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%#*}"; line="$(echo "$line" | tr -d '[:space:]')"
    [[ -z "$line" ]] && continue
    if [[ "$line" == re:* ]]; then
      [[ "$pkg" =~ ${line#re:} ]] && return 0
    elif [[ "$pkg" == "$line" ]]; then
      return 0
    fi
  done < "$DENYLIST_FILE"
  return 1
}

# Capture output first: grep -q exiting early would trip pipefail via SIGPIPE.
is_installed() { local out; out=$(tv pm list packages);    grep -qx "package:$1" <<<"$out"; }
is_disabled()  { local out; out=$(tv pm list packages -d); grep -qx "package:$1" <<<"$out"; }

require_backup_dir() {
  local d="$1"
  [[ -n "$d" && -d "$d" && -f "$d/packages-all.txt" ]] \
    || die "Backup folder '$d' missing or incomplete. Run scripts/01-backup.sh first."
}

log_change() { # backup_dir, tab-separated fields...
  local d="$1"; shift
  printf '%s\t%s\n' "$(date '+%Y-%m-%dT%H:%M:%S')" "$(IFS=$'\t'; echo "$*")" >> "$d/changes.log"
}
