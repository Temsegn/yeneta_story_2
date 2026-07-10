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

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _securityQuestionController = TextEditingController();
  final _securityAnswerController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _obscureAnswer = true;
  bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _securityQuestionController.dispose();
    _securityAnswerController.dispose();
    super.dispose();
  }

  String? _phoneError(String? value, AppLocalizations l10n) {
    final code = EthiopianPhone.validate(value);
    if (code == 'required') return l10n.phoneRequired;
    if (code == 'invalid') return l10n.phoneInvalid;
    return null;
  }

  Future<void> _handleSignUp() async {
    final l10n = AppLocalizations.of(context);

    if (!_acceptTerms) {
      showAuthSnackBar(context, l10n.acceptTermsRequired, success: false);
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final phone = EthiopianPhone.normalizeToE164(_phoneController.text)!;
      final email = _emailController.text.trim();
      final authDataSource = ref.read(authRemoteDataSourceProvider);
      final response = await authDataSource.register(
        RegisterRequest(
          fullName: _fullNameController.text.trim(),
          email: email.isEmpty ? null : email,
          phoneNumber: phone,
          password: _passwordController.text,
          securityQuestion: _securityQuestionController.text.trim(),
          securityAnswer: _securityAnswerController.text.trim(),
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

  Widget _toggle(bool obscure, VoidCallback onToggle) {
    return IconButton(
      icon: Icon(
        obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        color: AuthBrand.inkMuted,
      ),
      onPressed: onToggle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AuthScreenShell(
      gradientColors: AuthBrand.signUpGradient,
      heroEmoji: '🌟',
      title: l10n.createAccountTitle,
      subtitle: l10n.createAccountSubtitle,
      showBackButton: true,
      onBack: () => context.pop(),
      formChild: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthTextField(
              controller: _fullNameController,
              label: l10n.fullName,
              hint: l10n.fullNameHint,
              icon: Icons.person_outline_rounded,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) return l10n.fullNameHint;
                return null;
              },
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _phoneController,
              label: l10n.phoneNumber,
              hint: l10n.phoneNumberHint,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              validator: (value) => _phoneError(value, l10n),
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _emailController,
              label: l10n.emailOptional,
              hint: l10n.emailHint,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return null;
                if (!value.contains('@')) return l10n.emailInvalid;
                return null;
              },
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _passwordController,
              label: l10n.createPassword,
              hint: l10n.createPasswordHint,
              icon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              suffixIcon: _toggle(
                _obscurePassword,
                () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.createPasswordHint;
                }
                if (value.length < 6) return l10n.createPasswordHint;
                return null;
              },
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _confirmPasswordController,
              label: l10n.confirmPassword,
              hint: l10n.confirmPasswordHint,
              icon: Icons.verified_user_outlined,
              obscureText: _obscureConfirmPassword,
              textInputAction: TextInputAction.next,
              suffixIcon: _toggle(
                _obscureConfirmPassword,
                () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.confirmPasswordHint;
                }
                if (value != _passwordController.text) {
                  return l10n.confirmPasswordHint;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _securityQuestionController,
              label: l10n.securityQuestion,
              hint: l10n.securityQuestionHint,
              icon: Icons.help_outline_rounded,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().length < 5) {
                  return l10n.securityQuestionRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _securityAnswerController,
              label: l10n.securityAnswer,
              hint: l10n.securityAnswerHint,
              icon: Icons.shield_outlined,
              obscureText: _obscureAnswer,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _handleSignUp(),
              suffixIcon: _toggle(
                _obscureAnswer,
                () => setState(() => _obscureAnswer = !_obscureAnswer),
              ),
              validator: (value) {
                if (value == null || value.trim().length < 2) {
                  return l10n.securityAnswerRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            Material(
              color: AuthBrand.coral.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: () => setState(() => _acceptTerms = !_acceptTerms),
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _acceptTerms,
                        onChanged: (value) {
                          setState(() => _acceptTerms = value ?? false);
                        },
                        activeColor: AuthBrand.coral,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          l10n.acceptTerms,
                          style: const TextStyle(
                            color: AuthBrand.inkMuted,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            AuthPrimaryButton(
              label: l10n.signUp,
              isLoading: _isLoading,
              gradient: AuthBrand.signUpButtonGradient,
              onPressed: _handleSignUp,
            ),
            const SizedBox(height: 22),
            AuthLinkRow(
              prefix: l10n.alreadyHaveAccount,
              actionLabel: l10n.signIn,
              onTap: () => context.go('/signin'),
            ),
          ],
        ),
      ),
    );
  }
}
