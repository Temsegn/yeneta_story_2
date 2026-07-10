import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/signin_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/shell/presentation/view/app_shell.dart';
import '../../features/notification/presentation/screens/notification_list_screen.dart';
import '../../features/notification/presentation/screens/notification_detail_screen.dart';
import '../../features/notification/data/models/notification_model.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/child_profiles_screen.dart';
import '../../features/profile/presentation/screens/account_settings_screen.dart';
import '../../features/subscription/presentation/screens/subscription_screen.dart';
import '../../features/subscription/presentation/screens/subscription_success_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/signin',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const AppShell(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationListScreen(),
    ),
    GoRoute(
      path: '/notification-detail',
      builder: (context, state) {
        final notification = state.extra as NotificationModel;
        return NotificationDetailScreen(notification: notification);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/child-profiles',
      builder: (context, state) => const ChildProfilesScreen(),
    ),
    GoRoute(
      path: '/account-settings',
      builder: (context, state) => const AccountSettingsScreen(),
    ),
    GoRoute(
      path: '/subscription',
      builder: (context, state) => const SubscriptionScreen(),
    ),
    GoRoute(
      path: '/subscription-success',
      builder: (context, state) => const SubscriptionSuccessScreen(),
    ),
  ],
);
