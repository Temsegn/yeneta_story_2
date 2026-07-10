// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Yeneta Story';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get signInSubtitle => 'Sign in to continue your learning journey';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get browseAsGuest => 'Browse as Guest';

  @override
  String get guestModeHint => 'Explore free content without an account';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get homeGreeting => 'Welcome,';

  @override
  String get guestName => 'Guest';

  @override
  String get exploreSubtitle => 'Explore the forest ❤';

  @override
  String get watchAndLearn => 'Watch & Learn';

  @override
  String videosCount(int count) {
    return '$count videos';
  }

  @override
  String get subscribeNow => 'Subscribe Now';

  @override
  String trialBanner(int days) {
    return 'Your free trial ends in $days days. Subscribe to keep premium access!';
  }

  @override
  String get paymentRequiredBanner =>
      'Your free trial has ended. Subscribe to unlock premium stories, books & videos!';

  @override
  String get guestPaymentBanner =>
      'Create an account to start your 5-day free trial and unlock all content!';

  @override
  String get createAccountToContinue => 'Create an account to continue';

  @override
  String get loginToPay =>
      'Please sign in or create an account to subscribe and pay.';

  @override
  String get loginToAccessProfile =>
      'Please sign in to access your profile and settings.';

  @override
  String get cancel => 'Cancel';

  @override
  String get loginOrRegister => 'Sign In / Register';

  @override
  String get profile => 'Profile';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get amharic => 'Amharic';

  @override
  String get bootstrapLoading => 'Loading Yeneta Story...';

  @override
  String get bootstrapCheckingVersion => 'Checking app version...';

  @override
  String get bootstrapCheckingAuth => 'Checking login session...';

  @override
  String get bootstrapCheckingPayment => 'Checking subscription status...';

  @override
  String get bootstrapReady => 'Ready!';

  @override
  String get updateRequiredTitle => 'Update Required';

  @override
  String get updateRequiredMessage =>
      'A new version of Yeneta Story is available. Please update to continue.';

  @override
  String get updateNow => 'Update Now';

  @override
  String get continueAsGuest => 'Continue without account';

  @override
  String get onboardingTitle1 => 'Read Stories';

  @override
  String get onboardingDesc1 =>
      'Discover amazing stories and adventures that spark imagination';

  @override
  String get onboardingTitle2 => 'Watch Videos';

  @override
  String get onboardingDesc2 =>
      'Watch educational videos designed for young learners';

  @override
  String get onboardingTitle3 => 'Play Games';

  @override
  String get onboardingDesc3 => 'Learn through fun and interactive games';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get freeTrialActive => 'Free Trial Active';

  @override
  String get subscriptionActive => 'Subscription Active';

  @override
  String daysRemaining(int days) {
    return '$days days remaining';
  }

  @override
  String get retry => 'Retry';

  @override
  String get unableToLoad => 'Unable to load videos';

  @override
  String get checkConnection => 'Please check your connection';

  @override
  String get premium => 'Premium';

  @override
  String get premiumLockedTitle => 'Premium content';

  @override
  String get premiumLockedGuestMessage =>
      'This content is premium. Create an account to start your free trial, or subscribe after it ends.';

  @override
  String get premiumLockedPayMessage =>
      'This content is locked. Choose a plan to unlock premium videos, books, and education.';

  @override
  String get viewPlans => 'View Plans';

  @override
  String get freeLabel => 'Free';
}
