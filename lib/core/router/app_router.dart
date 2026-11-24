import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/bookings/bookings_screen.dart';
import '../../presentation/screens/budget/budget_screen.dart';
import '../../presentation/screens/create/create_itinerary_screen.dart';
import '../../presentation/screens/explore/explore_screen.dart';
import '../../presentation/screens/itinerary/itinerary_details_screen.dart';
import '../../presentation/screens/itinerary/itinerary_screen.dart';
import '../../presentation/screens/landing/landing_screen.dart';
import '../../presentation/screens/map/map_screen.dart';
import '../../presentation/screens/must_visit/must_visit_screen.dart';
import '../../presentation/screens/preview/ai_preview_screen.dart';
import '../../presentation/screens/search/search_screen.dart';
import '../../presentation/screens/summary/trip_summary_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingScreen(),
    ),
    GoRoute(
      path: '/explore',
      builder: (context, state) => const ExploreScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/create',
      builder: (context, state) => const CreateItineraryScreen(),
    ),
    GoRoute(
      path: '/must-visit',
      builder: (context, state) => const MustVisitScreen(),
    ),
    GoRoute(
      path: '/preview',
      builder: (context, state) => const AiPreviewScreen(),
    ),
    GoRoute(
      path: '/itinerary',
      builder: (context, state) => const ItineraryScreen(),
      routes: [
        GoRoute(
          path: 'details',
          builder: (context, state) => const ItineraryDetailsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/budget',
      builder: (context, state) => const BudgetScreen(),
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) => const MapScreen(),
    ),
    GoRoute(
      path: '/summary',
      builder: (context, state) => const TripSummaryScreen(),
    ),
    GoRoute(
      path: '/bookings',
      builder: (context, state) => const BookingsScreen(),
    ),
    GoRoute(
      path: '/trips',
      builder: (context, state) => const TripsScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);
