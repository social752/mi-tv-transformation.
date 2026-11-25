# Safe, Step-by-Step Upgrade Plan

Every phase ends with an **approval gate**: tell me "approved, phase N" (or tell me what to change) before you start the next one. Inside a phase, do the steps in order and check the box when each one is done.

Phases 0–5 need **only the TV and its remote**. Phases 6–8 need ADB, from a computer **or** an Android phone running Termux (see `05-adb-workflow.md`).

```
TV-ONLY                                             ADB (later, optional)
P0 Inspect & record ─► P1 Privacy ─► P2 Ads & home ─► P3 Performance ─► P4 Launcher ─► P5 TV-only debloat
                                                                                              │
                                                     P8 Fine-tuning ◄─ P7 ADB debloat ◄─ P6 Verify + backup
```

---

## Phase 0 — Inspect and record (no changes)

**Goal:** a written "before" picture, so we can tell what changed and put everything back.

- [ ] 0.1 Take phone photos of: **Settings → Device Preferences → About** (every line, including Model and Build), **Storage**, and the **Home screen**.
- [ ] 0.2 **Settings → Apps → See all apps**: photograph the list. Then open **Show system apps** and photograph that list too, page by page. This is your **package inventory for TV-only mode**.
- [ ] 0.3 Write down which home screen appears when you press **Home**: PatchWall (Xiaomi), the Android TV home, or a choice prompt.
- [ ] 0.4 Note your **RAM / storage** if shown (About or Storage), your **region** (India, Europe, other) and your **remote type** (Bluetooth with microphone button, or IR only).
- [ ] 0.5 Make sure your Google account and streaming logins (Netflix, YouTube, Prime) work and you know their passwords. A factory reset, the last-resort fallback, would wipe them.

**Risk:** none (read-only).
**🔒 Gate 0:** send me the photos or notes from 0.1–0.4. I'll confirm the exact model string and build, and adjust the package catalog to *your* list.

---

## Phase 1 — Privacy (TV-only, fully reversible through the same menus)

Detailed steps: `02-tv-only-guide.md §A`.

- [ ] 1.1 Turn off Usage & diagnostics
- [ ] 1.2 Opt out of ads personalisation and reset the advertising ID
- [ ] 1.3 Turn off Location (and Wi-Fi scanning, if offered)
- [ ] 1.4 Review app permissions (microphone, location, storage)
- [ ] 1.5 Turn off Xiaomi or PatchWall "user experience" / personalised-ads switches if your firmware shows them
- [ ] 1.6 Google account privacy controls, done from your phone

**Risk:** very low. Streaming apps aren't affected. The Search bar on the home screen keeps working (your remote has no microphone, so voice isn't involved).
**🔒 Gate 1**

---

## Phase 2 — Fewer ads and a cleaner home screen (TV-only)

Detailed steps: `02-tv-only-guide.md §B`.

- [ ] 2.1 Android TV home: turn off unwanted channels and "Sponsored" rows, and switch off video and audio previews
- [ ] 2.2 PatchWall: turn off recommendation and promotion rows where the settings allow it
- [ ] 2.3 Turn off notifications for promotional apps
- [ ] 2.4 Uninstall partner/promo apps you never use. Only apps that offer **Uninstall** (not system apps)

**Risk:** low. Every switch can be turned back on.
**Expectation:** the launcher itself serves most home-screen ads. **Phase 4 (a new launcher) removes the most ads.** Ads *inside* apps like YouTube aren't controlled by the TV, and no safe setting removes them.
**🔒 Gate 2**

---

## Phase 3 — Performance (TV-only)

Detailed steps: `02-tv-only-guide.md §C`.

- [ ] 3.1 Turn on Developer options (tap Build 7 times)
- [ ] 3.2 Set the three animation scales to **0.5x** (the only animation tweak we use; it's standard and reversible)
- [ ] 3.3 Storage review: clear the **cache** (not data) of large apps and uninstall unused apps
- [ ] 3.4 Change the screensaver to a light one and turn off autoplaying previews (already done in 2.1)
- [ ] 3.5 Restart the TV fully: hold Power → Restart

**We will not:** install "RAM cleaner/booster" apps, set "Background process limit", or enable "Don't keep activities". These make Android TV *slower* and can break streaming apps.
**🔒 Gate 3**

---

## Phase 4 — Premium launcher (Apple TV-inspired)

Detailed steps: `04-launcher-and-ui.md`.

- [ ] 4.1 Install **Projectivy Launcher** from the Play Store on the TV. The Play Store checks compatibility with your device.
- [ ] 4.2 Build the layout: a dark wallpaper and a "Top Shelf" favourites row with Netflix, YouTube and Prime Video
- [ ] 4.3 Optional: the **Aerial Views** screensaver, for Apple TV-style aerial footage
- [ ] 4.4 Make Home open Projectivy, using its built-in "override" option (an accessibility service, no ADB needed)
- [ ] 4.5 Test for 2–3 days: Home button, Netflix/Prime buttons on the remote, typed search, HDMI inputs, power on/off

**Risk:** low. The old launcher isn't removed; turning off the override puts it back right away.
**🔒 Gate 4:** report how the 2–3 day test went before we take anything away.

---

## Phase 5 — TV-only debloat (Settings → Apps → Disable)

Detailed steps: `02-tv-only-guide.md §D` plus `03-package-catalog.md`.

- [ ] 5.1 Using the Phase 0 photos, mark each system app SAFE, CAUTION or ESSENTIAL (I'll do this with you)
- [ ] 5.2 Disable **one SAFE app at a time** through Settings → Apps → *app* → **Disable**, then test (5 checks: Home, remote, search, one streaming app, HDMI input)
- [ ] 5.3 Keep a written log: date, app name, what you tested, result
- [ ] 5.4 Don't touch CAUTION apps until we have ADB and a full backup

**Risk:** low to moderate. Each disable is reversed with Settings → Apps → Show system apps → *app* → **Enable**.
**🔒 Gate 5**

---

## Phase 6 — ADB: verify and back up (needs a computer or an Android phone)

- [ ] 6.1 Set up ADB (`05-adb-workflow.md`)
- [ ] 6.2 Run `scripts/00-verify-device.sh`. It confirms the model, Android 9 and PI.6681, or stops.
- [ ] 6.3 Run `scripts/01-backup.sh`. It saves every package, its state, settings and the current home app.
- [ ] 6.4 Send me `packages-system.txt` and `packages-disabled.txt` from the backup, and I'll write a device-specific `lists/xiaomi-safe.txt`

**Risk:** none (read-only).
**🔒 Gate 6**

---

## Phase 7 — ADB debloat (approved packages only)

- [ ] 7.1 Dry run first: `scripts/02-debloat.sh --list lists/google-safe.txt --backup <dir>`
- [ ] 7.2 Apply, answering **y/N for each package**: add `--apply`
- [ ] 7.3 Test after each batch. Undo with `scripts/03-restore.sh --undo-log <dir>`
- [ ] 7.4 CAUTION lists (for example, switching the launcher permanently) need you to type the package name to confirm

**🔒 Gate 7**

---

## Phase 8 — Fine-tuning (ADB, optional)

- [ ] 8.1 `scripts/04-tweaks.sh`: animation scales, and an optional ad-blocking Private DNS (only after you approve each one)
- [ ] 8.2 Final review: storage, RAM use, a startup-time check

**🔒 Gate 8: done.** Keep the backup folder somewhere safe (cloud drive or USB stick).

---

## The 5-point smoke test (run after **every** change)

1. **Home** button opens your launcher
2. **Remote** works: D-pad, Back, volume, the Netflix and Prime buttons
3. **Search**: the Search bar on the home screen (or inside YouTube) finds a title when you type it
4. **Streaming:** one minute of Netflix *or* YouTube plays with sound
5. **Inputs:** switching to an HDMI source works (if you use one)

If any check fails, undo the last change straight away. See `06-restore-and-recovery.md`.
