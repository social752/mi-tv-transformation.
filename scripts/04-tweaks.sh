#!/usr/bin/env bash
# Verified, reversible settings tweaks. Each asks for approval; old values are logged.
#   bash scripts/04-tweaks.sh --backup backups/<dir> [--apply]
source "$(dirname "$0")/lib.sh"

backup="" apply=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --backup) backup="$2"; shift 2 ;;
    --apply)  apply=1; shift ;;
    *) die "Unknown argument: $1" ;;
  esac
done
require_backup_dir "$backup"
require_adb
verify_device

set_setting() { # namespace key new_value description
  local ns="$1" key="$2" new="$3" desc="$4" old
  old=$(tv settings get "$ns" "$key")
  echo "$desc: $ns/$key  current=$old  proposed=$new"
  [[ "$old" == "$new" ]] && { echo "  already set"; return; }
  [[ $apply == 1 ]] || return 0
  read -r -p "  Apply? [y/N] " a </dev/tty
  [[ "$a" == y || "$a" == Y ]] || { echo "  skipped"; return; }
  tv settings put "$ns" "$key" "$new"
  log_change "$backup" setting "$ns" "$key" "$old"
  echo "  applied (old value logged)"
}

echo "== Animations (standard, reversible) =="
set_setting global window_animation_scale     0.5 "Window animation"
set_setting global transition_animation_scale 0.5 "Transition animation"
set_setting global animator_duration_scale    0.5 "Animator duration"

echo
echo "== Optional: ad/tracker-blocking Private DNS (CAUTION, see docs/05-adb-workflow.md §7) =="
set_setting global private_dns_mode      hostname            "Private DNS mode"
set_setting global private_dns_specifier dns.adguard-dns.com "Private DNS server"

echo
[[ $apply == 1 ]] || echo "Dry run only. Re-run with --apply to be asked about each change."
