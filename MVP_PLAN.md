# MVP Development Roadmap

## Plan: MVP Development Roadmap

**TL;DR:** Build a working end-to-end flow: Splash → Home (mode selection) → Camera (with ML detection + capture) → Gallery (view photos). Start with camera since it's the app's core, then work backwards through home/onboarding and forwards through gallery.

---

## Steps (in order)

### PHASE 1: Foundation Verification [1 Step]

**Step 1: Verify splash screen works on physical device**
- Run `flutter run` on actual phone
- Confirm video background plays, buttons navigate
- Check no build errors
- **Deliverable:** Working app entry point on device

---

### PHASE 2: Camera (Core Feature) [5 Steps]

**Step 2: Set up camera provider & ML Kit service**
- Create `lib/core/services/camera_service.dart` → manage CameraController, frame streaming
- Create `lib/core/services/ml_kit_service.dart` → wrap face detection, pose detection
- Set up Riverpod providers: `cameraProvider`, `mlKitProvider`
- Add Android permissions (in AndroidManifest.xml)
- **Deliverable:** Backend services ready to stream frames + detect faces

**Step 3: Build camera screen with basic overlays**
- Create `lib/features/camera/screens/camera_screen.dart`
- Render CameraPreview (full-screen)
- Add static overlays: grid guide, HUD strip (lighting/clarity/angle indicators)
- Add bounding box (drawn around detected face)
- **Deliverable:** Camera feed visible with face detection box

**Step 4: Add pose skeleton overlay + guidance text**
- Create `lib/shared/widgets/pose_skeleton_overlay.dart` → CustomPainter for stick figure
- Draw detected pose joints + lines on camera preview
- Add real-time guidance text (center-bottom): *"Move left"*, *"Tilt chin down"*, etc.
- **Deliverable:** Visual feedback showing user how to adjust

**Step 5: Implement capture controls**
- Add capture button (center-bottom) with auto-capture ring animation
- Save photo to device storage when tapped
- Add haptic feedback on capture
- Show brief success flash animation
- **Deliverable:** Users can take photos that get saved

**Step 6: Add pose recommendation drawer**
- Create bottom sheet with suggested poses (horizontal scroll cards)
- Let users tap a pose → app shows dashed lines for target pose
- [Apply] button → guides user to match it
- **Deliverable:** Pose suggestions visible and selectable

---

### PHASE 3: Home Screen (Navigation Hub) [2 Steps]

**Step 7: Build home screen layout**
- Create `lib/features/home/screens/home_screen.dart`
- Build 4 mode cards (Portrait, Product, Selfie, Creative) — each is a tap target to camera
- Add Recent Captures section (grid placeholder)
- Add AI Themes strip (horizontal scroll)
- **Deliverable:** Home is main navigation hub; users can select mode → go to camera

**Step 8: Implement mode selection routing**
- Pass selected mode via router state to camera screen
- Camera screen adjusts overlays/guidance based on mode
- (e.g., Selfie → show face pose; Product → show object bounding box)
- **Deliverable:** Selecting a mode on home changes camera behavior

---

### PHASE 4: Gallery (View Captures) [2 Steps]

**Step 9: Build gallery screen**
- Create `lib/features/gallery/screens/gallery_screen.dart`
- Show grid of all captured photos (thumbnail previews)
- Add tap-to-view full screen
- **Deliverable:** Users can browse photos they captured

**Step 10: Connect home Recent Captures → gallery**
- Populate Recent Captures section on home with latest photos
- "See All" link → navigate to gallery
- **Deliverable:** Full photo browsing workflow

---

### PHASE 5: Polish & Testing [1 Step]

**Step 11: End-to-end testing on device**
- Run full flow: Home → Select Mode → Camera (capture 3–5 photos) → Gallery (view them)
- Fix any crashes, performance issues
- Test ML Kit detection responsiveness
- **Deliverable:** MVP works end-to-end on physical device

---

## Relevant files

- `DESIGN.md` — Camera screen specs (overlays, HUD, controls)
- `PROJECT_CONTEXT.md` — Architecture, ML pipeline design
- `lib/core/theme/` — Theme constants (colors, typography, spacing) — all ready
- `lib/shared/widgets/video_background.dart` — Reuse for intro
- `lib/shared/widgets/muse_gradient_button.dart` — Use on all CTAs

---

## Verification

1. **After Step 1:** `flutter run` → splash screen renders on device with video background
2. **After Step 3:** Camera feed visible, face detection bounding box updates in real-time
3. **After Step 5:** Pose skeleton draws correctly; guidance text changes as user moves
4. **After Step 6:** Capture button works; photo file created in device storage
5. **After Step 8:** Selecting "Portrait" mode vs "Selfie" mode changes camera overlays/guidance
6. **After Step 10:** Home → Select mode → Camera → Capture → Gallery → View photo (end-to-end)

---

## Decisions

- **Skip onboarding for MVP** — Go straight to home when app launches
- **Skip authentication** — Anonymous/guest only
- **ML Kit only:** Face + Pose detection; skip object/text recognition for now
- **Camera mode:** Use `camera` package (already in pubspec); CameraAwesome is overkill for MVP
- **Photo storage:** Save to app's documents directory (no cloud sync yet)

---

## Further Considerations

1. **ML Kit re-add:** Google ML Kit was removed from pubspec. Should we:
   - **Option A (recommended):** Re-add `google_mlkit_face_detection` + `google_mlkit_pose_detection` packages now?
   - **Option B:** Build camera UI first without detection, add ML Kit later?
   
2. **Navigation flow:** When user completes capture on camera, should they:
   - **Option A (recommended):** Auto-go to gallery to see result?
   - **Option B:** Show a quick preview on camera screen before returning to home?

---

## Status

- ✅ Plan created
- ⏳ Ready for Step 1 execution