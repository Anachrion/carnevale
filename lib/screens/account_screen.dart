// Carnevale Companion
// Copyright (C) 2026 Anachrion and contributors
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
// details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/auth_service.dart';
import '../widgets/app_background.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_input.dart';
import '../widgets/app_toast.dart';
import '../widgets/glass_panel.dart';
import '../widgets/screen_header.dart';
import 'home_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    authService.addListener(_rebuild);
  }

  @override
  void dispose() {
    authService.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppPalette.background,
      drawer: const AppDrawer(current: AppDrawerRoute.account),
      body: AppBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                children: [
                  authService.isLoggedIn
                      ? _LoggedInPanel(user: authService.currentUser!)
                      : const _AuthForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ScreenHeader(
      title: AppLocalizations.of(context).accountTitle,
      onMenu: () => _scaffoldKey.currentState?.openDrawer(),
    );
  }
}

class _LoggedInPanel extends StatefulWidget {
  const _LoggedInPanel({required this.user});
  final AuthUser user;

  @override
  State<_LoggedInPanel> createState() => _LoggedInPanelState();
}

class _LoggedInPanelState extends State<_LoggedInPanel> {
  bool _loggingOut = false;

  Future<void> _logOut() async {
    setState(() => _loggingOut = true);
    await authService.logOut();
    if (!mounted) return;
    setState(() => _loggingOut = false);
    showAppToast(context, AppLocalizations.of(context).toastLoggedOut);
  }

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.user.username,
            style: GoogleFonts.cinzel(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: context.textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.user.email,
            style: TextStyle(fontSize: 13, color: context.subtleTextColor),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loggingOut ? null : _logOut,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _loggingOut
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(AppLocalizations.of(context).actionLogOut),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthForm extends StatefulWidget {
  const _AuthForm();

  @override
  State<_AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<_AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _usernameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _passwordConfirmationFocus = FocusNode();

  bool _isSignUp = false;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    _usernameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _passwordConfirmationFocus.dispose();
    super.dispose();
  }

  void _switchMode(bool signUp) {
    setState(() {
      _isSignUp = signUp;
      _error = null;
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      if (_isSignUp) {
        await authService.signUp(
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          passwordConfirmation: _passwordConfirmationController.text,
        );
      } else {
        await authService.logIn(
          login: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      showAppToast(
        context,
        _isSignUp ? l10n.toastAccountCreated : l10n.toastLoggedIn,
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showForgotPasswordDialog(BuildContext context) {
    // The login field now also accepts a username, which isn't a valid reset-password target —
    // only carry it over as a prefill when it actually looks like an email.
    final typed = _emailController.text.trim();
    showDialog(
      context: context,
      builder: (_) => _ForgotPasswordDialog(
        initialEmail: typed.contains('@') ? typed : '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GlassPanel(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isSignUp ? l10n.actionSignUp : l10n.actionLogIn,
              style: GoogleFonts.cinzel(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: context.textColor,
              ),
            ),
            const SizedBox(height: 20),
            if (_isSignUp) ...[
              TextFormField(
                controller: _usernameController,
                focusNode: _usernameFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _emailFocus.requestFocus(),
                style: GoogleFonts.ebGaramond(
                  color: context.textColor,
                  fontSize: 15,
                ),
                decoration: goldInputDecoration(context, label: l10n.fieldUsername),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.validationRequired : null,
              ),
              const SizedBox(height: 16),
            ],
            TextFormField(
              controller: _emailController,
              focusNode: _emailFocus,
              keyboardType: _isSignUp
                  ? TextInputType.emailAddress
                  : TextInputType.text,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
              style: GoogleFonts.ebGaramond(
                color: context.textColor,
                fontSize: 15,
              ),
              decoration: goldInputDecoration(
                context,
                label: _isSignUp ? l10n.fieldEmail : l10n.fieldEmailOrUsername,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l10n.validationRequired;
                if (_isSignUp && !v.contains('@')) return l10n.validationEmailInvalid;
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              focusNode: _passwordFocus,
              obscureText: true,
              textInputAction: _isSignUp
                  ? TextInputAction.next
                  : TextInputAction.done,
              onFieldSubmitted: (_) => _isSignUp
                  ? _passwordConfirmationFocus.requestFocus()
                  : _submit(),
              style: GoogleFonts.ebGaramond(
                color: context.textColor,
                fontSize: 15,
              ),
              decoration: goldInputDecoration(context, label: l10n.fieldPassword),
              validator: (v) {
                if (v == null || v.isEmpty) return l10n.validationRequired;
                if (_isSignUp && v.length < 6) return l10n.validationPasswordTooShort;
                return null;
              },
            ),
            if (!_isSignUp) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => _showForgotPasswordDialog(context),
                  child: Text(
                    l10n.authForgotPassword,
                    style: GoogleFonts.ebGaramond(
                      fontSize: 13,
                      color: context.accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
            if (_isSignUp) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordConfirmationController,
                focusNode: _passwordConfirmationFocus,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                style: GoogleFonts.ebGaramond(
                  color: context.textColor,
                  fontSize: 15,
                ),
                decoration: goldInputDecoration(
                  context,
                  label: l10n.fieldConfirmPassword,
                ),
                validator: (v) {
                  if (v != _passwordController.text) {
                    return l10n.validationPasswordMismatch;
                  }
                  return null;
                },
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(
                _error!,
                style: TextStyle(color: context.dangerColor, fontSize: 13),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(_isSignUp ? l10n.actionSignUp : l10n.actionLogIn),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () => _switchMode(!_isSignUp),
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.ebGaramond(
                      fontSize: 13,
                      color: context.subtleTextColor,
                    ),
                    children: [
                      TextSpan(
                        text: _isSignUp
                            ? l10n.authHaveAccount
                            : l10n.authNoAccount,
                      ),
                      TextSpan(
                        text: _isSignUp ? l10n.actionLogIn : l10n.actionSignUp,
                        style: TextStyle(
                          color: context.accentColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForgotPasswordDialog extends StatefulWidget {
  const _ForgotPasswordDialog({required this.initialEmail});
  final String initialEmail;

  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _emailController = TextEditingController(
    text: widget.initialEmail,
  );
  bool _sending = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      await authService.forgotPassword(_emailController.text.trim());
      if (!mounted) return;
      Navigator.of(context).pop();
      showAppToast(context, AppLocalizations.of(context).toastResetEmailSent);
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Frosted glass surface matching the Settings "About" popup (see _AboutDialog): a transparent
    // Dialog wrapping a width-capped GlassPanel, rather than a stock Material AlertDialog.
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: GlassPanel(
          opaque: true,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.authResetPassword,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: context.textColor,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.authResetPasswordBlurb,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ebGaramond(
                    fontSize: 13,
                    color: context.subtleTextColor,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _send(),
                  style: GoogleFonts.ebGaramond(
                    color: context.textColor,
                    fontSize: 16,
                  ),
                  decoration: goldInputDecoration(context, label: l10n.fieldEmail),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return l10n.validationRequired;
                    if (!v.contains('@')) return l10n.validationEmailInvalid;
                    return null;
                  },
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    style: TextStyle(color: context.dangerColor, fontSize: 13),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _sending ? null : () => Navigator.of(context).pop(),
                      child: Text(
                        l10n.actionCancel,
                        style: GoogleFonts.cinzel(
                          color: context.subtleTextColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: _sending ? null : _send,
                      child: _sending
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: context.accentColor,
                              ),
                            )
                          : Text(
                              l10n.actionSend,
                              style: GoogleFonts.cinzel(
                                color: context.accentColor,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
