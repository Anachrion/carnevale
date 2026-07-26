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
                        _UsernameEditor(
                          key: ValueKey(user.username),
                          initialUsername: user.username,
                        ),
                        const SizedBox(height: 12),
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
                        GlassActionButton(
                          icon: Icons.vpn_key_outlined,
                          label: l10n.authResetPassword,
                          color: AppPalette.toggleBlue,
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

/// Inline editor for the account username: a text field pre-filled with the current name that saves
/// on submit and surfaces validation errors from the server.
class _UsernameEditor extends StatefulWidget {
  const _UsernameEditor({super.key, required this.initialUsername});

  final String initialUsername;

  @override
  State<_UsernameEditor> createState() => _UsernameEditorState();
}

class _UsernameEditorState extends State<_UsernameEditor> {
  late final _controller = TextEditingController(text: widget.initialUsername);
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _changed {
    final trimmed = _controller.text.trim();
    return trimmed.isNotEmpty && trimmed != widget.initialUsername;
  }

  Future<void> _save() async {
    if (!_changed) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await authService.updateUsername(_controller.text.trim());
      if (mounted) showAppToast(context, AppLocalizations.of(context).toastUsernameUpdated);
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingRow(
          label: AppLocalizations.of(context).settingsSignedInAs,
          child: SizedBox(
            width: 170,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 22,
                    child: TextField(
                      controller: _controller,
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (_) => _save(),
                      textAlign: TextAlign.right,
                      textAlignVertical: TextAlignVertical.center,
                      style: GoogleFonts.cinzel(
                        color: context.textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      decoration: const InputDecoration(
                        isCollapsed: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                if (_saving) ...[
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.accentColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              _error!,
              style: TextStyle(color: context.dangerColor, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
