# 📸 MuseCam AI — Flutter UI Specification & Generation Prompt

> **For use in VSCode / Antigravity / Cursor AI — Flutter Project Generation**

---

## ✦ MASTER GENERATION PROMPT

Paste this into Antigravity / Cursor / your AI coding assistant as the project-kick-off prompt:

---

```
You are building a Flutter mobile application called **MuseCam AI** — an intelligent AI-powered photography coaching app. 

The app guides users to take perfect photos by suggesting poses, giving real-time directional feedback (move left, tilt right, step back), and auto-capturing when lighting, clarity, and angle reach optimal conditions. It then auto-edits the photo and delivers a polished result.

---

## 🎨 DESIGN SYSTEM — FOLLOW STRICTLY

### Brand Identity
- **App Name:** MuseCam AI
- **Tagline:** "See the Shot Before You Take It."
- **Personality:** Creative, modern, playful-yet-premium, fluid, and empowering

### Color Palette
```dart
// Core Gradient — matches logo (warm gold → coral → hot pink)
const Color musePrimary     = Color(0xFFE8834A);   // warm coral-orange
const Color museSecondary   = Color(0xFFD4518A);   // deep rose-pink
const Color museGold        = Color(0xFFD4922B);   // rich amber-gold
const Color museHotPink     = Color(0xFFE0457B);   // vivid magenta-pink

// Backgrounds
const Color museDark        = Color(0xFF0D0C0E);   // near-black with warmth
const Color museSurface     = Color(0xFF1A1720);   // deep muted purple-dark
const Color museCard        = Color(0xFF221E2A);   // lifted card surface
const Color museGlass       = Color(0x22FFFFFF);   // glassmorphism fill

// Text
const Color museTextPrimary   = Color(0xFFF5F0F0); // warm white
const Color museTextSecondary = Color(0xFFAA9BAA); // muted lavender-grey

// Accent / Indicators
const Color museSuccess     = Color(0xFF6FEAB9);   // mint green (for "perfect!")
const Color museWarning     = Color(0xFFFFD166);   // amber (for "almost there")
const Color museDanger      = Color(0xFFFF6B6B);   // soft red (for "off")
```

### Typography
```dart
// Use Google Fonts package
// Display / Hero text:    'Urbanist' — weight 700–800 (rounded, modern, friendly)
// Body / Labels:          'DM Sans'  — weight 400–500 (clean, readable)
// Monospace / HUD data:   'JetBrains Mono' — weight 400 (camera overlays, values)
```

### Design Language
- **Style:** Dark-mode first, glassmorphism cards, animated mesh gradients, fluid curves
- **Shapes:** Rounded corners everywhere (borderRadius 20–32px); organic blobs as decorative elements
- **Motion:** Smooth spring animations (300–500ms), fade+slide transitions, pulsing indicators, gradient shimmer on CTAs
- **Elevation:** Multi-layer blur (BackdropFilter), soft glows (box shadows with brand colors at low opacity)
- **Icons:** Use `lucide_flutter` or `phosphor_flutter` icon pack — NO Material default icons
- **3D Feel:** Achieved via layered parallax on scroll, gradient depth on cards, subtle drop shadows with colored tints

---

## 📱 SCREENS — DETAILED SPECS

---

### 1. SPLASH / LANDING SCREEN

**Route:** `/`

**Layout:**
- Full-screen dark background (`museDark`)
- Animated gradient mesh background: slow-moving aurora blobs in `museGold`, `musePrimary`, `museSecondary` — use AnimationController with sinusoidal offset
- Center-aligned logo (the infinity-loop SVG / PNG asset) with a slow 360° rotation or gentle floating bob animation (use `Transform` + `AnimationController`)
- Logo glow: radial gradient behind logo, pulsing opacity 0.3 → 0.7
- App name **"MuseCam AI"** in Urbanist 800, size 36, warm white, letter-spacing 1.5
- Tagline: *"See the Shot Before You Take It."* in DM Sans 400, size 15, `museTextSecondary`
- **[Start Capturing →]** button — full-width, gradient fill (gold → coral → pink), rounded 32px, height 56px, with shimmer sweep animation on load
- **[Sign In]** text button — DM Sans, `museTextSecondary`
- **[Continue as Guest →]** text link — `musePrimary`, underlined
- Bottom: optional 3-dot onboarding carousel indicator

**Animations:**
- Logo: float + soft glow pulse (infinite)
- Background blobs: slow drift (8–12s loop)
- CTA button: gradient shimmer left-to-right on appear

---

### 2. ONBOARDING CAROUSEL (3 slides)

**Route:** `/onboarding`

**Slide structure (PageView):**
- Full bleed illustration area (top 60%) — abstract 3D swirl visuals matching logo palette
- Bottom panel: pill-shaped frosted glass card
  - Slide title: Urbanist 700, size 28
  - Slide body: DM Sans 400, size 15, line-height 1.6
  - Page dots indicator (animated active dot expands)
  - [Next] / [Get Started] button

**Slide content:**
1. 🎯 **"Strike the Perfect Pose"** — AI suggests poses based on your shot type. Just pick one and follow the guide.
2. 📸 **"We'll Tell You When You're Perfect"** — Real-time feedback: lighting, angle, stability. Auto-captures at the peak moment.
3. ✨ **"Instant Magic Edits"** — Your photo is auto-enhanced the moment it's captured. Share in seconds.

---

### 3. HOME SCREEN

**Route:** `/home`

**Layout:**
- Top bar: greeting ("Good Morning, [Name] ✦") in Urbanist 700 size 22 + avatar icon (top right, circular, tappable → profile)
- Animated gradient header strip (thin, 3px, full-width, flowing gold→pink)
- **Mode Selection Cards** (horizontal scroll or 2-column grid):
  - 👤 **Portrait Mode** — card with human silhouette icon, gradient tint warm orange
  - 📦 **Product Mode** — card with cube/box icon, gradient tint rose-pink
  - 🤳 **Selfie Mode** — card with face icon, gradient tint gold
  - 🌿 **Creative Mode** — card with sparkle/star icon, gradient tint coral
  - Each card: glassmorphism surface, icon top-left, label Urbanist 600, short description DM Sans 400 size 12, animated hover/tap scale
- **Recent Captures** section:
  - Section header: "Recent ✦" Urbanist 600 + "See All" link
  - Horizontal scroll of photo thumbnails with rounded corners (16px)
  - Each thumbnail: slight shadow with pinkish tint glow
- **AI Themes** strip:
  - Section: "Trending Themes" — horizontal pill chips (Moody Editorial / Golden Hour / Studio Clean / etc.)
- **Bottom Navigation Bar:**
  - Frosted glass bar, floating (not edge-to-edge), rounded pill shape, 12px from bottom
  - 4 tabs: Home · Capture · Gallery · Profile
  - Active tab: gradient icon + label in `musePrimary`
  - Inactive: `museTextSecondary`
  - Active tab indicator: small glowing dot below icon

---

### 4. CAMERA SCREEN

**Route:** `/camera`

**This is the most critical screen — full attention to detail.**

**Layout:**
- Full-screen camera preview (CameraPreview widget, covers 100% screen)
- All overlays layered on top via Stack

**Overlay Layer Stack (bottom to top):**

#### A. Grid Guide Overlay
- Rule-of-thirds grid: thin white lines at 33% opacity
- Optional: golden ratio spiral outline (toggle)

#### B. Bounding Box / Detection Overlay
- Animated rectangle drawn around detected face/body/object
- Color: `museSuccess` when aligned, `museWarning` when close, `museDanger` when off
- Corners only (not full box — just L-shaped corner indicators), animated pulse

#### C. Pose Skeleton Overlay (Portrait/Selfie)
- Stick-figure joints + lines drawn via CustomPainter
- Color: semi-transparent white lines, joint dots in `musePrimary`
- Suggested pose skeleton: dashed lines in gold showing target pose
- Actual detected pose: solid lines in white/green

#### D. HUD Indicators (top strip — frosted glass pill)
```
[ ☀ Lighting: 87% ]  [ ◎ Clarity: 94% ]  [ ∠ Angle: ✓ ]  [ ⊕ Stability ]
```
- Each in JetBrains Mono size 11
- Color-coded: green/amber/red per value
- Contained in a single frosted glass pill, top-center

#### E. Real-Time Guidance Text (center-bottom of preview)
- Large animated instruction text: **"Step slightly left →"** or **"Tilt chin down ↓"**
- Urbanist 700, size 20, white with dark shadow
- Appears with slide-in animation, auto-dismisses when corrected

#### F. Pose Recommendation Panel (bottom drawer — 40% screen height)
- Slides up from bottom (DraggableScrollableSheet)
- Frosted glass background
- "Suggested Poses" header
- Horizontal scroll of pose thumbnails (silhouette illustrations)
- Selected pose: glowing gold border
- [Apply This Pose] gradient button

#### G. Capture Controls (fixed bottom strip)
- Left: Camera flip icon (Phosphor `CameraRotate`)
- Center: Large capture button
  - Outer ring: animated gradient rotation (gold → pink)
  - Inner circle: white fill
  - Auto-capture mode: ring fills up as conditions improve (CircularProgressIndicator style)
- Right: Toggle Auto/Manual mode pill switch

#### H. Auto-Capture Animation
- When conditions hit 100%: brief haptic + flash overlay (white, 80ms fade)
- Text overlay: "✦ Perfect Shot!" slides up, Urbanist 700, `museSuccess`

---

### 5. EDITING / RESULT SCREEN

**Route:** `/edit`

**Layout:**
- Top: app bar with [← Back] and [Re-Edit] actions
- **Before/After Slider:**
  - Full-width image with draggable vertical divider
  - Left: "Before" label (DM Sans 400, `museTextSecondary`)
  - Right: "After" label (DM Sans 400, `musePrimary`)
  - Divider: white line with circular drag handle
- **Adjustment Controls** (horizontal scroll below image):
  - Pill-shaped sliders for: Brightness · Contrast · Sharpness · Warmth · Clarity
  - Each: label above (DM Sans 12), Slider with gradient track (gold → pink), current value in JetBrains Mono 11
- **Theme / Filter Strip:**
  - Section label: "AI Themes"
  - Horizontal scroll of filter previews (small image thumbnails with theme name below)
  - Active: gold glow border + checkmark overlay
- **Action Row (bottom):**
  - [💾 Save] — gradient filled button (full-width)
  - [↗ Share] — outlined button with gradient border
  - Both: height 52px, rounded 28px

---

### 6. GALLERY SCREEN

**Route:** `/gallery`

**Layout:**
- Top bar: "My Captures" Urbanist 700 + search icon + filter icon
- Filter chips (horizontal scroll): All · Portraits · Selfies · Products · Creative · Edited
- Photo grid: 2-column masonry or 3-column uniform grid
  - Each tile: rounded 16px, slight gradient shadow
  - Long-press: multi-select mode (checkbox overlay)
- Empty state: large soft illustration + "No captures yet. Start shooting! 📸"
- Bottom floating action bar (multi-select): Delete · Export · Share

---

### 7. PROFILE SCREEN

**Route:** `/profile`

**Layout:**
- Top: large avatar circle with gradient ring border (animated rotation)
- Name (Urbanist 700, size 24) + handle/email (DM Sans, `museTextSecondary`)
- **Subscription Badge:** "✦ Pro Member" pill in gold gradient, or "Free" in muted grey
- **Stats Row:** 3 columns — Captures · Themes Saved · Poses Used (JetBrains Mono values, DM Sans labels)
- **Settings List** (rounded card, grouped):
  - Notifications
  - Default Camera Mode
  - Preferred Themes
  - Auto-Edit On/Off toggle
  - Privacy
  - Help & Support
  - Rate MuseCam AI
  - [Log Out] — in `museDanger`, text button
- Each row: icon (Phosphor) + label (DM Sans) + chevron or toggle

---

### 8. SUBSCRIPTION / PREMIUM SCREEN

**Route:** `/premium`

**Layout:**
- Header: animated gradient background (aurora blobs), "Unlock MuseCam Pro ✦" in Urbanist 800
- Logo mark centered with glow
- Feature list (icon + text, 6–8 items):
  - ✦ Unlimited AI pose suggestions
  - ✦ Advanced auto-edit themes
  - ✦ Priority auto-capture speed
  - ✦ Exclusive Golden Hour & Studio filters
  - ✦ Watermark-free exports
  - ✦ Cloud gallery backup
- **Pricing Cards** (horizontal scroll or stacked):
  - Monthly: "PKR 799/mo" — outlined card
  - Yearly: "PKR 5,999/yr" — gradient filled card with "Best Value ✦" badge
  - Each: rounded 24px, feature comparison bullet list inside
- [Upgrade to Pro →] — large gradient CTA button
- [Restore Purchase] — small text link, `museTextSecondary`

---

## 🧩 SHARED / REUSABLE COMPONENTS

### MuseGradientButton
```dart
// Full-width or auto-width
// Gradient: LinearGradient([museGold, musePrimary, museSecondary])
// Border radius: 28–32px
// Height: 52–56px
// Shadow: BoxShadow(color: musePrimary.withOpacity(0.4), blurRadius: 20)
// Shimmer sweep animation on first render
```

### MuseGlassCard
```dart
// ClipRRect + BackdropFilter(ImageFilter.blur(sigmaX:16, sigmaY:16))
// Background: museGlass (rgba white 13%)
// Border: 1px rgba white 20%
// Border radius: 20px
// Used for: mode cards, HUD strip, panel drawers
```

### MuseHUDPill
```dart
// Frosted glass pill
// Row of status indicators
// Icon + value in JetBrains Mono 11
// Color coded: success / warning / danger
```

### MusePoseCard
```dart
// 80x100 rounded card
// Silhouette illustration
// Pose name label below
// Selected state: gradient border + glow
```

### MuseBottomNav
```dart
// ClipRRect pill shape
// BackdropFilter blur
// 4 NavigationDestination items
// Active: gradient icon color
// Animated active indicator dot
```

### MuseSlider
```dart
// Custom slider widget
// Track: gradient (museGold → museSecondary)
// Thumb: white circle with gold shadow
// Label: DM Sans 12 above
// Value: JetBrains Mono 11 trailing
```

---

## 📦 RECOMMENDED PACKAGES

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Camera
  camera: ^0.10.5
  
  # Fonts
  google_fonts: ^6.1.0
  
  # Icons
  phosphor_flutter: ^2.0.1
  
  # Animations
  flutter_animate: ^4.5.0
  lottie: ^3.1.0
  
  # State Management
  riverpod: ^2.5.1
  flutter_riverpod: ^2.5.1
  
  # Navigation
  go_router: ^13.2.0
  
  # Image editing
  image: ^4.1.7
  photo_view: ^0.14.0
  
  # Glassmorphism & blur
  glass_kit: ^3.0.0
  
  # Gradients & animations
  animated_background: ^2.0.0
  
  # Storage
  hive_flutter: ^1.1.0
  
  # Permissions
  permission_handler: ^11.3.0
  
  # Haptics
  flutter_haptic_feedback: ^0.5.0
```

---

## 🗂 PROJECT STRUCTURE

```
lib/
├── main.dart
├── app.dart                        # MaterialApp + theme + router
├── core/
│   ├── theme/
│   │   ├── colors.dart             # All color constants
│   │   ├── typography.dart         # TextStyles using Google Fonts
│   │   └── app_theme.dart          # ThemeData
│   ├── router/
│   │   └── app_router.dart         # GoRouter routes
│   └── constants/
│       └── strings.dart
├── features/
│   ├── onboarding/
│   │   ├── screens/
│   │   │   ├── splash_screen.dart
│   │   │   └── onboarding_screen.dart
│   │   └── widgets/
│   ├── home/
│   │   ├── screens/home_screen.dart
│   │   └── widgets/
│   │       ├── mode_card.dart
│   │       ├── recent_captures.dart
│   │       └── theme_chip_strip.dart
│   ├── camera/
│   │   ├── screens/camera_screen.dart
│   │   ├── widgets/
│   │   │   ├── hud_strip.dart
│   │   │   ├── pose_overlay.dart
│   │   │   ├── bounding_box_painter.dart
│   │   │   ├── grid_overlay.dart
│   │   │   ├── guidance_text.dart
│   │   │   ├── capture_button.dart
│   │   │   └── pose_panel.dart
│   │   └── providers/
│   │       └── camera_provider.dart
│   ├── edit/
│   │   ├── screens/edit_screen.dart
│   │   └── widgets/
│   │       ├── before_after_slider.dart
│   │       ├── adjustment_strip.dart
│   │       └── theme_filter_strip.dart
│   ├── gallery/
│   │   ├── screens/gallery_screen.dart
│   │   └── widgets/
│   │       ├── photo_grid.dart
│   │       └── filter_chips.dart
│   ├── profile/
│   │   ├── screens/profile_screen.dart
│   │   └── widgets/
│   └── premium/
│       ├── screens/premium_screen.dart
│       └── widgets/
│           ├── pricing_card.dart
│           └── feature_list.dart
└── shared/
    └── widgets/
        ├── muse_gradient_button.dart
        ├── muse_glass_card.dart
        ├── muse_hud_pill.dart
        ├── muse_bottom_nav.dart
        ├── muse_pose_card.dart
        └── muse_slider.dart
```

---

## 🎬 KEY ANIMATION SPECS

| Element | Animation | Duration | Curve |
|---|---|---|---|
| Splash logo | Float bob (Y ±8px, infinite) | 2500ms | easeInOut |
| Background blobs | Slow drift + color morph | 8000ms | linear |
| CTA button shimmer | Left → right sweep | 1200ms | easeInOut |
| Mode cards | Scale on tap (0.97) | 150ms | easeOut |
| Camera HUD | Fade in from top | 400ms | easeOut |
| Guidance text | Slide up + fade in | 300ms | easeOutCubic |
| Auto-capture ring | Arc fill 0→360° | realtime | linear |
| Capture flash | White overlay 0→1→0 | 80ms | linear |
| Bottom nav active | Dot scale + icon color | 250ms | spring |
| Before/after slider | Drag with haptic | realtime | — |

---

## 📐 SPACING & SIZING SYSTEM

```dart
// Base unit: 4px
const double spaceXS  = 4.0;
const double spaceSM  = 8.0;
const double spaceMD  = 16.0;
const double spaceLG  = 24.0;
const double spaceXL  = 32.0;
const double spaceXXL = 48.0;

// Border Radius
const double radiusSM  = 12.0;
const double radiusMD  = 20.0;
const double radiusLG  = 28.0;
const double radiusXL  = 40.0;
const double radiusPill = 999.0;

// Card elevation via shadow:
BoxShadow museCardShadow = BoxShadow(
  color: Color(0xFF000000).withOpacity(0.35),
  blurRadius: 24,
  offset: Offset(0, 8),
);

BoxShadow museGlowShadow = BoxShadow(
  color: musePrimary.withOpacity(0.30),
  blurRadius: 32,
  offset: Offset(0, 4),
);
```

---

## ✦ ADDITIONAL DESIGN NOTES

1. **Logo Usage:** The infinity-loop mark appears on: Splash (large, animated), Bottom nav center (small, static), Premium screen (medium, glowing). Always use the provided asset — never recreate it in code.

2. **Dark Mode Only:** This app ships dark-mode first. No light mode in v1.

3. **Gradient Direction:** All primary gradients run diagonally (135°): gold → coral → pink. This mirrors the logo's visual direction.

4. **Glass vs Solid:** Camera screen overlays = always glass. Non-camera screens = mix of glass cards on solid dark backgrounds.

5. **No Hard Whites:** Use `museTextPrimary` (warm white F5F0F0) instead of pure #FFFFFF for text to keep the warm, cozy feel.

6. **Phosphor Icons to use:** `Camera`, `CameraRotate`, `Aperture`, `SunHorizon`, `SmileyWink`, `Package`, `Star`, `MagicWand`, `User`, `Images`, `Gear`, `Crown`, `Lightning`, `ArrowRight`, `CheckCircle`

7. **Camera Screen Performance:** CustomPainter for all overlays (bounding box, skeleton, grid). Never use widget rebuilds for 60fps overlays.

8. **Haptic Feedback:** Light impact on mode select, medium on capture, heavy + success on auto-capture trigger.

---

*Generate each screen as a separate Flutter StatefulWidget or ConsumerWidget (Riverpod). Start with: `app.dart` → `app_theme.dart` → `splash_screen.dart` → `home_screen.dart` → `camera_screen.dart`. Ask before proceeding to edit/gallery/profile screens.*
```

---

## 🖼 LOGO & BRAND ASSETS

Place these in `assets/images/`:
- `logo_mark.png` — the infinity loop (transparent background, provided)
- `logo_full.png` — logo + wordmark if available
- `onboarding_1.png`, `onboarding_2.png`, `onboarding_3.png` — AI-generated visuals

Place in `assets/fonts/` and register in `pubspec.yaml` if downloading manually, or use `google_fonts` package.

---

## 🚀 HOW TO USE THIS PROMPT

1. Open **VSCode** with **Antigravity** (or Cursor / GitHub Copilot Chat)
2. Create a new Flutter project: `flutter create musecam_ai`
3. Open Antigravity / AI Chat panel
4. Paste the entire block inside the triple backticks above as your **first message**
5. Then follow up with: *"Start with `app_theme.dart` and `splash_screen.dart`"*
6. Iterate screen by screen — the spec above is self-contained per screen

---

*MuseCam AI — UI Spec v1.0 | Designed for Flutter 3.x | Dark Mode First*