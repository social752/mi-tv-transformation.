# Device Configuration Analysis

## 1. What the reported specs tell us

| Spec | Meaning | Effect on this plan |
|---|---|---|
| **Android 9 (Pie), Android TV** | API level 28. The Android TV launcher here is the "Android TV Home" (`com.google.android.tvlauncher`), not Google TV. | Any app or launcher must support API 28. **Google TV's home screen won't run on this firmware. Don't try to sideload it.** |
| **Build PI.6681** | The `PI.` prefix is how Xiaomi numbers its Pie-based TV firmware. Package names and Xiaomi settings menus differ between Xiaomi firmwares and regions. | We don't assume any Xiaomi package exists until we see it in **your** app list (Phase 0) or the ADB backup (Phase 6). |
| **Kernel 4.9.113, built Mar 2022** | A common kernel line for 2019–2021 TV chipsets (typically MediaTek or Amlogic). | Expect modest CPU/GPU and probably **1–2 GB of RAM**. A **lightweight** launcher and fewer background apps make the biggest difference. |
| **Security patch 5 Jan 2022** | Almost five years behind. The TV probably won't get more updates, but check anyway (Settings → Device Preferences → About → System update). | Install apps **only from the Play Store** or well-known developers. Avoid random APK sites. Don't install modified ("modded") APKs. |
| **release-keys** | A stock, signed, locked build. | No root. Everything goes through Settings or ADB with user-level rights (`pm disable-user`), which is reversible and never touches system partitions. |
| **Model MITV-AXS00** | Xiaomi's internal model code. The product name and screen size aren't in it. | **Must be checked.** In Xiaomi codes one character is often a letter **O** that looks like a zero (`AXSO0` vs `AXS00`). `scripts/config.sh` stores the expected value, and the verify script stops on any mismatch. |

## 2. What we still need to know (collected in Phase 0)

| Question | Why it matters |
|---|---|
| Exact model string (photo of About, and later `adb shell getprop ro.product.model`) | Script safety check |
| Does **Home** open **PatchWall** or **Android TV Home**? | Decides which ad sources we tackle and which launcher we replace |
| Region (India, EU, other) | Preinstalled partner apps and PatchWall features vary by region |
| RAM and free storage | Wallpaper and screensaver resolution, how much debloat matters |
| Remote: Bluetooth (mic button, paired) or IR only | Bluetooth remotes rely on `com.android.bluetooth` and Xiaomi pairing components, which are **essential** |
| Do you use HDMI inputs, an antenna/live TV, Chromecast or voice search? | Decides whether Live Channels, cast and Assistant components are ESSENTIAL for you |

## 3. Constraints (from your requirements, enforced by the scripts)

- No root, no bootloader unlock, no custom firmware, no system-partition changes
- No disabling of essential Xiaomi or Android services (hard-coded list: `lists/essential-denylist.txt`)
- Reversible actions only (`pm disable-user` ⇄ `pm enable`; `settings put` with the old value logged)
- Your approval before each change (scripts ask about each package, dry run is the default)

## 4. Risk register

| Risk | Likelihood | Impact | How we reduce it |
|---|---|---|---|
| Disabling a package breaks the Home button or setup | Low (with the list) | High | `setupwraith`, launchers and providers are on the essential/caution lists. Change one package at a time and run the smoke test |
| Remote stops working | Low | High | Bluetooth and remote-pairing packages are on the denylist. Keep an IR-capable remote or a phone app (Google TV / Android TV Remote) as backup |
| New launcher fails, so there's no home screen | Low | Medium | Phase 4 uses a reversible override. The stock launcher is disabled only in Phase 7 after testing, and can be re-enabled by ADB |
| Firmware update re-enables apps or resets settings | Medium | Low | Re-run the backup/compare after any update. Settings are easy to reapply |
| Streaming app refuses to run (DRM or Play Integrity) | Very low | High | We don't root or modify the system, so DRM (Widevine) and certification stay intact |
| Factory reset needed | Very low | High (logins lost) | Only as a last resort. All changes are user-level, and a reset fully restores the stock state |
| Apps drop Android 9 support over the years | Medium (long term) | Medium | Not fixable in software without new firmware. If it happens, a low-cost streaming stick is the only real fix (noted, not recommended now) |

## 5. Confirmed at Gate 0 (from your photos, 25 Nov 2026)

| Item | Finding | Effect |
|---|---|---|
| Model | About shows `MITV-AXSO0` / `MITV-AXS00`. The font doesn't distinguish **O** from **0**. The Netflix ESN on the same screen reads `...XIAOMMITV-AXSO0...` | Still unresolved. `scripts/00-verify-device.sh` reads the exact string and explains if only O/0 differ |
| Device codename | Netflix ESN contains **`DANGAL`** | Netflix certification is intact (the ESN is the Widevine/Netflix device identity). Never root or modify the system |
| Android / build / patch / kernel | 9 · `PI.6681 release-keys` · 5 Jan 2022 · 4.9.113 (23 Mar 2022) | Matches `scripts/config.sh` |
| Region | **India** (JioHotstar, Sony LIV, Indian content rows) | Partner apps to review: Sony LIV, JioHotstar, the "WallPaper" app, Xiaomi tile |
| Home screen | **Android TV Home (2024+ design)**: tabs *Search · For you · Shop · Apps*, rows "Top-selling movies", "Popular movies and TV shows", "Trending on Google" and **"Sponsored by JioHotstar"** | Ads come from **Google's** launcher (`com.google.android.tvlauncher`). PatchWall is installed (it has its own Device Preferences entry) but isn't the Home app. Some sponsored rows may not have an off switch, so **Phase 4 (new launcher) gives the biggest improvement** |
| Google Play Movies & TV | Banner: "Your personalised recommendations have moved to the Home" | Play Movies is being retired. **SAFE to disable** |
| Usage | **Casts from phone, uses HDMI** | Google Cast, screen mirroring, MiLink and the TV inputs are KEPT. Smoke test check 5 (HDMI) applies |
| Computer | **Laptop available** (from 25 Nov 2026) | ADB phases (6–8) are now possible |
| Remote | **No microphone** | Voice isn't used. `com.google.android.katniss` still stays ESSENTIAL, because it powers the Search tab. Smoke test check 3 changed to typed search |
| Settings entries | Device Preferences has **Picture**, **Sound**, **Power**, **Timer** and **PatchWall** | Xiaomi picture/sound/power components are ESSENTIAL (already covered by the denylist patterns) |

> Privacy tip: the **Netflix ESN** is a unique device identifier. Crop it out of any photos you post publicly.

## 6. Verdict

The device is a **good candidate** for a non-root transformation. The gains come mostly from (1) replacing the ad-serving launcher, (2) cutting background and autoplay activity, and (3) disabling unused preinstalled apps. All three are possible without root on Android TV 9.
