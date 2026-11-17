# ServiceMate — Service Booking App

[![Flutter Version](https://img.shields.io/badge/Flutter-3.47.1_Stable-02569B?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.13.1-0175C2?logo=dart)](https://dart.dev)
[![Tests Passing](https://img.shields.io/badge/Tests-39%2F39_Passing-brightgreen?logo=checkmarx)](file:///docs/test_report.md)
[![Static Analysis](https://img.shields.io/badge/Analyze-0_Issues-success?logo=dart)](file:///evidence/day_3/quality_audit_and_test_execution.md)
[![Release APK](https://img.shields.io/badge/Android_APK-51.2MB_Verified-success?logo=android)](file:///evidence/day_3/release_verification.md)
[![Web Release](https://img.shields.io/badge/Web_Build-Verified-success?logo=googlechrome)](file:///evidence/day_3/release_verification.md)

**Arrowstack Flutter App Development Internship Evaluation Project**  
**Role:** Senior Flutter Engineer, Product Designer, Software Architect & QA Lead  
**Evaluation Date:** November 17, 2026  

---

## 1. Project Title & Description

**ServiceMate** is a production-grade, multi-platform on-demand service marketplace application engineered with Flutter. It connects consumers with verified fictional professionals across 6 service domains: Home Cleaning, Beauty & Salon, Home Repair, Personal Training, Photography, and Tutoring.

The project demonstrates production-ready Flutter engineering:
- **Layered Feature-First Clean Architecture** with strict separation of presentation, state, domain, and data layers.
- **Flutter Riverpod 3.5.0** state management with asynchronous lifecycle notifiers (`AsyncNotifier`).
- **GoRouter 14.8.1** declarative routing with stateful bottom navigation preservation.
- **Local Persistence** using `SharedPreferences` with custom JSON serialization.
- **Dual-Layer Validation** combining form field validation with repository-level business rules (e.g. duplicate slot conflict prevention).
- **100% Automated Test Coverage** with 39 passing unit, repository, edge-case, and widget tests.

---

## 2. Key Features

- **Personalized Home Hub:** Welcoming greeting, quick category pills, upcoming appointment banner, and featured/popular service feeds.
- **Multi-Category Catalog:** 15 realistic services across 6 core categories with real-time text search and category chip filtering.
- **Service Details View:** Provider credential card, verified badge, ratings, reviews, "What's Included" checklist, and 24h guarantee.
- **Interactive 3-Step Booking Wizard:**
  - *Step 1: Date & Slot Selection* — 14-day rolling date strip (past dates prohibited) and morning/afternoon/evening time slots with live conflict detection.
  - *Step 2: Contact & Location* — Auto-populated from local user profile with strict input validation.
  - *Step 3: Review & Summary* — Full itemized financial calculation (Base Price + 5% Platform Fee + 8% Estimated Tax).
- **Booking Reference Generation:** Cryptographic reference format (`SM-YYYYMMDD-XXXX`) with one-tap clipboard copying.
- **Booking History & Self-Service Cancellation:** Tabbed management for Upcoming, Completed, and Cancelled appointments with reason-based cancellation that automatically re-opens the booked slot.
- **Profile Management:** Instant name, email, phone, and address editing with local disk persistence and demo data reset.

---

## 3. Technology Stack

| Component | Technology | Specification / Package |
|---|---|---|
| **Framework** | Flutter | Flutter 3.47.1 Stable (Engine `5d53178869`) |
| **Language** | Dart | Dart 3.13.1 (Sound Null-Safety) |
| **State Management** | Riverpod | `flutter_riverpod: ^3.5.0` |
| **Navigation** | GoRouter | `go_router: ^14.8.1` |
| **Local Storage** | SharedPreferences | `shared_preferences: ^2.5.3` |
| **Design System** | Material 3 | Midnight Navy (`#0F172A`) & Fresh Teal (`#0D9488`) |
| **Testing** | Flutter Test | `flutter_test` (39 passing unit & widget tests) |
| **Build Targets** | Multi-Platform | Android (Release APK), Web (CanvasKit), Windows |

---

## 4. Architecture Summary

ServiceMate adheres to a **Layered, Feature-First Clean Architecture**:

```
Presentation Layer (Screens, Shell, Widgets)
        │ Watches / Calls
        ▼
State Management Layer (Riverpod AsyncNotifiers & Providers)
        │ Invokes Business Methods
        ▼
Domain & Repository Layer (BookingRepository, ServiceRepository, ProfileRepository)
        │ Coordinates
        ▼
Data Sources Layer (MockServiceApiClient, BookingLocalDataSource, ProfileLocalDataSource)
```

For comprehensive architectural diagrams and data models, refer to [architecture.md](file:///docs/architecture.md).

---

## 5. Directory Structure

```
service_mate/
├── android/                         # Android native project & Gradle config
├── ios/                             # iOS native project
├── web/                             # Web container & manifest
├── lib/                             # Core Flutter source code
│   ├── app.dart                     # MaterialApp.router configuration
│   ├── main.dart                    # SharedPreferences pre-warming & ProviderScope
│   ├── core/                        # Cross-cutting constants, themes, router, validators
│   │   ├── constants/               # Colors, typography, global fee constants
│   │   ├── errors/                  # AppException hierarchy
│   │   ├── router/                  # GoRouter declarative configuration
│   │   ├── theme/                   # Material 3 light theme definition
│   │   └── utils/                   # Currency, date, and input validation utilities
│   ├── features/                    # Feature modules (Feature-first structure)
│   │   ├── home/                    # Home dashboard & main navigation shell
│   │   ├── services/                # Catalog, service models, mock API, details
│   │   ├── bookings/                # Booking wizard, models, repository, history
│   │   └── profile/                 # Profile editor, model, local data source
│   └── shared/                      # Reusable widgets (AppButton, AppTextField, EmptyState)
├── test/                            # Automated test suite (39 tests)
│   ├── unit/                        # Validators, models, repositories, and edge cases
│   └── widget/                      # Component and UI flow widget tests
├── docs/                            # Complete technical documentation suite
├── evidence/                        # Days 1–3 verification logs and evidence matrix
└── presentation/                    # Presentation outline & demo video script
```

---

## 6. Setup Instructions

To reproduce the project on your development machine:

```bash
# 1. Clone the repository
git clone <repository_url>
cd service_mate

# 2. Verify Flutter and Android toolchain
flutter doctor

# 3. Install project dependencies
flutter pub get
```

---

## 7. Run Instructions

### Run in Chrome (Web)
```bash
flutter run -d chrome
```

### Run on Android Device or Emulator
```bash
# Start an Android Emulator or connect a physical device via USB
flutter devices

# Launch the app in debug mode
flutter run -d android
```

---

## 8. Test Commands & Static Analysis

### Execute Static Analysis
```bash
flutter analyze
# Expected output: No issues found!
```

### Run the Full Automated Test Suite (39 Tests)
```bash
flutter test
# Expected output: All tests passed!
```

### Run Specific Test Suites
```bash
# Unit validators test:
flutter test test/unit/input_validators_test.dart

# Booking business logic & duplicate checks:
flutter test test/unit/booking_repository_test.dart

# Edge cases & mathematical fee precision:
flutter test test/unit/edge_cases_test.dart

# Widget component & UI flows:
flutter test test/widget/app_widget_flow_test.dart
```

---

## 9. Release Build Verification

Both release targets have been compiled and verified:

### 1. Android Production Release APK (VERIFIED)
- **Build Command:** `flutter build apk --release`
- **Output File:** `build/app/outputs/flutter-apk/app-release.apk`
- **File Size:** **53,654,657 bytes (~51.2 MB)**
- **Verification Details:** Documented in [release_verification.md](file:///evidence/day_3/release_verification.md).

### 2. Web Production Release Bundle (VERIFIED)
- **Build Command:** `flutter build web --release`
- **Output Directory:** `build/web/`
- **Verification Details:** Bundled with optimized CanvasKit engine and PWA service worker.

---

## 10. Demo Data Explanation

To ensure mentors and evaluators can immediately evaluate the app without manual data entry:
- **15 Services across 6 Categories:** Realistic descriptions, ratings (4.7–4.9★), provider names, session durations, and transparent pricing.
- **Pre-Seeded Bookings:** The app automatically seeds two demo bookings on first launch:
  - 1 Upcoming Booking: *Deep Home Cleaning* with SparkleClean Pro.
  - 1 Completed Booking: *Emergency Plumbing Repair* with FixIt Fast Plumbing.
- **Pre-Seeded User Profile:** Configured for demo user *"Sarah Jenkins"* with contact details and a default San Francisco street address.
- **Profile Reset:** Tapping "Reset Demo Profile" in the Profile tab restores original demo data at any time.

---

## 11. Known Limitations & Scope Boundaries

1. **Simulated Availability:** Available dates and time slots are algorithmically generated by `MockServiceApiClient` to provide realistic booking availability without external third-party calendar dependencies.
2. **Demo Payment Processing:** The pricing breakdown computes real base costs, platform fees (5%), and taxes (8%), but transactions are simulated without live card processors (Stripe/PayPal) for evaluation safety.
3. **Local Device Persistence:** Data is persisted in `SharedPreferences` on the client device. It persists reliably across app restarts, but is not synchronized to an external multi-tenant cloud database (e.g. Firebase or Supabase), matching the internship scope.

For full disclosure and future roadmap details, see [limitations_and_future_scope.md](file:///docs/limitations_and_future_scope.md).

---

## 12. Internship Documentation Index

- **Requirements Specification:** [docs/requirements.md](file:///docs/requirements.md)
- **System Architecture:** [docs/architecture.md](file:///docs/architecture.md)
- **Implementation Report:** [docs/implementation_report.md](file:///docs/implementation_report.md)
- **Automated Test Report:** [docs/test_report.md](file:///docs/test_report.md)
- **User & Evaluation Guide:** [docs/user_guide.md](file:///docs/user_guide.md)
- **Limitations & Future Scope:** [docs/limitations_and_future_scope.md](file:///docs/limitations_and_future_scope.md)
- **Requirements-to-Evidence Matrix:** [evidence/requirements_to_evidence_matrix.md](file:///evidence/requirements_to_evidence_matrix.md)
- **Evidence Index:** [evidence/evidence_index.md](file:///evidence/evidence_index.md)
- **Final Presentation Outline:** [presentation/presentation_outline.md](file:///presentation/presentation_outline.md)
- **Demo Video Script:** [presentation/demo_video_script.md](file:///presentation/demo_video_script.md)
