# TV-Only Optimisation Guide (remote control only, no computer)

> Menu names below are the usual Android TV 9 names. Xiaomi sometimes renames or moves them. If a menu isn't where this says, look one level up or down under **Device Preferences**, and tell me what you see so I can update this guide for PI.6681.
>
> Open Settings with the **gear icon** at the top right of the home screen, or the **Settings / ☰ menu button** on the Mi remote.

---

## A. Privacy (Phase 1)

| # | Where | Set to | Undo |
|---|---|---|---|
| A1 | Settings → Device Preferences → **Usage & diagnostics** | **Off** | Turn it on |
| A2 | Settings → Device Preferences → About → Legal information → **Ads** *(on some builds: Settings → Google → Ads)* | **Opt out of Ads Personalisation: On**, then **Reset advertising ID** | Turn opt-out off |
| A3 | Settings → Device Preferences → **Location** | Location **Off**. If there's a "Wi-Fi scanning always available" option, **Off** | Turn it back on |
| A4 | Settings → Apps → **App permissions** → Microphone / Location / Storage | Remove permissions from apps that don't need them. **Keep the microphone on for Google / "Google app for Android TV"** so voice search works | Grant it again |
| A5 | PatchWall settings, *if present* (PatchWall home → settings/profile icon), or Settings → **Mi account / Privacy** | Turn off "User experience programme", "Personalised recommendations/ads" or similar | Turn it back on |
| A6 | **On your phone:** myaccount.google.com → Data & privacy, and **myadcenter.google.com** | Personalised ads **Off**. Check "Web & App Activity" and "YouTube History" | Same pages |
| A7 | Inside Netflix, YouTube and Prime | Turn off autoplay previews (Netflix: on the web, Profile → Playback settings). YouTube: pause watch history if you want | Same place |

**Kept on purpose:** Google Play Services, the Play Store and Google account sync. Streaming, app updates and casting all depend on them.

---

## B. Fewer ads and a cleaner home screen (Phase 2)

### B1. Android TV Home (the Google launcher)
1. Settings → Device Preferences → **Home screen** (or scroll to the bottom of the home screen → **Customise channels**)
2. **Customise channels:** turn off every channel you don't want. Keep at most Netflix / YouTube "Continue watching" if you like them.
3. **Enable video previews: Off**, and **Enable audio previews: Off**. This also saves CPU.
4. Turn off "Play Next", "Sponsored" or app-promotion rows if your build lists them.

### B2. PatchWall (Xiaomi launcher)
1. Open PatchWall → its settings (gear or profile icon)
2. Turn off recommendation, "Trending" and promotion rows wherever there's a switch
3. If there's a **"Default home: Android TV / PatchWall"** option, picking Android TV home removes PatchWall's ad rows straight away (reversible)

### B3. Promotional notifications
- Settings → Apps → *app* → **Notifications: Off** for each promo or partner app that sends pop-ups
- Settings → Device Preferences → **Notifications** (if present) → turn off unwanted senders

### B4. Partner and promo apps
- Settings → Apps → See all apps → *app*. If it offers **Uninstall**, it's a normal app you can reinstall from the Play Store, so remove it if unused.
- Apps that only offer **Disable** are system apps. Leave those for Section D and Phase 5.

**Honest expectation:** replacing the launcher (Phase 4) removes most home-screen ads. Ads *inside* YouTube, Prime and similar apps are served by those apps, and no safe TV setting removes them.

---

## C. Performance (Phase 3)

### C1. Turn on Developer options
Settings → Device Preferences → **About** → highlight **Build** → press OK **7 times** → "You are now a developer".

### C2. Animation scale (verified, standard, reversible)
Settings → Device Preferences → **Developer options** → Drawing:
- **Window animation scale: 0.5x**
- **Transition animation scale: 0.5x**
- **Animator duration scale: 0.5x**

To undo, set all three back to **1x**. *(Setting them to "Off" also works, but some launchers then feel jerky, so 0.5x is the sweet spot.)*

### C3. Do NOT change these (they hurt performance or stability)
- ❌ Background process limit
- ❌ Don't keep activities
- ❌ Force GPU rendering / Force 4x MSAA
- ❌ "Cleaner", "Booster" or "RAM optimiser" apps. Android manages memory itself, and these apps make apps restart from scratch, which is slower and wastes power.

### C4. Storage
1. Settings → Device Preferences → **Storage** → Internal shared storage → **Apps** (sorted by size)
2. For large apps you rarely use: **Uninstall** (normal apps) or **Clear cache** (any app)
3. Use **Clear cache**, never **Clear data**, on streaming apps. Clear data logs you out and removes downloads.
4. Aim for at least **1.5–2 GB free**. Android slows down when storage is nearly full.

### C5. Fewer apps running at startup
Android TV 9 has no "autostart manager" menu. What you can do:
- Uninstall or disable apps you don't use (they can't start if they're gone or disabled)
- Settings → Apps → *app* → **Force stop** for a misbehaving app (temporary)
- Turn off home-screen channels (B1), which stops their content providers refreshing in the background

### C6. Screensaver
Settings → Device Preferences → **Screen saver**: pick something light (Colours, or Backdrop/Ambient with few sources), or the Aerial Views app from Phase 4. Set **"Put device to sleep"** to a sensible time (e.g. 30 min–1 h).

### C7. Weekly habit
**Hold Power → Restart** about once a week. Standby keeps the TV running for weeks, and a real restart clears memory leaks.

---

## D. TV-only debloat (Phase 5)

Android TV 9 lets you **disable** many system apps from Settings, with no ADB and no root:

1. Settings → Apps → **See all apps** → **Show system apps**
2. Pick an app that's **SAFE** in `03-package-catalog.md` **and confirmed on your list**
3. Press **Disable** → OK. *(If Disable is greyed out, the system protects that app. Leave it.)*
4. **Run the 5-point smoke test** (see `00-upgrade-plan.md`)
5. Write it down: date, app, result

**Undo:** Settings → Apps → See all apps → Show system apps → find the app (disabled apps are listed near the bottom) → **Enable**.

Rules:
- **One app at a time.** Wait a day between batches.
- Don't disable anything marked CAUTION or ESSENTIAL from the TV menu.
- If the TV offers **Uninstall updates** instead, that only reverts the app to its factory version. It's safe, but it doesn't remove the app.

---

## E. Apps you can install on the TV (Play Store)

| Purpose | App | Notes |
|---|---|---|
| Launcher | **Projectivy Launcher** | Main recommendation. See `04-launcher-and-ui.md` |
| Launcher (alternative) | **FLauncher** | Open source, minimal, no ads. Simpler than Projectivy |
| Screensaver | **Aerial Views** | Open source, Apple TV-style aerial videos. Pick 1080p on this hardware |
| Sideloading helper | **Downloader** (AFTVnews) | Only if an app isn't on the Play Store. Use trusted sources only |
| File transfer | **Send Files to TV** | Moves wallpapers or APKs from your phone over Wi-Fi |
| Media player | **VLC for Android** | Can replace the Xiaomi video player for local or USB files |
| Phone as remote | **Google TV** app on your phone (remote feature) | Backup remote in case the physical one fails during testing |

If the Play Store on the TV doesn't show an app, it has marked it **incompatible with your device**. Treat that as a "no" and don't sideload it.
