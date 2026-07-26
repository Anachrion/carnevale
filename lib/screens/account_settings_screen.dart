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
import '../widgets/app_toast.dart';
import '../widgets/glass_panel.dart';
import '../widgets/screen_header.dart';
import '../widgets/settings_controls.dart';

/// A pushed sub-page (reached from Settings → Account) that groups everything about managing the
/// signed-in account: editing the username, viewing the email, requesting a password reset, and
/// logging out. Auth itself (the login/sign-up form) still lives on [AccountScreen]; this page
/// assumes a user is already signed in and pops back to Settings if that stops being true.
class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool _loggingOut = false;
  bool _sendingReset = false;

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

  void _rebuild() {
    if (mounted) setState(() {});
  }

  Future<void> _logOut() async {
    setState(() => _loggingOut = true);
    await authService.logOut();
    if (!mounted) return;
    // Nothing left to manage once signed out. Toast first (it lives in the root overlay, so it
    // survives the pop), then return to Settings.
    showAppToast(context, AppLocalizations.of(context).toastLoggedOut);
    Navigator.of(context).pop();
  }

  void _showChangeUsernameDialog(String currentUsername) {
    // The screen already listens to authService, so a successful change rebuilds the username row
    // here on its own — the dialog just needs to fire the update and close.
    showDialog<void>(
      context: context,
      builder: (_) => _ChangeUsernameDialog(currentUsername: currentUsername),
    );
  }

  Future<void> _sendResetEmail(String email) async {
    setState(() => _sendingReset = true);
    try {
      await authService.forgotPassword(email);
      if (mounted) showAppToast(context, AppLocalizations.of(context).toastResetEmailSent);
    } on AuthException catch (e) {
      if (mounted) showAppToast(context, e.message);
    } finally {
      if (mounted) setState(() => _sendingReset = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = authService.currentUser;
    return Scaffold(
      backgroundColor: AppPalette.background,
      body: AppBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScreenHeader(
              title: l10n.accountTitle,
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              // Defensive: if the session ends while this page is open (e.g. token expiry), there is
              // nothing to manage — show a spinner for the frame before the pop lands.
              child: user == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                      children: [
                        SettingRow(
                          label: l10n.fieldEmail,
                          child: Text(
                            user.email,
                            style: GoogleFonts.cinzel(
                              color: context.textColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SettingRow(
                          label: l10n.settingsSignedInAs,
                          child: Text(
                            user.username,
                            style: GoogleFonts.cinzel(
                              color: context.textColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GlassActionButton(
                          icon: Icons.badge_outlined,
                          label: l10n.settingsChangeUsername,
                          color: AppPalette.toggleBlue,
                          onPressed: () => _showChangeUsernameDialog(user.username),
                        ),
                        const SizedBox(height: 12),
                        GlassActionButton(
                          icon: Icons.vpn_key_outlined,
                          label: l10n.authResetPassword,
                          color: AppPalette.tokenAmethyst,
                          onPressed: _sendingReset ? null : () => _sendResetEmail(user.email),
                          loading: _sendingReset,
                        ),
                        const SizedBox(height: 12),
                        GlassActionButton(
                          icon: Icons.logout,
                          label: l10n.actionLogOut,
                          color: context.accentColor,
                          tintColor: AppPalette.red,
                          onPressed: _loggingOut ? null : _logOut,
                          loading: _loggingOut,
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Popup for changing the account username: a single text field pre-filled with the current name,
/// with Cancel/Save actions. Saving updates the account and surfaces validation errors from the
/// server inline; on success it pops and the parent screen's authService listener refreshes the
/// displayed name. Mirrors the reset-password dialog it sits beside on this screen.
class _ChangeUsernameDialog extends StatefulWidget {
  const _ChangeUsernameDialog({required this.currentUsername});

  final String currentUsername;

  @override
  State<_ChangeUsernameDialog> createState() => _ChangeUsernameDialogState();
}

class _ChangeUsernameDialogState extends State<_ChangeUsernameDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _controller = TextEditingController(text: widget.currentUsername);
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final next = _controller.text.trim();
    // Nothing to do if the name is unchanged — just close rather than hitting the server.
    if (next == widget.currentUsername) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await authService.updateUsername(next);
      if (!mounted) return;
      Navigator.of(context).pop();
      showAppToast(context, AppLocalizations.of(context).toastUsernameUpdated);
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
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
                  l10n.settingsChangeUsername,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: context.textColor,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _controller,
                  autofocus: true,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _save(),
                  style: GoogleFonts.ebGaramond(
                    color: context.textColor,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.fieldUsername,
                    labelStyle: GoogleFonts.cinzel(
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
                    if (v == null || v.trim().isEmpty) {
                      return l10n.validationRequired;
                    }
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
                      onPressed: _saving ? null : () => Navigator.of(context).pop(),
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
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: context.accentColor,
                              ),
                            )
                          : Text(
                              l10n.actionSave,
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
