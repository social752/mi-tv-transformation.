#!/usr/bin/env bash
# Restores changes. Asks before acting.
#   --undo-log <backup_dir>   reverse every entry in changes.log, newest first
#   --package <pkg>           re-enable a single package
#   --compare <backup_dir>    list packages that differ from the backup and offer to restore them
source "$(dirname "$0")/lib.sh"

mode="${1:-}"; arg="${2:-}"
[[ -n "$mode" && -n "$arg" ]] || die "Usage: --undo-log <dir> | --package <pkg> | --compare <dir>"
require_adb
verify_device

confirm() { read -r -p "$1 [y/N] " a </dev/tty; [[ "$a" == y || "$a" == Y ]]; }

enable_pkg() {
  local p="$1"
  if ! is_installed "$p"; then
    tv cmd package install-existing "$p" || true
  fi
  tv pm enable "$p"
}

case "$mode" in
  --package)
    confirm "Re-enable $arg?" && enable_pkg "$arg"
    ;;

  --undo-log)
    require_backup_dir "$arg"
    log="$arg/changes.log"
    [[ -s "$log" ]] || die "No changes recorded in $log"
    echo "Changes to reverse (newest first):"
    tac "$log" 2>/dev/null || tail -r "$log"
    confirm "Reverse all of the above?" || exit 0
    (tac "$log" 2>/dev/null || tail -r "$log") | while IFS=$'\t' read -r ts action a b c; do
      case "$action" in
        disable) echo "enable  $a"; enable_pkg "$a" ;;
        setting) # a=namespace b=key c=old value ("null" = was unset)
          if [[ "$c" == "null" ]]; then tv settings delete "$a" "$b"; else tv settings put "$a" "$b" "$c"; fi
          echo "setting $a $b -> $c" ;;
      esac
    done
    mv "$log" "$log.reverted-$(date '+%Y%m%d-%H%M%S')"; : > "$log"
    info "Done. Run the smoke test."
    ;;

  --compare)
    require_backup_dir "$arg"
    cur_dis=$(tv pm list packages -d | sort)
    cur_all=$(tv pm list packages | sort)
    newly_disabled=$(comm -23 <(echo "$cur_dis") "$arg/packages-disabled.txt" | sed 's/^package://')
    missing=$(comm -13 <(echo "$cur_all") "$arg/packages-all.txt" | sed 's/^package://')
    echo "Disabled now but enabled in backup:"; echo "${newly_disabled:-  (none)}"
    echo "Present in backup but missing now:";  echo "${missing:-  (none)}"
    if [[ -n "$newly_disabled$missing" ]] && confirm "Restore all of these to the backup state?"; then
      printf '%s\n%s\n' "$newly_disabled" "$missing" | while read -r p; do
        [[ -n "$p" ]] && { echo "restore $p"; enable_pkg "$p"; }
      done
    fi
    ;;

  *) die "Unknown mode $mode" ;;
esac
