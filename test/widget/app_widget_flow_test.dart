import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:service_mate/core/theme/app_theme.dart';
import 'package:service_mate/features/bookings/models/booking_model.dart';
import 'package:service_mate/features/bookings/presentation/widgets/booking_status_badge.dart';
import 'package:service_mate/features/bookings/presentation/widgets/date_selector_strip.dart';
import 'package:service_mate/features/services/models/category_model.dart';
import 'package:service_mate/features/services/models/service_model.dart';
import 'package:service_mate/features/services/presentation/widgets/category_chip.dart';
import 'package:service_mate/features/services/presentation/widgets/service_card.dart';
import 'package:service_mate/shared/widgets/app_button.dart';
import 'package:service_mate/shared/widgets/empty_state_view.dart';
import 'package:service_mate/shared/widgets/error_state_view.dart';

void main() {
  group('Widget Tests - Reusable Components', () {
    testWidgets('AppButton renders label and triggers onPressed callback', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: 'Confirm Booking',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Confirm Booking'), findsOneWidget);
      await tester.tap(find.text('Confirm Booking'));
      expect(tapped, isTrue);
    });

    testWidgets('AppButton shows spinner when isLoading is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: 'Submit',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Submit'), findsNothing);
    });

    testWidgets('BookingStatusBadge renders appropriate text for confirmed and cancelled', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                BookingStatusBadge(status: BookingStatus.confirmed),
                BookingStatusBadge(status: BookingStatus.cancelled),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Confirmed'), findsOneWidget);
      expect(find.text('Cancelled'), findsOneWidget);
    });

    testWidgets('CategoryFilterChipWidget toggles selection correctly', (tester) async {
      bool clicked = false;
      const testCategory = ServiceCategory(
        id: 'home_cleaning',
        name: 'Home Cleaning',
        icon: Icons.cleaning_services_rounded,
        description: 'Cleaning description',
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: CategoryFilterChipWidget(
              category: testCategory,
              isSelected: true,
              onTap: () => clicked = true,
            ),
          ),
        ),
      );

      expect(find.text('Home Cleaning'), findsOneWidget);
      await tester.tap(find.text('Home Cleaning'));
      expect(clicked, isTrue);
    });

    testWidgets('ServiceCard renders all details and fires tap events', (tester) async {
      bool cardTapped = false;
      bool bookTapped = false;

      const sampleService = ServiceModel(
        id: 'clean_01',
        name: 'Deep Home Sanitization',
        categoryId: 'home_cleaning',
        categoryName: 'Home Cleaning',
        description: 'Comprehensive sanitization for whole home.',
        price: 140.0,
        durationMinutes: 150,
        providerName: 'CleanNest Pro Living',
        providerRating: 4.9,
        reviewCount: 142,
        badge: 'Most Popular',
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: ServiceCard(
              service: sampleService,
              onTap: () => cardTapped = true,
              onBookNow: () => bookTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Deep Home Sanitization'), findsOneWidget);
      expect(find.text('CleanNest Pro Living'), findsOneWidget);
      expect(find.text('Most Popular'), findsOneWidget);
      expect(find.text('\$140'), findsOneWidget);
      expect(find.text('Book Now'), findsOneWidget);

      await tester.tap(find.text('Book Now'));
      expect(bookTapped, isTrue);

      await tester.tap(find.text('Deep Home Sanitization'));
      expect(cardTapped, isTrue);
    });

    testWidgets('DateSelectorStrip renders selectable dates and triggers selection', (tester) async {
      final today = DateTime.now();
      DateTime? selected;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateSelectorStrip(
              selectedDate: today,
              onDateSelected: (d) => selected = d,
            ),
          ),
        ),
      );

      expect(find.text('Today'), findsOneWidget);
      // Tap today
      await tester.tap(find.text('Today'));
      expect(selected, isNotNull);
    });

    testWidgets('EmptyStateView renders title, message and action button', (tester) async {
      bool actionTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateView(
              icon: Icons.search_off_rounded,
              title: 'No Services Found',
              message: 'Try another search query.',
              actionLabel: 'Reset',
              onAction: () => actionTriggered = true,
            ),
          ),
        ),
      );

      expect(find.text('No Services Found'), findsOneWidget);
      expect(find.text('Try another search query.'), findsOneWidget);
      expect(find.text('Reset'), findsOneWidget);

      await tester.tap(find.text('Reset'));
      expect(actionTriggered, isTrue);
    });

    testWidgets('ErrorStateView renders error and retry button', (tester) async {
      bool retried = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorStateView(
              message: 'Network timeout occurred',
              onRetry: () => retried = true,
            ),
          ),
        ),
      );

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Network timeout occurred'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);

      await tester.tap(find.text('Try Again'));
      expect(retried, isTrue);
    });
  });
}

