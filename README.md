# Mi TV Complete Transformation

A safe, reversible, approval-gated plan to modernise a **Xiaomi Mi TV (MITV-AXS00, Android TV 9, build PI.6681)**. It needs no root, no bootloader unlock, no custom firmware and no changes to system partitions.

## Your device (as reported from the TV's About screen)

| Field | Value |
|---|---|
| Model | MITV-AXS00 *(needs checking: Xiaomi IDs often use a letter **O** where you might read a zero, e.g. `AXSO0`)* |
| Android | 9 (API 28, Android TV "Pie") |
| Build | PI.6681 |
| Kernel | 4.9.113 (built 23 Mar 2022) |
| Security patch | 5 January 2022 |
| Build type | release-keys (stock, locked, not rooted) |

## How this repository is organised

| File | Purpose |
|---|---|
| [`docs/00-upgrade-plan.md`](docs/00-upgrade-plan.md) | **Start here.** The phased plan, with an approval gate before each phase |
| [`docs/01-device-analysis.md`](docs/01-device-analysis.md) | What your specs mean, the constraints and risks, and what still needs checking |
| [`docs/02-tv-only-guide.md`](docs/02-tv-only-guide.md) | Everything you can do with just the remote: ads, privacy, performance, notifications |
| [`docs/03-package-catalog.md`](docs/03-package-catalog.md) | Apps and packages sorted into SAFE, CAUTION and ESSENTIAL |
| [`docs/04-launcher-and-ui.md`](docs/04-launcher-and-ui.md) | Projectivy and other launchers, the Apple TV-inspired design spec, and how to install |
| [`docs/05-adb-workflow.md`](docs/05-adb-workflow.md) | The ADB workflow for later (computer **or** an Android phone running Termux) |
| [`docs/06-restore-and-recovery.md`](docs/06-restore-and-recovery.md) | How to undo every change, from small fixes up to a factory reset |
| [`docs/07-app-inventory.md`](docs/07-app-inventory.md) | **Your** system apps, sorted from your photos |
| `scripts/` | ADB scripts. They are dry-run by default, ask before every change and log everything |
| `lists/` | Package lists the scripts read, including a hard-coded list of essential packages that are never touched |

## Ground rules this project follows

1. **Nothing runs automatically.** Every script is dry-run by default and asks you about each package.
2. **Disable, don't uninstall.** Changes use `pm disable-user`, and `pm enable` reverses them.
3. **Back up first.** The debloat script won't run without a backup folder made by `01-backup.sh`.
4. **Check the device.** Every script checks the model, Android 9 and build PI.6681 first, and stops if anything doesn't match.
5. **Essential packages are blocked.** Google Play Services, the Play Store, Bluetooth (your remote), voice search, the system updater, TV inputs/HDMI and core Android are on a list the scripts refuse to touch.
6. **No unverified tweaks.** No RAM "boosters", no background-process limits, no build.prop edits.
