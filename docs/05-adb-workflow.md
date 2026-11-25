# ADB Workflow (laptop, or Android phone with Termux)

ADB ("Android Debug Bridge") lets us do reversible, user-level changes that the TV's menus don't offer. It **doesn't** root the TV or change system partitions.

## 1. Options

| Option | What you need | Notes |
|---|---|---|
| **A. Android phone + Termux** | Any Android phone on the same Wi-Fi | Install **Termux from F-Droid** (the Play Store version is outdated), then `pkg install android-tools git`. The scripts here run unchanged. **This works with no computer at all.** |
| B. Windows PC | Google "SDK Platform-Tools" plus **Git Bash** or WSL | Run the scripts from Git Bash |
| C. macOS / Linux | `brew install android-platform-tools` / `apt install adb` | Native |

## 2. Laptop setup (one time)

### Windows (most common)
1. **ADB:** download *SDK Platform-Tools for Windows* from Google's Android developer site (developer.android.com → "platform-tools"). Extract the ZIP to `C:\platform-tools`.
2. **Git Bash:** install *Git for Windows* (git-scm.com). It includes **Git Bash**, which runs these scripts unchanged.
3. Open **Git Bash** and check that adb works:
   ```bash
   export PATH="$PATH:/c/platform-tools"
   adb version
   ```
   (Add that `export` line to `~/.bashrc` so you don't have to type it every time.)

### macOS
`brew install android-platform-tools git`, then use the Terminal app.

### Linux
`sudo apt install adb git` (or your distro's equivalent).

## 3. Turn on debugging on the TV

1. Developer options must be on: ⚙ → Device Preferences → About → highlight **Build** → press OK **7 times**
2. ⚙ → Device Preferences → **Developer options** → **USB debugging: On**. If there's **Network debugging / ADB over network**, turn that on too.
3. Find the TV's IP address: ⚙ → Network & Internet → *your Wi-Fi network* (for example `192.168.1.50`)
4. The laptop must be on the **same Wi-Fi** as the TV

## 4. Connect

```bash
adb connect 192.168.1.50:5555      # use YOUR TV's IP
adb devices                        # should show: 192.168.1.50:5555   device
```
The TV shows **"Allow USB debugging?"**. Tick *Always allow from this computer* → **OK**.
- `unauthorized` → accept the prompt on the TV, then run `adb devices` again
- `connection refused` / `failed to connect` → your firmware may need a "Network debugging" toggle, or USB debugging may have switched itself off. Restart the TV, check the toggle, and tell me the exact message
- Windows Firewall may ask about `adb.exe` → allow it on **private** networks

## 5. Get the scripts

The repository is private to your GitHub account. Use either option:

**Option A: download a ZIP (simplest).** Log in to GitHub in your browser → open the repository → switch the branch selector to `claude/xiaomi-mi-tv-modernize-9lvtnq` → **Code → Download ZIP** → extract it, for example to your Desktop. In Git Bash: `cd ~/Desktop/<extracted-folder>`

**Option B: git clone**
```bash
git clone -b claude/xiaomi-mi-tv-modernize-9lvtnq https://github.com/social752/mi-tv-transformation. mi-tv
cd mi-tv
```

Then, in the same Git Bash window:
```bash
export ANDROID_SERIAL=192.168.1.50:5555     # YOUR TV's IP; makes every script target the TV
```

## 6. Run order (each script asks before changing anything)

| Step | Command | Changes the TV? |
|---|---|---|
| 1 | `bash scripts/00-verify-device.sh` | No. Stops unless the model, Android 9 and PI.6681 match `scripts/config.sh` |
| 2 | `bash scripts/01-backup.sh` | No. Writes `backups/<serial>-<timestamp>/` |
| 3 | `bash scripts/02-debloat.sh --list lists/google-safe.txt --backup backups/<dir>` | No (dry run) |
| 4 | the same command with `--apply` | **Yes.** Asks y/N for every package and logs to `<dir>/changes.log` |
| 5 | `bash scripts/04-tweaks.sh --backup backups/<dir>` and add `--apply` | **Yes.** Animation scales, optional Private DNS. Asks about each one |
| Undo | `bash scripts/03-restore.sh --undo-log backups/<dir>` | **Yes.** Reverses everything in `changes.log`, newest first |

## 7. Manual equivalents (for reference)

```bash
adb shell pm list packages -s                 # system packages
adb shell pm list packages -d                 # currently disabled
adb shell pm disable-user --user 0 <pkg>      # disable (reversible)
adb shell pm enable <pkg>                     # re-enable
adb shell cmd package install-existing <pkg>  # restore a package removed with "pm uninstall --user 0"
adb shell settings get global window_animation_scale
```
**We never use** `pm uninstall` (without `-k --user 0`), `rm`, `su`, `fastboot` or anything touching `/system`.

## 8. Optional: ad-blocking Private DNS (CAUTION, Phase 8)

Android 9 supports Private DNS, but the Android TV Settings app doesn't show it, so it's set via ADB:
```bash
adb shell settings put global private_dns_mode hostname
adb shell settings put global private_dns_specifier dns.adguard-dns.com
# undo:
adb shell settings put global private_dns_mode opportunistic
```
**What it does:** blocks many ad and tracking domains for the whole TV, including some launcher and partner-app ads.
**What it doesn't do:** remove YouTube or Prime in-video ads (they come from the same servers as the video).
**Risk:** an app may fail to load if a domain it needs gets blocked. If something stops working, undo it with the command above. `04-tweaks.sh` logs the previous value so restore puts it back.
