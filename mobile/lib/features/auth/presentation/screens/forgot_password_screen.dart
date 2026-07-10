import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_app/l10n/app_localizations.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/ethiopian_phone.dart';
import '../../data/models/auth_models.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_brand.dart';
import '../widgets/auth_ui.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _answerController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  int _step = 1;
  String? _securityQuestion;
  String? _normalizedPhone;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _obscureAnswer = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _answerController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _phoneError(String? value, AppLocalizations l10n) {
    final code = EthiopianPhone.validate(value);
    if (code == 'required') return l10n.phoneRequired;
    if (code == 'invalid') return l10n.phoneInvalid;
    return null;
  }

  Future<void> _fetchQuestion() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final phone = EthiopianPhone.normalizeToE164(_phoneController.text)!;
      final ds = ref.read(authRemoteDataSourceProvider);
      final result = await ds.requestPasswordReset(
        ForgotPasswordRequest(phoneNumber: phone),
      );
      if (!mounted) return;
      setState(() {
        _normalizedPhone = result.phoneNumber;
        _securityQuestion = result.securityQuestion;
        _step = 2;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      final message = e.message.toLowerCase().contains('sms')
          ? l10n.smsRecoveryComingSoon
          : e.message;
      showAuthSnackBar(context, message, success: false);
    } catch (e) {
      if (mounted) showAuthSnackBar(context, e.toString(), success: false);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final ds = ref.read(authRemoteDataSourceProvider);
      await ds.resetPassword(
        ResetPasswordRequest(
          phoneNumber: _normalizedPhone!,
          securityAnswer: _answerController.text.trim(),
          newPassword: _passwordController.text,
        ),
      );
      if (!mounted) return;
      showAuthSnackBar(context, l10n.passwordResetSuccess);
      context.go('/signin');
    } catch (e) {
      if (mounted) showAuthSnackBar(context, e.toString(), success: false);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AuthScreenShell(
      gradientColors: AuthBrand.signInGradient,
      title: l10n.forgotPasswordTitle,
      subtitle: _step == 1
          ? l10n.forgotPasswordSubtitle
          : (_securityQuestion ?? l10n.securityQuestion),
      showBackButton: true,
      onBack: () {
        if (_step == 2) {
          setState(() => _step = 1);
        } else {
          context.pop();
        }
      },
      formChild: Form(
        key: _formKey,
        child: _step == 1 ? _buildStepOne(l10n) : _buildStepTwo(l10n),
      ),
    );
  }

  Widget _buildStepOne(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTextField(
          controller: _phoneController,
          label: l10n.phoneNumber,
          hint: l10n.phoneNumberHint,
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _fetchQuestion(),
          validator: (value) => _phoneError(value, l10n),
        ),
        const SizedBox(height: 26),
        AuthPrimaryButton(
          label: l10n.continueLabel,
          isLoading: _isLoading,
          onPressed: _fetchQuestion,
        ),
      ],
    );
  }

  Widget _buildStepTwo(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AuthBrand.purple.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            _securityQuestion ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AuthBrand.ink,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(height: 18),
        AuthTextField(
          controller: _answerController,
          label: l10n.securityAnswer,
          hint: l10n.securityAnswerHint,
          icon: Icons.shield_outlined,
          obscureText: _obscureAnswer,
          textInputAction: TextInputAction.next,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureAnswer
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AuthBrand.inkMuted,
            ),
            onPressed: () => setState(() => _obscureAnswer = !_obscureAnswer),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.securityAnswerRequired;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: _passwordController,
          label: l10n.newPassword,
          hint: l10n.newPasswordHint,
          icon: Icons.lock_outline_rounded,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.next,
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
            if (value == null || value.length < 6) return l10n.newPasswordHint;
            return null;
          },
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: _confirmController,
          label: l10n.confirmPassword,
          hint: l10n.confirmPasswordHint,
          icon: Icons.verified_user_outlined,
          obscureText: _obscureConfirm,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _resetPassword(),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirm
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AuthBrand.inkMuted,
            ),
            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
          validator: (value) {
            if (value != _passwordController.text) {
              return l10n.confirmPasswordHint;
            }
            return null;
          },
        ),
        const SizedBox(height: 26),
        AuthPrimaryButton(
          label: l10n.resetPassword,
          isLoading: _isLoading,
          onPressed: _resetPassword,
        ),
      ],
    );
  }
}
