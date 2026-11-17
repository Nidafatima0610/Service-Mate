import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/bookings/models/booking_model.dart';
import '../../features/bookings/presentation/screens/booking_confirmation_screen.dart';
import '../../features/bookings/presentation/screens/booking_history_screen.dart';
import '../../features/bookings/presentation/screens/booking_wizard_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/main_navigation_shell.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/services/models/service_model.dart';
import '../../features/services/presentation/screens/service_catalog_screen.dart';
import '../../features/services/presentation/screens/service_details_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainNavigationShell(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // Tab 1: Services Catalog
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/services',
              builder: (context, state) {
                final category = state.uri.queryParameters['category'];
                return ServiceCatalogScreen(initialCategory: category);
              },
            ),
          ],
        ),

        // Tab 2: My Bookings
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/bookings',
              builder: (context, state) => const BookingHistoryScreen(),
            ),
          ],
        ),

        // Tab 3: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    // Sub-routes outside shell
    GoRoute(
      path: '/service/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ServiceDetailsScreen(serviceId: id);
      },
    ),
    GoRoute(
      path: '/book-wizard',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final service = state.extra as ServiceModel;
        return BookingWizardScreen(service: service);
      },
    ),
    GoRoute(
      path: '/booking-confirmation',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final booking = state.extra as BookingModel;
        return BookingConfirmationScreen(booking: booking);
      },
    ),
  ],
);

