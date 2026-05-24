import 'package:go_router/go_router.dart';
import 'pages/landing_page.dart';
import 'pages/create_page.dart';
import 'pages/portfolio_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingPage(),
    ),
    GoRoute(
      path: '/create',
      builder: (context, state) => const CreatePage(),
    ),
    GoRoute(
      path: '/portfolio/:id',
      builder: (context, state) =>
          PortfolioPage(profileId: state.pathParameters['id']!),
    ),
  ],
);
