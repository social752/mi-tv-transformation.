#!/usr/bin/env bash
# Disables packages from a list, one at a time, with explicit approval for each.
# Dry run unless --apply is given. Uses only `pm disable-user --user 0` (reversible).
#
#   bash scripts/02-debloat.sh --list lists/google-safe.txt --backup backups/<dir> [--apply]
source "$(dirname "$0")/lib.sh"

list="" backup="" apply=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --list)   list="$2"; shift 2 ;;
    --backup) backup="$2"; shift 2 ;;
    --apply)  apply=1; shift ;;
    *) die "Unknown argument: $1" ;;
  esac
done
[[ -f "$list" ]] || die "Use --list <file>"
require_backup_dir "$backup"
require_adb
verify_device

level=SAFE
grep -qi '^# *LEVEL: *CAUTION' "$list" && level=CAUTION
info "List: $list  (level: $level)  Mode: $([[ $apply == 1 ]] && echo APPLY || echo DRY-RUN)"
[[ $level == CAUTION ]] && echo "CAUTION list: you will be asked to type each package name to confirm."
echo

changed=0
while IFS= read -r raw || [[ -n "$raw" ]]; do
  pkg="${raw%%#*}"; pkg="$(echo "$pkg" | tr -d '[:space:]')"
  [[ -z "$pkg" ]] && continue
  note="$(echo "$raw" | sed -n 's/^[^#]*#[[:space:]]*//p')"

  if is_denied "$pkg"; then echo "BLOCKED  $pkg  (essential denylist, never changed)"; continue; fi
  if ! is_installed "$pkg"; then echo "absent   $pkg"; continue; fi
  if is_disabled "$pkg"; then echo "already  $pkg  (already disabled)"; continue; fi

  echo "CANDIDATE $pkg  ${note:+-- $note}"
  [[ $apply == 1 ]] || continue

  if [[ $level == CAUTION ]]; then
    read -r -p "  Type the package name to disable it, or press Enter to skip: " ans </dev/tty
    [[ "$ans" == "$pkg" ]] || { echo "  skipped"; continue; }
  else
    read -r -p "  Disable $pkg? [y/N/q] " ans </dev/tty
    [[ "$ans" == q ]] && { echo "Stopped by user."; break; }
    [[ "$ans" == y || "$ans" == Y ]] || { echo "  skipped"; continue; }
  fi

  if res=$(tv pm disable-user --user 0 "$pkg" 2>&1) && is_disabled "$pkg"; then
    log_change "$backup" disable "$pkg" enabled
    echo "  disabled ($res)"
    changed=$((changed+1))
  else
    echo "  FAILED / refused by system: $res"
  fi
done < "$list"

echo
info "$changed package(s) disabled. Logged in $backup/changes.log"
[[ $changed -gt 0 ]] && echo "Now run the 5-point smoke test (docs/00-upgrade-plan.md). Undo: bash scripts/03-restore.sh --undo-log $backup"
exit 0
