// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Amharic (`am`).
class AppLocalizationsAm extends AppLocalizations {
  AppLocalizationsAm([String locale = 'am']) : super(locale);

  @override
  String get appTitle => 'የኔታ ታሪክ';

  @override
  String get welcomeBack => 'እንኳን ደህና መጡ!';

  @override
  String get signInSubtitle => 'በስልክ ቁጥርዎ ይግቡ እና ይቀጥሉ';

  @override
  String get email => 'ኢሜይል';

  @override
  String get emailOptional => 'ኢሜይል (አማራጭ)';

  @override
  String get emailHint => 'ኢሜይልዎን ያስገቡ';

  @override
  String get emailInvalid => 'እባክዎ ትክክለኛ ኢሜይል ያስገቡ';

  @override
  String get password => 'የይለፍ ቃል';

  @override
  String get passwordHint => 'የይለፍ ቃልዎን ያስገቡ';

  @override
  String get phoneRequired => 'ስልክ ቁጥር ያስፈልጋል';

  @override
  String get phoneInvalid => 'ትክክለኛ የኢትዮጵያ ሞባይል ያስገቡ (በ9 የሚጀምር 9 አሃዝ)';

  @override
  String get forgotPassword => 'የይለፍ ቃል ረሱ?';

  @override
  String get forgotPasswordTitle => 'የይለፍ ቃል ዳግም ያስጀምሩ';

  @override
  String get forgotPasswordSubtitle => 'ለመቀጠል ስልክ ቁጥርዎን ያስገቡ';

  @override
  String get continueLabel => 'ቀጥል';

  @override
  String get securityQuestion => 'የደህንነት ጥያቄ';

  @override
  String get securityQuestionHint => 'ለምሳሌ የቤት እንስሳዎ ስም ምንድን ነው?';

  @override
  String get securityAnswer => 'የደህንነት መልስ';

  @override
  String get securityAnswerHint => 'ሚስጥራዊ መልስዎ';

  @override
  String get securityQuestionRequired => 'እባክዎ የደህንነት ጥያቄ ያስገቡ';

  @override
  String get securityAnswerRequired => 'እባክዎ የደህንነት መልስ ያስገቡ';

  @override
  String get newPassword => 'አዲስ የይለፍ ቃል';

  @override
  String get newPasswordHint => 'አዲስ የይለፍ ቃል ያስገቡ';

  @override
  String get resetPassword => 'የይለፍ ቃል ዳግም ያስጀምሩ';

  @override
  String get passwordResetSuccess => 'የይለፍ ቃል ተዘምኗል! አሁን መግባት ይችላሉ።';

  @override
  String get smsRecoveryComingSoon =>
      'በSMS መልሶ ማግኘት በቅርብ ይመጣል። በደህንነት ጥያቄ ለመቀየር ኢሜይል ያክሉ።';

  @override
  String get signIn => 'ግባ';

  @override
  String get signUp => 'ተመዝገብ';

  @override
  String get createAccountTitle => 'መለያ ይፍጠሩ';

  @override
  String get createAccountSubtitle => 'የኔታ ታሪክን ይቀላቀሉ እና ጀምርዎን ይጀምሩ!';

  @override
  String get fullName => 'ሙሉ ስም';

  @override
  String get fullNameHint => 'ሙሉ ስምዎን ያስገቡ';

  @override
  String get phoneNumber => 'ስልክ ቁጥር';

  @override
  String get phoneNumberHint => '+251912345678';

  @override
  String get createPassword => 'የይለፍ ቃል';

  @override
  String get createPasswordHint => 'የይለፍ ቃል ይፍጠሩ';

  @override
  String get confirmPassword => 'የይለፍ ቃል ያረጋግጡ';

  @override
  String get confirmPasswordHint => 'የይለፍ ቃልዎን እንደገና ያስገቡ';

  @override
  String get acceptTerms => 'ውሎችን እና ሁኔታዎችን እቀበላለሁ';

  @override
  String get acceptTermsRequired => 'እባክዎ ውሎችን እና ሁኔታዎችን ይቀበሉ';

  @override
  String get alreadyHaveAccount => 'መለያ አለዎት? ';

  @override
  String get noAccount => 'መለያ የለዎትም?';

  @override
  String get browseAsGuest => 'እንደ እንግዳ ይሰራጩ';

  @override
  String get guestModeHint => 'ያለ መለያ ነፃ ይዘት ይመልከቱ';

  @override
  String get skip => 'ዝለል';

  @override
  String get next => 'ቀጣይ';

  @override
  String get getStarted => 'ጀምር';

  @override
  String get homeGreeting => 'እንኳን ደህና መጣህ,';

  @override
  String get guestName => 'እንግዳ';

  @override
  String get exploreSubtitle => 'ጫካውን ዳስስ ❤';

  @override
  String get watchAndLearn => 'ተመልከት እና ተማር';

  @override
  String videosCount(int count) {
    return '$count ትርዒቶች';
  }

  @override
  String get subscribeNow => 'አሁን ይመዝገቡ';

  @override
  String trialBanner(int days) {
    return 'ነፃ ፈተናዎ በ $days ቀናት ያበቃል። ፕሪሚየም ይዘት ለመጠቀም ይመዝገቡ!';
  }

  @override
  String get paymentRequiredBanner =>
      'ነፃ ፈተናዎ አልቋል። ፕሪሚየም ታሪኮች፣ መጽሐፍት እና ቪዲዮዎችን ለመክፈት ይመዝገቡ!';

  @override
  String get guestPaymentBanner =>
      '5 ቀን ነፃ ፈተና ለመጀመር መለያ ይፍጠሩ እና ሁሉንም ይዘት ይክፈቱ!';

  @override
  String get createAccountToContinue => 'ለመቀጠል መለያ ይፍጠሩ';

  @override
  String get loginToPay => 'ለመSubscribe እና ለመክፈል እባክዎ ይግቡ ወይም ይመዝገቡ።';

  @override
  String get loginToAccessProfile => 'መገለጫዎን እና ቅንብሮችዎን ለመድረስ እባክዎ ይግቡ።';

  @override
  String get cancel => 'ሰርዝ';

  @override
  String get loginOrRegister => 'ግባ / ተመዝገብ';

  @override
  String get profile => 'መገለጫ';

  @override
  String get logout => 'ውጣ';

  @override
  String get logoutConfirm => 'እርግጠኛ ነዎት መውጣት ይፈልጋሉ?';

  @override
  String get language => 'ቋንቋ';

  @override
  String get english => 'English';

  @override
  String get amharic => 'አማርኛ';

  @override
  String get bootstrapLoading => 'የኔታ ታሪክ በመጫን ላይ...';

  @override
  String get bootstrapCheckingVersion => 'የመተግበሪያ ስሪት በመፈተሽ ላይ...';

  @override
  String get bootstrapCheckingAuth => 'የግባት ሁኔታ በመፈተሽ ላይ...';

  @override
  String get bootstrapCheckingPayment => 'የSubscription ሁኔታ በመፈተሽ ላይ...';

  @override
  String get bootstrapReady => 'ተዘጋጅቷል!';

  @override
  String get splashTagline => 'ታሪኮች፣ ቪዲዮዎች እና አስደሳች ጀብዱዎች!';

  @override
  String get updateRequiredTitle => 'ዝመና ያስፈልጋል';

  @override
  String get updateRequiredMessage => 'የኔታ ታሪክ አዲስ ስሪት አለ። ለመቀጠል እባክዎ ያዘምኑ።';

  @override
  String get updateNow => 'አሁን አዘምን';

  @override
  String get continueAsGuest => 'ያለ መለያ ይቀጥሉ';

  @override
  String get onboardingTitle1 => 'ተረቶችን ያንብቡ';

  @override
  String get onboardingDesc1 => 'አስደናቂ ታሪኮችን እና ጀብዱዎችን ያግኙ';

  @override
  String get onboardingTitle2 => 'ቪዲዮዎችን ይመልከቱ';

  @override
  String get onboardingDesc2 => 'ለአነስተኛ ተማሪዎች የተዘጋጁ ትምህርታዊ ቪዲዮዎች';

  @override
  String get onboardingTitle3 => 'ጨዋታዎችን ይጫወቱ';

  @override
  String get onboardingDesc3 => 'በመዝናኛ እና በተግባራዊ ጨዋታዎች ይማሩ';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get freeTrialActive => 'ነፃ ፈተና ንቁ';

  @override
  String get subscriptionActive => 'Subscription ንቁ';

  @override
  String daysRemaining(int days) {
    return '$days ቀናት ቀርተዋል';
  }

  @override
  String get retry => 'እንደገና ይሞክሩ';

  @override
  String get unableToLoad => 'ቪዲዮዎችን መጫን አልተቻለም';

  @override
  String get checkConnection => 'እባክዎ ግንኙነትዎን ይፈትሹ';

  @override
  String get premium => 'ፕሪሚየም';

  @override
  String get premiumLockedTitle => 'ፕሪሚየም ይዘት';

  @override
  String get premiumLockedGuestMessage =>
      'ይህ ይዘት ፕሪሚየም ነው። ነፃ ፈተና ለመጀመር መለያ ይፍጠሩ፣ ወይም ከዚያ በኋላ ይመዝገቡ።';

  @override
  String get premiumLockedPayMessage =>
      'ይህ ይዘት ተቆልፏል። ፕሪሚየም ቪዲዮዎችን፣ መጻሕፍትን እና ትምህርትን ለመክፈት እቅድ ይምረጡ።';

  @override
  String get viewPlans => 'እቅዶችን ይመልከቱ';

  @override
  String get freeLabel => 'ነፃ';
}
