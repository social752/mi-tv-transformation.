# Package Catalog — SAFE / CAUTION / ESSENTIAL

> **Important:** Google and Android package names below are standard on Android TV 9. **Xiaomi package names vary between firmware builds and regions**, so Xiaomi entries are listed by **what you see in Settings** together with a *typical* package pattern marked **VERIFY**. Nothing Xiaomi-specific gets disabled until we've confirmed it in **your** inventory (Phase 0 photos, or `packages-system.txt` from the Phase 6 backup).

## Categories

| Category | Meaning | Action |
|---|---|---|
| **SAFE** | Not needed for the TV, remote, streaming, updates or the Play Store | Can be disabled (one at a time, smoke test after each) |
| **CAUTION** | Not core, but something you use may depend on it | Disable only with ADB, after a backup, after we discuss it |
| **ESSENTIAL** | Core system, connectivity, remote, updates or streaming | **Never touch.** The scripts refuse these |

---

## ESSENTIAL — never disable

| Package | What it does |
|---|---|
| `android`, `com.android.systemui`, `com.android.tv.settings`, `com.android.providers.*` | Core Android, settings, system databases (including the TV channel provider) |
| `com.android.bluetooth` | **Bluetooth remote** |
| `com.google.android.gms`, `com.google.android.gsf`, `com.android.vending` | Google Play Services, Services Framework, Play Store |
| `com.google.android.katniss` | Google app for Android TV: **voice search / mic button** |
| `com.google.android.tungsten.setupwraith` | Android TV setup. **Disabling it is known to break the Home button** |
| `com.google.android.tv.remote.service` | Android TV Remote service (phone remote, some remote functions) |
| `com.google.android.leanback.ime` | On-screen keyboard |
| `com.google.android.webview` | Web content inside apps (logins, some players) |
| `com.android.packageinstaller`, `com.google.android.packageinstaller`, `com.android.permissioncontroller` | Installing apps, permissions |
| `com.netflix.ninja`, `com.google.android.youtube.tv`, `com.amazon.amazonvideo.livingroom` | Netflix, YouTube, Prime Video |
| Xiaomi **system updater** (labels like "System update"/"Upgrade"; pattern `*upgrade*`, `*update*`, `*ota*`) — VERIFY | Firmware updates |
| Xiaomi **TV inputs / HDMI / source / TV service / picture & sound** (patterns `*tvinput*`, `*tvservice*`, `*hdmi*`, `*source*`) — VERIFY | HDMI switching, picture and sound settings |
| Xiaomi **remote / Bluetooth pairing** (patterns `*btrc*`, `*remote*`, `*bluetooth*`) — VERIFY | Pairing the Mi remote |
| Xiaomi **factory / provisioning / setup** (patterns `*factory*`, `*provision*`, `*setup*`) — VERIFY | First-boot and factory functions |

## CAUTION — ADB only, after discussion

| Package / label | Why CAUTION | When it's fine to disable |
|---|---|---|
| `com.google.android.tvlauncher` (Android TV Home) | Default home screen | Only **after** Projectivy has worked for days (Phase 7, launcher list) |
| **PatchWall** (pattern `com.mitv.tvhome*`) — VERIFY | Xiaomi launcher. On some builds it also hosts Xiaomi shortcuts or input switching | Only after confirming inputs and the remote's PatchWall button still behave |
| `com.google.android.tvrecommendations` | Feeds recommendation rows on Android TV Home | Fine once you use Projectivy |
| `com.google.android.apps.mediashell` | **Chromecast built-in** | Only if you never cast from your phone |
| `com.google.android.backdrop` | Ambient Mode screensaver | If you use another screensaver (e.g. Aerial Views) |
| `com.google.android.tv` (Live Channels) | Antenna and channel apps | Only if you don't use antenna or live TV |
| `com.google.android.speech.pumpkin` | Offline speech for voice | Keep if voice search is slow without it |
| `com.google.android.partnersetup` | Partner app setup | Usually fine, but low benefit |
| Xiaomi **analytics / statistics / feedback / report** — VERIFY | Telemetry. Some Xiaomi components misbehave when their partner process is missing | Test one at a time and watch for error pop-ups |
| Xiaomi **Media Explorer / file manager** — VERIFY | USB playback | If VLC covers your USB use |
| Xiaomi **Mi account / cloud** — VERIFY | Account and PatchWall sync | If you don't use a Mi account |

## SAFE — disable if unused (one at a time)

| Package / label | What it is |
|---|---|
| `com.google.android.videos` | Google Play Movies & TV |
| `com.google.android.play.games` | Google Play Games |
| `com.google.android.youtube.tvmusic` | YouTube Music (keep if you use it) |
| `com.google.android.youtube.tvkids` | YouTube Kids (keep if you use it) |
| `com.google.android.feedback` | Sends feedback / crash reports to Google |
| `com.google.android.marvin.talkback` | TalkBack screen reader (keep if anyone needs it) |
| `com.android.dreams.basic` | Basic "Colours" screensaver |
| Xiaomi **video player** ("Mi Video", pattern `*videoplayer*`) — VERIFY | Replace with VLC |
| Xiaomi **screensaver / wallpaper** — VERIFY | Replaced by Aerial Views or Projectivy wallpaper |
| Xiaomi **TV Manager / cleaner / booster** — VERIFY | A "cleaner" app that does more harm than good |
| Xiaomi **app store / promotions / "Mi TV" ads services** — VERIFY | Promotional content |
| **Partner apps** (regional streaming or shopping apps you don't use) | If they show **Uninstall**, simply uninstall them |

### Seen on your TV (India build) — decide per app

| App on your home screen | Suggested category | Notes |
|---|---|---|
| Google Play Movies & TV | SAFE | Google is retiring it; its recommendations moved to Home |
| YouTube Music | SAFE if unused | |
| Sony LIV | SAFE if unused | Partner app. Usually offers **Uninstall** |
| JioHotstar | **You decide** | Uninstall if you don't subscribe. The "Sponsored by JioHotstar" row is a Google ad slot and may stay either way |
| "WallPaper" app | SAFE | Replaced by Projectivy wallpapers |
| Xiaomi tile (first favourite) | CAUTION — VERIFY | Probably PatchWall or a Xiaomi content app |
| **TV** (blue tile) | ESSENTIAL | Inputs/Live TV. HDMI and antenna switching |
| Green cast tile | CAUTION — VERIFY | Probably screen-mirroring/cast. Keep if you cast from your phone |
| Netflix, YouTube, Prime Video, Play Store | ESSENTIAL | |

---

## How this maps to the scripts

| File | Contents |
|---|---|
| `lists/essential-denylist.txt` | Exact names and regex patterns the scripts **refuse** to change |
| `lists/google-safe.txt` | SAFE Google packages (names confirmed for Android TV 9) |
| `lists/caution-launcher.txt` | Launcher switch (Phase 7). Needs you to type the package name to confirm |
| `lists/xiaomi-safe.txt` | **Empty template.** Filled in only from your Phase 6 backup |
