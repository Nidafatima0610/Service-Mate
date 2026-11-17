# Evidence — Day 1: Project Setup & Core Architecture

**Date:** 14 November 2026 (Day 1 of Sprint)  
**Milestone:** Foundation, Theme & Core Data Architecture

## Summary of Accomplishments
1. **Environment Audit:**
   - Flutter SDK: 3.47.1 Stable
   - Dart SDK: 3.13.1
   - Verified connected devices (Windows desktop, Chrome web, Edge web).
2. **Dependency Configuration:**
   - Added `flutter_riverpod: ^3.5.0` for predictable state management.
   - Added `go_router: ^18.1.4` for declarative URL routing with bottom navigation.
   - Added `shared_preferences: ^2.5.6` for persistent storage.
   - Added `intl: ^0.20.3` for currency and calendar formatting.
   - Added `uuid: ^4.6.0` for unique reference keys.
3. **Design System & Palette:**
   - Implemented `AppColors` featuring deep midnight navy (`#0F172A`), fresh teal accent (`#0D9488`), warm ivory canvas (`#FBFBFA`), and soft card surfaces.
   - Created `AppTheme.lightTheme` with customized Material 3 widgets (`CardThemeData`, `ElevatedButtonThemeData`, `InputDecorationTheme`, `BottomNavigationBarThemeData`).
   - Implemented `AppTypography` with hierarchical scale.
4. **Error Handling Architecture:**
   - Implemented `AppException` hierarchy: `NetworkException`, `ValidationException`, `StorageException`, `BookingDuplicateException`, `ResourceNotFoundException`.
5. **Data Layer Scaffolding:**
   - Designed domain models: `ServiceModel`, `ServiceCategory`, `BookingModel`, `TimeSlot`, `UserProfile`.
   - Built `ServiceMockData` catalog with 15 rich fictional services across 6 required categories.

