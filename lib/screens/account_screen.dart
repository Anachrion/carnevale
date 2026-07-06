import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      title: 'Account',
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
    showAppToast(context, 'Logged out');
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
                  : const Text('Log Out'),
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
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }
      if (!mounted) return;
      showAppToast(
        context,
        _isSignUp ? 'Account created!' : 'Logged in successfully!',
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
    showDialog(
      context: context,
      builder: (_) =>
          _ForgotPasswordDialog(initialEmail: _emailController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isSignUp ? 'Sign Up' : 'Log In',
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
                decoration: goldInputDecoration(context, label: 'Username'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
            ],
            TextFormField(
              controller: _emailController,
              focusNode: _emailFocus,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
              style: GoogleFonts.notoSans(
                color: context.textColor,
                fontSize: 15,
              ),
              decoration: goldInputDecoration(context, label: 'Email'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (!v.contains('@')) return 'Enter a valid email';
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
              decoration: goldInputDecoration(context, label: 'Password'),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                if (_isSignUp && v.length < 6) return 'At least 6 characters';
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
                    'Forgot password?',
                    style: GoogleFonts.notoSans(
                      fontSize: 13,
                      color: AppPalette.gold,
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
                  label: 'Confirm Password',
                ),
                validator: (v) {
                  if (v != _passwordController.text)
                    return 'Passwords do not match';
                  return null;
                },
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(
                _error!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
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
                    : Text(_isSignUp ? 'Sign Up' : 'Log In'),
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
                            ? 'Already have an account? '
                            : "Don't have an account yet? ",
                      ),
                      TextSpan(
                        text: _isSignUp ? 'Log In' : 'Sign Up',
                        style: TextStyle(
                          color: AppPalette.gold,
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
      showAppToast(context, 'Password reset email sent!');
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Reset Password',
        style: GoogleFonts.cinzel(color: context.textColor),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter your email and we'll send you a link to reset your password.",
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
                labelText: 'Email',
                labelStyle: GoogleFonts.notoSans(
                  color: context.subtleTextColor,
                  fontSize: 13,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppPalette.gold.withValues(alpha: 0.5),
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppPalette.gold, width: 1.5),
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _sending ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
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
                  'Send',
                  style: TextStyle(
                    color: AppPalette.gold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ],
    );
  }
}
