import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_app/l10n/app_localizations.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../../core/utils/ethiopian_phone.dart';
import '../../data/models/auth_models.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_brand.dart';
import '../widgets/auth_ui.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _phoneError(String? value, AppLocalizations l10n) {
    final code = EthiopianPhone.validate(value);
    if (code == 'required') return l10n.phoneRequired;
    if (code == 'invalid') return l10n.phoneInvalid;
    return null;
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final phone = EthiopianPhone.normalizeToE164(_phoneController.text)!;
      final authDataSource = ref.read(authRemoteDataSourceProvider);
      final response = await authDataSource.login(
        LoginRequest(
          phoneNumber: phone,
          password: _passwordController.text,
        ),
      );

      ref.read(authStateProvider.notifier).state = response.user;
      ref.read(guestModeProvider.notifier).state = false;
      await ref.read(appPreferencesProvider).setGuestMode(false);

      if (mounted) {
        showAuthSnackBar(context, response.message);
        context.go('/home');
      }
    } catch (e) {
      if (mounted) showAuthSnackBar(context, e.toString(), success: false);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _continueAsGuest() async {
    ref.read(guestModeProvider.notifier).state = true;
    await ref.read(appPreferencesProvider).setGuestMode(true);
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AuthScreenShell(
      gradientColors: AuthBrand.signInGradient,
      heroEmoji: '👋',
      title: l10n.welcomeBack,
      subtitle: l10n.signInSubtitle,
      formChild: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthTextField(
              controller: _phoneController,
              label: l10n.phoneNumber,
              hint: l10n.phoneNumberHint,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              validator: (value) => _phoneError(value, l10n),
            ),
            const SizedBox(height: 18),
            AuthTextField(
              controller: _passwordController,
              label: l10n.password,
              hint: l10n.passwordHint,
              icon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleSignIn(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AuthBrand.inkMuted,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return l10n.passwordHint;
                if (value.length < 6) return l10n.passwordHint;
                return null;
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.push('/forgot-password'),
                child: Text(
                  l10n.forgotPassword,
                  style: const TextStyle(
                    color: AuthBrand.purple,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            AuthPrimaryButton(
              label: l10n.signIn,
              isLoading: _isLoading,
              onPressed: _handleSignIn,
            ),
            const SizedBox(height: 14),
            AuthOutlineButton(
              label: l10n.browseAsGuest,
              icon: Icons.explore_rounded,
              onPressed: _continueAsGuest,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.guestModeHint,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AuthBrand.inkMuted.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 22),
            const AuthDivider(),
            const SizedBox(height: 22),
            AuthLinkRow(
              prefix: l10n.noAccount,
              actionLabel: l10n.signUp,
              onTap: () => context.go('/signup'),
            ),
          ],
        ),
      ),
    );
  }
}
