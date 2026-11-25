# Premium Launcher and Apple TV-Inspired UI

## 1. Launcher comparison (Android TV 9)

| Launcher | Price | Ads | Weight | Customisation | Verdict |
|---|---|---|---|---|---|
| **Projectivy Launcher** | Free; optional one-off Premium | None | Light | Wallpapers (including dynamic and blurred), categories/rows, icon cards, app hiding, **built-in "override launcher"** that makes Home open Projectivy without ADB | ✅ **Recommended** |
| **FLauncher** | Free, open source | None | Very light | Categories, wallpaper, app reordering. Fewer visual effects | ✅ Fallback if Projectivy feels heavy |
| **ATV Launcher** | Free / Pro | Free version has ads | Light | Grid-based, plenty of options | ⚠️ Usable, less "premium" |
| **Wolf Launcher** | Free / paid | — | Light | Lots of options | ⚠️ Sideload-only on many devices and less transparent. Not recommended |
| **Google TV home** | — | — | — | — | ❌ **Won't work on Android TV 9.** Don't sideload it |

**Compatibility check for build PI.6681:** install from the **Play Store on the TV**. If the Play Store shows the app as installable, Google has checked it against your device (Android version and TV features). That's the check we rely on, rather than guessing.

**Your situation (confirmed at Gate 0):** Home is Google's Android TV Home, which shows a "Sponsored by JioHotstar" row and promoted movie rows. Turning off channels reduces this but may not remove the sponsored row, so Projectivy is the main fix for your ads.

## 2. Design spec: "Apple TV-inspired" home

```
┌──────────────────────────────────────────────────────────────┐
│  (dark, softly blurred wallpaper — deep navy / charcoal)     │
│                                                    21:04  ⚙  │
│                                                              │
│   TOP SHELF  ─ large cards, 16:9                             │
│   ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐     │
│   │NETFLIX │ │YOUTUBE │ │ PRIME  │ │ (opt.) │ │ (opt.) │     │
│   └────────┘ └────────┘ └────────┘ └────────┘ └────────┘     │
│                                                              │
│   Utilities ─ small cards                                    │
│   [ VLC ] [ Play Store ] [ Settings ] [ Inputs/HDMI ]        │
│                                                              │
│   (nothing else: no promoted rows, no autoplay previews)     │
└──────────────────────────────────────────────────────────────┘
```

**Principles**
- **Maximum 2 rows**, with at most 5–6 items in the top row, so the D-pad reaches any app in ≤ 3 presses
- **Dark wallpaper**, slightly blurred, so the cards stand out (Apple TV look). Avoid busy photos.
- **Rounded 16:9 banners** (Android TV apps supply these "banner" images), not small square icons
- **Netflix, YouTube and Prime in positions 1–3.** The Mi remote's dedicated Netflix and Prime buttons keep working whatever launcher you use.
- **Animations:** let the launcher handle focus scaling, and keep system animation scale at 0.5x
- **Wallpaper resolution:** 1920×1080 JPG, under 1 MB. 4K or animated wallpapers cost RAM on this hardware.

**Suggested Projectivy settings** *(names may differ slightly between versions)*
- Wallpaper: a custom image, **blur on**, **dim around 30–40%**
- Rows: "Favourites" (Netflix, YouTube, Prime …) plus "Utilities"
- Hide all other apps from home (they stay in the full app list)
- Channel / preview rows: **off** (lighter, no promoted content)
- Clock: on. Weather: optional.

**Screensaver:** install **Aerial Views** from the Play Store → Settings → Device Preferences → Screen saver → Aerial Views. In its settings choose **1080p** and Apple-style aerial videos. 4K is too heavy for this hardware.

## 3. Installation guide (TV-only)

1. **Play Store** on the TV → search **"Projectivy Launcher"** → Install.
2. Open Projectivy. The setup asks about rows and wallpaper; follow the spec above.
3. **Making Home open Projectivy (no ADB):**
   - In Projectivy settings → **"Override current launcher"** (or similarly named). It asks you to enable its **accessibility service**.
   - Settings → Device Preferences → **Accessibility** → *Projectivy* → **On**.
   - Press **Home**. Projectivy should appear.
   - *Privacy note:* accessibility services can see what's on screen. Projectivy only uses it to catch the Home button. Grant this **only** to Projectivy (or to FLauncher/Button Mapper if you choose them).
4. **Test for 2–3 days** with the 5-point smoke test.
5. **To undo:** turn the Projectivy accessibility service off, or uninstall Projectivy. The old home returns straight away.

## 4. Later, with ADB (Phase 7, optional)

The accessibility override sometimes shows the old launcher for a split second, or loses the override after an update. With ADB you can make Projectivy the **only** launcher by **disabling** (not uninstalling) the stock launcher, using `lists/caution-launcher.txt`. This is reversible with `scripts/03-restore.sh`. We do it only after the Phase 4 test passes and with your typed confirmation.

## 5. Optional: remote buttons

- The **Netflix** and **Prime Video** buttons are handled by the system, so they keep working.
- The **PatchWall** button (if your remote has one) may open PatchWall even after you switch launchers. **Button Mapper** (Play Store) can remap it, but needs an accessibility permission too. Optional; decide after Phase 4.
