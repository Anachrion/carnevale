// Copyright 2026 Anachrion
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
                style: GoogleFonts.notoSans(
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
              style: GoogleFonts.notoSans(
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
              style: GoogleFonts.notoSans(
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
                    style: GoogleFonts.notoSans(
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
                style: GoogleFonts.notoSans(
                  color: context.textColor,
                  fontSize: 15,
                ),
                decoration: goldInputDecoration(
                  context,
                  label: l10n.fieldConfirmPassword,
                ),
                validator: (v) {
                  if (v != _passwordController.text)
                    return l10n.validationPasswordMismatch;
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
                    style: GoogleFonts.notoSans(
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
    return AlertDialog(
      title: Text(
        l10n.authResetPassword,
        style: GoogleFonts.cinzel(color: context.textColor),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.authResetPasswordBlurb,
              style: GoogleFonts.notoSans(
                fontSize: 13,
                color: context.subtleTextColor,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _send(),
              style: GoogleFonts.notoSans(
                color: context.textColor,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                labelText: l10n.fieldEmail,
                labelStyle: GoogleFonts.notoSans(
                  color: context.subtleTextColor,
                  fontSize: 13,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: context.accentColor.withValues(alpha: 0.5),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: context.accentColor,
                    width: 1.5,
                  ),
                ),
              ),
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
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _sending ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.actionCancel),
        ),
        TextButton(
          onPressed: _sending ? null : _send,
          child: _sending
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  l10n.actionSend,
                  style: TextStyle(
                    color: context.accentColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ],
    );
  }
}
