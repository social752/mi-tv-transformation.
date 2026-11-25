#!/usr/bin/env bash
# Read-only: records packages, package states and settings into backups/<serial>-<timestamp>/.
source "$(dirname "$0")/lib.sh"

require_adb
verify_device

serial=$(adb get-serialno | tr -d '\r' | tr ':/' '__')
out="$REPO_DIR/backups/${serial}-$(date '+%Y%m%d-%H%M%S')"
mkdir -p "$out"
info "Writing backup to $out"

tv getprop                                > "$out/getprop.txt"
tv pm list packages -f                    > "$out/packages-all-with-paths.txt"
tv pm list packages      | sort           > "$out/packages-all.txt"
tv pm list packages -u   | sort           > "$out/packages-including-uninstalled.txt"
tv pm list packages -s   | sort           > "$out/packages-system.txt"
tv pm list packages -3   | sort           > "$out/packages-third-party.txt"
tv pm list packages -e   | sort           > "$out/packages-enabled.txt"
tv pm list packages -d   | sort           > "$out/packages-disabled.txt"
tv pm list packages -i   | sort           > "$out/packages-installer.txt"
tv settings list global                   > "$out/settings-global.txt"
tv settings list secure                   > "$out/settings-secure.txt"
tv settings list system                   > "$out/settings-system.txt"
tv cmd package resolve-activity --brief -a android.intent.action.MAIN \
   -c android.intent.category.HOME        > "$out/home-activity.txt" 2>&1 || true
tv dumpsys meminfo -c 2>/dev/null | head -n 200 > "$out/meminfo.txt" || true
tv dumpsys diskstats 2>/dev/null          > "$out/diskstats.txt" || true
tv df -h 2>/dev/null                      > "$out/df.txt" || true

# Machine-readable original state: package<TAB>enabled|disabled<TAB>system|user
{
  while IFS= read -r l; do
    p="${l#package:}"
    st=enabled;  grep -qx "package:$p" "$out/packages-disabled.txt" && st=disabled
    ty=user;     grep -qx "package:$p" "$out/packages-system.txt"   && ty=system
    printf '%s\t%s\t%s\n' "$p" "$st" "$ty"
  done < "$out/packages-all.txt"
} > "$out/package-states.tsv"

: > "$out/changes.log"
( cd "$out" && (sha256sum ./*.txt ./*.tsv 2>/dev/null || shasum -a 256 ./*.txt ./*.tsv) > SHA256SUMS )

info "Backup complete: $(wc -l < "$out/packages-all.txt" | tr -d ' ') packages," \
     "$(wc -l < "$out/packages-disabled.txt" | tr -d ' ') already disabled."
info "Home app: $(tail -n 1 "$out/home-activity.txt")"
echo
echo "Keep this folder safe (copy it to cloud storage or a USB stick):"
echo "  $out"
echo "Share packages-system.txt and packages-disabled.txt for the device-specific review."
