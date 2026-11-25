# Restore and Recovery

Work down this list only as far as you need to.

## Level 1 — Undo one setting (TV-only)
Go back to the same menu and switch it back. Every Phase 1–4 change is a toggle. See the "Undo" column in `02-tv-only-guide.md`.

## Level 2 — Re-enable a disabled app (TV-only)
Settings → Apps → See all apps → **Show system apps** → scroll to the app (disabled apps are often listed at the end) → **Enable**.

## Level 3 — Get your old home screen back (TV-only)
- Settings → Device Preferences → **Accessibility** → Projectivy → **Off**, or
- Settings → Apps → Projectivy → **Uninstall**.
If **Home shows nothing** (only possible after the Phase 7 ADB launcher switch): use the remote's **Settings** button or the Netflix button to reach a working screen, and follow Level 4.

## Level 4 — Undo with ADB
```bash
export ANDROID_SERIAL=<tv-ip>:5555
bash scripts/03-restore.sh --undo-log backups/<dir>      # reverse every logged change, newest first
bash scripts/03-restore.sh --package <pkg>               # re-enable one package
bash scripts/03-restore.sh --compare backups/<dir>       # show (and offer to fix) anything disabled now that was enabled in the backup
```

## Level 5 — Factory reset (last resort)
Settings → Device Preferences → **Reset**. This wipes apps, logins and settings and puts back the exact factory state, because we never touched the system partition.
**Before you do it:** make sure you know your Google, Netflix, Prime and Wi-Fi passwords. Keep your `backups/` folder; re-running the plan afterwards takes about 30 minutes.

## Firmware updates
A Xiaomi OTA update can re-enable apps or reset settings. After any update:
1. Run `scripts/01-backup.sh` again (a new folder)
2. Run `scripts/03-restore.sh --compare <old-backup>` to see what changed
3. Re-apply only what you still want, with approval as before
