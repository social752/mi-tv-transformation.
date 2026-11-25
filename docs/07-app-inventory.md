# Your App Inventory: Classified (from Gate 0 photos, 25 Nov 2026)

Source: 14 photos of Settings → Apps → System apps. The labels are as shown on your TV. Package names are confirmed later from the ADB backup.
**Chipset:** the `com.droidlogic.*` / "Droid…" apps show that this TV uses an **Amlogic** SoC. All of them are platform components and are ESSENTIAL.
**Your usage (confirmed):** you **cast** from your phone, you **use HDMI**, the remote has no microphone, region India.

## ✅ SAFE: disable from the TV (Phase 5, one at a time, after approval)

| App (label) | Size | What it is | How |
|---|---|---|---|
| discovery+ | 49.8 MB | Partner streaming app | **Uninstall** if offered, otherwise Disable |
| BugReportSender | 1.9 MB | Sends bug reports (telemetry) | Disable |
| Market Feedback Agent | 94 kB | Play Store feedback reporting | Disable |
| Mi TV Video Player | 55 MB | Xiaomi local video player | Disable (install VLC if you play USB videos) |
| Music Player | 291 kB | Local music player | Disable |
| Gallery | 2.3 MB | Local photo viewer | Disable (if you don't view USB photos) |
| Print Spooler | 1.2 MB | Printing (not used on a TV) | Disable |
| Backdrop | 110 MB | Ambient-mode screensaver | Disable **after** Aerial Views is installed (Phase 4) |

## ⚠️ CAUTION: test individually, ideally after an ADB backup

| App (label) | What it is | Condition |
|---|---|---|
| **Analytics** (16.7 MB) | Usage analytics / telemetry | Privacy win. Try Disable. If greyed out, wait for ADB |
| **com.xiaomi.statistic.App** | Xiaomi usage statistics (telemetry) | Same as above |
| MiTvShowTime | Xiaomi screensaver/showcase component | Check what it does before deciding |
| PatchWall Update Service (88.7 MB) | Keeps PatchWall updated (not the TV's firmware updater) | Only after Projectivy is your home. The scripts block it by default because its name contains "update" |
| PumpkinService / Speech Recognition and Synthesis | Offline speech and text-to-speech | No mic means low use, but the space saved is small. Leave for now |
| TV lock | Parental lock | Disable only if you never use parental PINs |
| Android TV Home (99 MB) | Current launcher (source of the sponsored rows) | Phase 7, only after Projectivy has been tested |

## 📡 KEEP: you cast and use HDMI

| App (label) | Why it stays |
|---|---|
| **Google Cast** (114 MB) | Chromecast built-in: casting from the YouTube/Netflix/Prime apps on your phone |
| **WfdSinkHelperService** | Screen mirroring (Miracast) receiver |
| **MiLink** | Xiaomi phone-to-TV casting. Revisit only after we confirm which casting method you use |
| **TV** tile / DroidLiveTv / DroidLogicTvInput | HDMI input switching |

## ⛔ ESSENTIAL: never disable

Android system, System UI, Settings / Settings Storage / Device configuration, **Bluetooth**, Input Devices, Key Chain, Package installer, Package Access Helper, Media Storage, Download Manager, External Storage, TV Storage, Contacts/Calendar Storage, Shell, CaptivePortalLogin (Wi-Fi login pages), Certificate Installer, ProxyHandler, PacProcessor, VpnDialogs, SecureElementApplication, Intent Filter Verification Service, Activity Stub, Android Services/Shared Library, WebView, WebContent, HTML Viewer, Companion Device Manager, **Google**, **Google Play services**, **Google Services Framework**, Google Backup Transport, Google One Time Init, One Time Init, Google Partner Set Up, Google Calendar Sync, **Gboard** (on-screen keyboard), **Android TV core services**, **Android TV Remote Service**, Android TV Tools, **Setup Wizard**, SetupCustomizer, Second Screen Setup Auth Bridge, **TvService**, **DroidLiveTv**, **DroidLogicTvInput**, **droidlogic System**, **Droid Settings**, **Droid Sound Effect Settings**, com.droidlogic.ble (likely the **remote's Bluetooth link**), com.droidlogic.overlay, **MiUtilRes**, milegal, Android Accessibility Suite (Projectivy's Home override uses the accessibility system), and the tiny `com.android.*` helpers (ctsshim, sharedstoragebackup, smspush, wallpaperbackup, wallpapercropper, backupconfirm, leanbacklauncher stubs).

> **TvService / DroidLiveTv / DroidLogicTvInput** run HDMI switching and also the panel's picture, sound and source pipeline. They're protected by the scripts.

## Still to photograph
The **"Downloaded apps"** section *above* "System apps" (Sony LIV, JioHotstar, YouTube Music, Play Movies, the WallPaper app, PatchWall and so on).
