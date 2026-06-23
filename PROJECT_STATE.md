# PortScan Project State & Context

> [!IMPORTANT]
> **Context Bridge for AI Agents**: This document details the current architectural state, critical runtime fixes, and development progress of the PortScan vehicle logistics application.

## 1. Core Architecture

### Technology Stack
- **Framework**: Flutter 3.44.2 (Stable)
- **Primary Packages**: `google_fonts`, `lucide_icons_flutter`, `fl_chart`, `flutter_animate`, `supabase_flutter` (pinned), `syncfusion_flutter_charts`.
- **Styling**: Custom Design System in `lib/core/theme/`.

### Navigation Flow
- **Entry**: `lib/main.dart` -> `SplashPage` -> `WelcomePage`.
- **Auth Shells**: 
  - `BossShell`: Admin/Manager view.
  - `EmployeeShell`: Inspector view (current focus).
- **Adaptive UI**: `PSAdaptiveNav` handles Bottom Nav (Mobile) vs. Nav Rail (Desktop/Web).

## 2. Critical Runtime Fixes

### White Screen Issue (Resolved 2026-06-23)
The app experienced a silent initialization hang on Web and Android. Fixed via:
1. **Google Fonts**: `GoogleFonts.config.allowRuntimeFetching = false` in `main()`. This prevents network-dependent hangs; fonts fall back to system defaults if not bundled.
2. **Supabase Compatibility**: Pinned `supabase_flutter` to version **2.14.1**. Version 2.15.0+ caused an initialization hang in the current build environment.
3. **Error Boundaries**: Implemented `runZonedGuarded` and `FlutterError.onError` in `main.dart` to surface previously silent engine-level failures.

## 3. Data Flow
- **Mode**: Currently using **Mock Data** (`lib/data/mock_data.dart`) for internal testing.
- **Supabase**: Dependency present (`2.14.1`), but `Supabase.initialize` is not yet called in the codebase.

## 4. Current Work in Progress
- [ ] **State Management**: Moving from literal lists in shells to a more robust state management approach (currently using `setState` in shells).

## 5. AI Document Import (completed: 2026-06-23)

### What was built
- Multi-file import screen (PDF + JPG/PNG/WEBP)
- Mistral OCR → Groq extraction pipeline with VIN normalisation
- Reserve auto-match via simulated Supabase RPC
- Review screen with inline editing, duplicate detection, category suggestion
- Bulk vehicle insert with vessel upsert on confirm
- Full error handling for Mistral/Groq/Supabase failures

### Key files added/modified
- `lib/features/import/` — full feature directory (screens, notifier, models)
- `lib/core/services/mistral_service.dart`
- `lib/core/services/groq_service.dart`
- `pubspec.yaml` — added file_picker, flutter_image_compress, pdfx, flutter_riverpod
- `.env.local` — MISTRAL_API_KEY, GROQ_API_KEY configuration

### Known limitations / Phase 2 TODOs
- Files processed sequentially (not parallel) to avoid rate limits
- Mistral OCR struggles with very low-contrast or rotated scans
- Keys stored in .env.local are bundled in the app binary — move to server-side proxy in Phase 2

## 6. Android Build & Dependency Notes (updated: 2026-06-23)
- **Dependency Conflicts**: A conflict with `win32` was resolved by pinning `share_plus` to `^12.0.2` and `file_picker` to `^8.0.0`. 
- **Build Success**: The release APK build is verified and functional. Newer versions of `file_picker` (8.x+) are required for compatibility with AGP 9.0+ and to avoid the deprecated `jcenter` repository.

## 7. Technical Constraints & Tips
- **Renderer**: Use CanvasKit for best visual fidelity, but note that the HTML renderer might be faster for simple web debugging.
- **Icons**: Prefer `LucideIcons` via `lucide_icons_flutter`. `phosphor_flutter` is present but should be used sparingly due to compatibility issues in newer Flutter versions.
- **Fonts**: Do not enable runtime fetching without bundling fonts in `assets/` first.
