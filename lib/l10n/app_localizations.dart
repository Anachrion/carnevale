import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// AppBar title of the settings screen; also the Settings nav entry
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeMode;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE'**
  String get settingsAppearance;

  /// No description provided for @settingsCardImages.
  ///
  /// In en, this message translates to:
  /// **'CARD IMAGES'**
  String get settingsCardImages;

  /// No description provided for @settingsPrinting.
  ///
  /// In en, this message translates to:
  /// **'PRINTING'**
  String get settingsPrinting;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get settingsAccount;

  /// No description provided for @settingsCardFlip.
  ///
  /// In en, this message translates to:
  /// **'Card flip'**
  String get settingsCardFlip;

  /// No description provided for @settingsCardFlipFlip.
  ///
  /// In en, this message translates to:
  /// **'Flip'**
  String get settingsCardFlipFlip;

  /// No description provided for @settingsCardFlipSwipe.
  ///
  /// In en, this message translates to:
  /// **'Swipe'**
  String get settingsCardFlipSwipe;

  /// No description provided for @settingsBothFaces.
  ///
  /// In en, this message translates to:
  /// **'Both faces (landscape)'**
  String get settingsBothFaces;

  /// No description provided for @settingsOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get settingsOn;

  /// No description provided for @settingsOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get settingsOff;

  /// No description provided for @settingsDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get settingsDownload;

  /// No description provided for @settingsDownloadOnDemand.
  ///
  /// In en, this message translates to:
  /// **'On demand'**
  String get settingsDownloadOnDemand;

  /// No description provided for @settingsDownloadAlways.
  ///
  /// In en, this message translates to:
  /// **'Always'**
  String get settingsDownloadAlways;

  /// No description provided for @settingsDownloadWifiOnly.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi only'**
  String get settingsDownloadWifiOnly;

  /// No description provided for @settingsNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get settingsNotLoggedIn;

  /// No description provided for @settingsSignedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as'**
  String get settingsSignedInAs;

  /// No description provided for @settingsChangeUsername.
  ///
  /// In en, this message translates to:
  /// **'Change username'**
  String get settingsChangeUsername;

  /// No description provided for @settingsSyncBlurb.
  ///
  /// In en, this message translates to:
  /// **'Download any card images that are missing or out of date on this device.'**
  String get settingsSyncBlurb;

  /// No description provided for @settingsSyncCards.
  ///
  /// In en, this message translates to:
  /// **'Sync Cards'**
  String get settingsSyncCards;

  /// No description provided for @settingsSyncCardsWithCount.
  ///
  /// In en, this message translates to:
  /// **'Sync Cards ({details})'**
  String settingsSyncCardsWithCount(String details);

  /// No description provided for @settingsSyncChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking for updates…'**
  String get settingsSyncChecking;

  /// No description provided for @settingsSyncDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading {done} / {total}'**
  String settingsSyncDownloading(int done, int total);

  /// No description provided for @settingsPrintBlurb.
  ///
  /// In en, this message translates to:
  /// **'Print-ready card sheets, one PDF per faction, updated whenever the cards change.'**
  String get settingsPrintBlurb;

  /// Button opening the backend's /cards page in a browser to download printable sheets
  ///
  /// In en, this message translates to:
  /// **'Card Sheets (PDF)'**
  String get settingsPrintButton;

  /// No description provided for @settingsSyncUpToDate.
  ///
  /// In en, this message translates to:
  /// **'All cards are already up to date'**
  String get settingsSyncUpToDate;

  /// No description provided for @settingsSyncedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Synced 1 card image} other{Synced {count} card images}}'**
  String settingsSyncedCount(int count);

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get settingsAbout;

  /// No description provided for @settingsAboutButton.
  ///
  /// In en, this message translates to:
  /// **'About Carnevale'**
  String get settingsAboutButton;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'An unofficial, fan-made companion app for tabletop play.'**
  String get aboutDescription;

  /// No description provided for @aboutCredits.
  ///
  /// In en, this message translates to:
  /// **'Created by Anachrion and Eldrim.'**
  String get aboutCredits;

  /// No description provided for @aboutSourceHeading.
  ///
  /// In en, this message translates to:
  /// **'Source code'**
  String get aboutSourceHeading;

  /// No description provided for @aboutSourceApp.
  ///
  /// In en, this message translates to:
  /// **'App (Flutter)'**
  String get aboutSourceApp;

  /// No description provided for @aboutSourceServer.
  ///
  /// In en, this message translates to:
  /// **'Server (Rails)'**
  String get aboutSourceServer;

  /// No description provided for @aboutLegalHeading.
  ///
  /// In en, this message translates to:
  /// **'Privacy & data'**
  String get aboutLegalHeading;

  /// No description provided for @aboutPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get aboutPrivacyPolicy;

  /// No description provided for @aboutAccountDeletion.
  ///
  /// In en, this message translates to:
  /// **'Delete your account'**
  String get aboutAccountDeletion;

  /// No description provided for @aboutViewLicenses.
  ///
  /// In en, this message translates to:
  /// **'View Licenses'**
  String get aboutViewLicenses;

  /// No description provided for @aboutLegalese.
  ///
  /// In en, this message translates to:
  /// **'Carnevale is a tabletop miniatures game created and published by TT Combat, which owns all associated intellectual property, including the Carnevale name, artwork, and trademarks. We claim no ownership of it. This is an independent, fan-made companion app — not an official product. It is not affiliated with or endorsed by TT Combat, and is used with their kind permission; it is provided free of charge and is never sold. All names, trademarks, and artwork remain the property of TT Combat and their respective owners.\n\n© 2026 Anachrion & Eldrim. Licensed under the GNU Affero General Public License, version 3 or later.'**
  String get aboutLegalese;

  /// No description provided for @toastUsernameUpdated.
  ///
  /// In en, this message translates to:
  /// **'Username updated!'**
  String get toastUsernameUpdated;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get actionGotIt;

  /// No description provided for @actionLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get actionLogOut;

  /// No description provided for @actionLogIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get actionLogIn;

  /// No description provided for @actionSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get actionSignUp;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get actionSend;

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get actionRemove;

  /// No description provided for @actionJoin.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get actionJoin;

  /// No description provided for @actionSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get actionSelect;

  /// No description provided for @actionDeselect.
  ///
  /// In en, this message translates to:
  /// **'Deselect'**
  String get actionDeselect;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navCards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get navCards;

  /// No description provided for @navGangs.
  ///
  /// In en, this message translates to:
  /// **'Gangs'**
  String get navGangs;

  /// No description provided for @navGames.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get navGames;

  /// No description provided for @navRules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get navRules;

  /// No description provided for @fieldUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get fieldUsername;

  /// No description provided for @fieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get fieldEmail;

  /// Label of the sign-in identifier field, which accepts either an email or a username (sign-up still asks for an email specifically and uses fieldEmail)
  ///
  /// In en, this message translates to:
  /// **'Email or Username'**
  String get fieldEmailOrUsername;

  /// No description provided for @fieldPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get fieldPassword;

  /// No description provided for @fieldConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get fieldConfirmPassword;

  /// No description provided for @fieldNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get fieldNewPassword;

  /// No description provided for @fieldConfirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get fieldConfirmNewPassword;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get validationRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get validationPasswordTooShort;

  /// No description provided for @validationPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordMismatch;

  /// No description provided for @errorCouldNotReachServer.
  ///
  /// In en, this message translates to:
  /// **'Could not reach server'**
  String get errorCouldNotReachServer;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @toastLoggedOut.
  ///
  /// In en, this message translates to:
  /// **'Logged out'**
  String get toastLoggedOut;

  /// No description provided for @toastLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Logged in successfully!'**
  String get toastLoggedIn;

  /// No description provided for @toastAccountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created!'**
  String get toastAccountCreated;

  /// No description provided for @toastResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent!'**
  String get toastResetEmailSent;

  /// No description provided for @toastPasswordReset.
  ///
  /// In en, this message translates to:
  /// **'Password reset! Please log in.'**
  String get toastPasswordReset;

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountTitle;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authResetPassword;

  /// No description provided for @authResetPasswordBlurb.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a link to reset your password.'**
  String get authResetPasswordBlurb;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get authHaveAccount;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account yet? '**
  String get authNoAccount;

  /// No description provided for @resetPasswordBlurb.
  ///
  /// In en, this message translates to:
  /// **'Choose a new password for your account.'**
  String get resetPasswordBlurb;

  /// No description provided for @drawerDarkTheme.
  ///
  /// In en, this message translates to:
  /// **'DARK THEME'**
  String get drawerDarkTheme;

  /// No description provided for @drawerLightTheme.
  ///
  /// In en, this message translates to:
  /// **'LIGHT THEME'**
  String get drawerLightTheme;

  /// No description provided for @deleteGangConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String deleteGangConfirm(String name);

  /// No description provided for @gangModelCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No models} =1{1 model} other{{count} models}}'**
  String gangModelCount(int count);

  /// No description provided for @ducatsAmount.
  ///
  /// In en, this message translates to:
  /// **'{count} ducats'**
  String ducatsAmount(int count);

  /// No description provided for @attackerDefender.
  ///
  /// In en, this message translates to:
  /// **'Attacker/Defender'**
  String get attackerDefender;

  /// No description provided for @roleAttacker.
  ///
  /// In en, this message translates to:
  /// **'Attacker'**
  String get roleAttacker;

  /// No description provided for @roleDefender.
  ///
  /// In en, this message translates to:
  /// **'Defender'**
  String get roleDefender;

  /// No description provided for @youCap.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get youCap;

  /// No description provided for @youLower.
  ///
  /// In en, this message translates to:
  /// **'you'**
  String get youLower;

  /// No description provided for @opponentLabel.
  ///
  /// In en, this message translates to:
  /// **'Opponent'**
  String get opponentLabel;

  /// No description provided for @agendaRuleCycle.
  ///
  /// In en, this message translates to:
  /// **'Cycle'**
  String get agendaRuleCycle;

  /// No description provided for @agendaRuleSecondary.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get agendaRuleSecondary;

  /// No description provided for @agendaRuleDouble.
  ///
  /// In en, this message translates to:
  /// **'Double'**
  String get agendaRuleDouble;

  /// No description provided for @agendaRuleSecret.
  ///
  /// In en, this message translates to:
  /// **'Secret'**
  String get agendaRuleSecret;

  /// No description provided for @agendaRuleTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get agendaRuleTotal;

  /// No description provided for @agendaRuleCycleDesc.
  ///
  /// In en, this message translates to:
  /// **'Scoring an agenda immediately draws a replacement.'**
  String get agendaRuleCycleDesc;

  /// No description provided for @agendaRuleSecondaryDesc.
  ///
  /// In en, this message translates to:
  /// **'You must achieve at least one agenda to score any Victory Points from any source.'**
  String get agendaRuleSecondaryDesc;

  /// No description provided for @agendaRuleDoubleDesc.
  ///
  /// In en, this message translates to:
  /// **'On achieving an agenda you may keep it in play; achieving it again scores double, otherwise nothing.'**
  String get agendaRuleDoubleDesc;

  /// No description provided for @agendaRuleSecretDesc.
  ///
  /// In en, this message translates to:
  /// **'Keep your agendas secret from your opponent until achieved. Without this rule, all players can see each other\'s agendas.'**
  String get agendaRuleSecretDesc;

  /// No description provided for @agendaRuleTotalDesc.
  ///
  /// In en, this message translates to:
  /// **'You must achieve all of your agendas to score their Victory Points.'**
  String get agendaRuleTotalDesc;

  /// No description provided for @gamesTabActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get gamesTabActive;

  /// No description provided for @gamesTabArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get gamesTabArchived;

  /// No description provided for @gamesLoginPrompt.
  ///
  /// In en, this message translates to:
  /// **'Log in to create or join a game'**
  String get gamesLoginPrompt;

  /// No description provided for @gamesEmptyActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'No games yet'**
  String get gamesEmptyActiveTitle;

  /// No description provided for @gamesEmptyActiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a game or join one with a code'**
  String get gamesEmptyActiveSubtitle;

  /// No description provided for @gamesEmptyArchivedTitle.
  ///
  /// In en, this message translates to:
  /// **'No archived games'**
  String get gamesEmptyArchivedTitle;

  /// No description provided for @gamesEmptyArchivedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Games you archive will show up here'**
  String get gamesEmptyArchivedSubtitle;

  /// No description provided for @toastGameArchived.
  ///
  /// In en, this message translates to:
  /// **'Game archived'**
  String get toastGameArchived;

  /// No description provided for @toastGameArchiveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not archive this game'**
  String get toastGameArchiveFailed;

  /// No description provided for @toastGameRestored.
  ///
  /// In en, this message translates to:
  /// **'Game restored'**
  String get toastGameRestored;

  /// No description provided for @toastGameRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not restore this game'**
  String get toastGameRestoreFailed;

  /// No description provided for @toastGameDeleted.
  ///
  /// In en, this message translates to:
  /// **'Game deleted'**
  String get toastGameDeleted;

  /// No description provided for @toastGameDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete this game'**
  String get toastGameDeleteFailed;

  /// No description provided for @gameStatusCodeLine.
  ///
  /// In en, this message translates to:
  /// **'{status} · Code {code}'**
  String gameStatusCodeLine(String status, String code);

  /// No description provided for @gameVersus.
  ///
  /// In en, this message translates to:
  /// **'{p1} vs {p2}'**
  String gameVersus(String p1, String p2);

  /// No description provided for @gameWaitingForOpponentInline.
  ///
  /// In en, this message translates to:
  /// **'waiting for an opponent'**
  String get gameWaitingForOpponentInline;

  /// No description provided for @tooltipDeleteGame.
  ///
  /// In en, this message translates to:
  /// **'Delete game'**
  String get tooltipDeleteGame;

  /// No description provided for @tooltipRestoreGame.
  ///
  /// In en, this message translates to:
  /// **'Restore game'**
  String get tooltipRestoreGame;

  /// No description provided for @tooltipArchiveGame.
  ///
  /// In en, this message translates to:
  /// **'Archive game'**
  String get tooltipArchiveGame;

  /// No description provided for @tooltipOpenGame.
  ///
  /// In en, this message translates to:
  /// **'Open game'**
  String get tooltipOpenGame;

  /// No description provided for @gameDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Game'**
  String get gameDeleteTitle;

  /// No description provided for @gameDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Delete this game? You won\'t be able to see it again, even if your opponent still can.'**
  String get gameDeleteBody;

  /// No description provided for @gamePlayerListLine.
  ///
  /// In en, this message translates to:
  /// **'{name}: {gang}'**
  String gamePlayerListLine(String name, String gang);

  /// No description provided for @gameNoGangSelected.
  ///
  /// In en, this message translates to:
  /// **'No gang selected yet'**
  String get gameNoGangSelected;

  /// No description provided for @actionCreateGame.
  ///
  /// In en, this message translates to:
  /// **'Create Game'**
  String get actionCreateGame;

  /// No description provided for @actionJoinGame.
  ///
  /// In en, this message translates to:
  /// **'Join Game'**
  String get actionJoinGame;

  /// No description provided for @gameNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New Game'**
  String get gameNewTitle;

  /// No description provided for @gameLoadScenariosFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load scenarios'**
  String get gameLoadScenariosFailed;

  /// No description provided for @gameScenarioLabel.
  ///
  /// In en, this message translates to:
  /// **'Scenario'**
  String get gameScenarioLabel;

  /// No description provided for @gameNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Game name (optional)'**
  String get gameNameOptional;

  /// No description provided for @gameDucatLimit.
  ///
  /// In en, this message translates to:
  /// **'Ducat limit'**
  String get gameDucatLimit;

  /// No description provided for @gameBoardSizeOverride.
  ///
  /// In en, this message translates to:
  /// **'Board size (optional override)'**
  String get gameBoardSizeOverride;

  /// No description provided for @gameScenarioMeta.
  ///
  /// In en, this message translates to:
  /// **'{ducats} ducats · {duration}'**
  String gameScenarioMeta(int ducats, String duration);

  /// No description provided for @gameJoinCode.
  ///
  /// In en, this message translates to:
  /// **'Join code'**
  String get gameJoinCode;

  /// No description provided for @gameJoinFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not join — check the code and try again.'**
  String get gameJoinFailed;

  /// No description provided for @toastCouldNotOpenGang.
  ///
  /// In en, this message translates to:
  /// **'Could not open that gang.'**
  String get toastCouldNotOpenGang;

  /// No description provided for @gameFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get gameFallbackTitle;

  /// No description provided for @sessionViewGangs.
  ///
  /// In en, this message translates to:
  /// **'View gangs'**
  String get sessionViewGangs;

  /// No description provided for @sessionMyGang.
  ///
  /// In en, this message translates to:
  /// **'My Gang'**
  String get sessionMyGang;

  /// No description provided for @deployTitle.
  ///
  /// In en, this message translates to:
  /// **'Deploy your gangs'**
  String get deployTitle;

  /// No description provided for @deployBodyWithWinner.
  ///
  /// In en, this message translates to:
  /// **'{name} won the deployment roll-off. Agree on deployment zones and place your miniatures at the table.'**
  String deployBodyWithWinner(String name);

  /// No description provided for @deployBodyNoWinner.
  ///
  /// In en, this message translates to:
  /// **'Agree on deployment zones and place your miniatures at the table.'**
  String get deployBodyNoWinner;

  /// No description provided for @toastSessionLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load this game.'**
  String get toastSessionLoadFailed;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session expired. Please log in again.'**
  String get sessionExpired;

  /// No description provided for @lobbyTitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting for an opponent'**
  String get lobbyTitle;

  /// No description provided for @lobbyShareCode.
  ///
  /// In en, this message translates to:
  /// **'Share this code with the other player:'**
  String get lobbyShareCode;

  /// No description provided for @toastJoinCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Join code copied'**
  String get toastJoinCodeCopied;

  /// No description provided for @lobbyShareLink.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get lobbyShareLink;

  /// No description provided for @lobbyCopyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get lobbyCopyLink;

  /// No description provided for @lobbyShowQr.
  ///
  /// In en, this message translates to:
  /// **'QR code'**
  String get lobbyShowQr;

  /// No description provided for @lobbyQrTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan to join'**
  String get lobbyQrTitle;

  /// No description provided for @lobbyQrHint.
  ///
  /// In en, this message translates to:
  /// **'Point the other player\'s camera at this code.'**
  String get lobbyQrHint;

  /// No description provided for @lobbyShareMessage.
  ///
  /// In en, this message translates to:
  /// **'Join my Carnevale game: {url}'**
  String lobbyShareMessage(String url);

  /// No description provided for @toastJoinLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get toastJoinLinkCopied;

  /// No description provided for @toastShareFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the share sheet'**
  String get toastShareFailed;

  /// No description provided for @gangExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export gang'**
  String get gangExportTitle;

  /// No description provided for @gangExportCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get gangExportCopy;

  /// No description provided for @gangExportShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get gangExportShare;

  /// No description provided for @gangExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not export this gang'**
  String get gangExportFailed;

  /// No description provided for @toastGangCopied.
  ///
  /// In en, this message translates to:
  /// **'Gang copied'**
  String get toastGangCopied;

  /// No description provided for @gangImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import a gang'**
  String get gangImportTitle;

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan a code'**
  String get scanTitle;

  /// No description provided for @scanHint.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at a Carnevale QR code'**
  String get scanHint;

  /// No description provided for @scanUnrecognised.
  ///
  /// In en, this message translates to:
  /// **'That code is not a Carnevale code'**
  String get scanUnrecognised;

  /// No description provided for @scanNoPermission.
  ///
  /// In en, this message translates to:
  /// **'Camera access is off. Turn it on for Carnevale in your device settings.'**
  String get scanNoPermission;

  /// No description provided for @scanUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This device has no camera to scan with'**
  String get scanUnsupported;

  /// No description provided for @scanCameraFailed.
  ///
  /// In en, this message translates to:
  /// **'The camera could not be started'**
  String get scanCameraFailed;

  /// No description provided for @navScan.
  ///
  /// In en, this message translates to:
  /// **'Scan a code'**
  String get navScan;

  /// No description provided for @gangShowQr.
  ///
  /// In en, this message translates to:
  /// **'QR code'**
  String get gangShowQr;

  /// No description provided for @gangQrTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan to import'**
  String get gangQrTitle;

  /// No description provided for @gangQrTooLong.
  ///
  /// In en, this message translates to:
  /// **'This gang is too long to fit in a readable QR code. Copy the text instead.'**
  String get gangQrTooLong;

  /// No description provided for @gangImportHint.
  ///
  /// In en, this message translates to:
  /// **'Paste an exported gang here'**
  String get gangImportHint;

  /// No description provided for @gangImportPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get gangImportPaste;

  /// No description provided for @gangImportAction.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get gangImportAction;

  /// No description provided for @gangImportEmpty.
  ///
  /// In en, this message translates to:
  /// **'Paste an exported gang first'**
  String get gangImportEmpty;

  /// No description provided for @gangImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not read that text as a gang'**
  String get gangImportFailed;

  /// No description provided for @gangImportSkipped.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 line skipped} other{{count} lines skipped}}'**
  String gangImportSkipped(int count);

  /// No description provided for @toastGangImported.
  ///
  /// In en, this message translates to:
  /// **'Imported {name}'**
  String toastGangImported(String name);

  /// No description provided for @gameShareSetup.
  ///
  /// In en, this message translates to:
  /// **'Share setup'**
  String get gameShareSetup;

  /// No description provided for @gameSetupShareMessage.
  ///
  /// In en, this message translates to:
  /// **'Let\'s play Carnevale: {url}'**
  String gameSetupShareMessage(String url);

  /// No description provided for @toastSetupLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Setup link copied'**
  String get toastSetupLinkCopied;

  /// No description provided for @gameSetupFromLink.
  ///
  /// In en, this message translates to:
  /// **'Settings from a shared link'**
  String get gameSetupFromLink;

  /// No description provided for @rolloffWonTitle.
  ///
  /// In en, this message translates to:
  /// **'You won the roll-off!'**
  String get rolloffWonTitle;

  /// No description provided for @rolloffChooseRole.
  ///
  /// In en, this message translates to:
  /// **'Choose your role:'**
  String get rolloffChooseRole;

  /// No description provided for @rolloffTitle.
  ///
  /// In en, this message translates to:
  /// **'Role roll-off'**
  String get rolloffTitle;

  /// No description provided for @rolloffWaitingForWinner.
  ///
  /// In en, this message translates to:
  /// **'Waiting for {name} to choose a role...'**
  String rolloffWaitingForWinner(String name);

  /// No description provided for @rolloffDetermining.
  ///
  /// In en, this message translates to:
  /// **'Determining who picks a role...'**
  String get rolloffDetermining;

  /// No description provided for @gangPickTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick your gang'**
  String get gangPickTitle;

  /// No description provided for @gangPickDucatLimit.
  ///
  /// In en, this message translates to:
  /// **'Ducat limit: {limit}'**
  String gangPickDucatLimit(int limit);

  /// No description provided for @gangPickNoGangs.
  ///
  /// In en, this message translates to:
  /// **'You have no gangs yet — build one now.'**
  String get gangPickNoGangs;

  /// No description provided for @gangPickBuildNew.
  ///
  /// In en, this message translates to:
  /// **'Build a new gang'**
  String get gangPickBuildNew;

  /// No description provided for @gangPickWaitingOpponent.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the opponent to pick a gang...'**
  String get gangPickWaitingOpponent;

  /// No description provided for @gangOverLimit.
  ///
  /// In en, this message translates to:
  /// **'Over limit'**
  String get gangOverLimit;

  /// No description provided for @actionSetUp.
  ///
  /// In en, this message translates to:
  /// **'Set up'**
  String get actionSetUp;

  /// No description provided for @agendaDealingTitle.
  ///
  /// In en, this message translates to:
  /// **'Dealing your Agendas'**
  String get agendaDealingTitle;

  /// No description provided for @agendaDealingSecret.
  ///
  /// In en, this message translates to:
  /// **'Kept secret from your opponent until achieved (Secret scenario).'**
  String get agendaDealingSecret;

  /// No description provided for @agendaDealingOpen.
  ///
  /// In en, this message translates to:
  /// **'Your opponent can see these — this scenario is not Secret.'**
  String get agendaDealingOpen;

  /// No description provided for @yourSpellsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Spells'**
  String get yourSpellsTitle;

  /// No description provided for @yourSpellsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review each Mage\'s spells before confirming — Ready locks these in together with your Agendas.'**
  String get yourSpellsSubtitle;

  /// No description provided for @spellsNoMentor.
  ///
  /// In en, this message translates to:
  /// **'No mentor chosen yet'**
  String get spellsNoMentor;

  /// No description provided for @spellsKnownCount.
  ///
  /// In en, this message translates to:
  /// **'{known}/{total} spells'**
  String spellsKnownCount(int known, int total);

  /// No description provided for @yourAgendasTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Agendas'**
  String get yourAgendasTitle;

  /// No description provided for @yourAgendasSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Any agenda that is impossible or duplicated can be discarded and redrawn — agree with your opponent that it is unachievable.'**
  String get yourAgendasSubtitle;

  /// No description provided for @agendaConfirmBlurb.
  ///
  /// In en, this message translates to:
  /// **'Confirming locks in your Agendas and your Spells together for the rest of the game.'**
  String get agendaConfirmBlurb;

  /// No description provided for @actionReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get actionReady;

  /// No description provided for @waitingOpponentReady.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the opponent to be ready...'**
  String get waitingOpponentReady;

  /// No description provided for @agendaIndexName.
  ///
  /// In en, this message translates to:
  /// **'{index} - {name}'**
  String agendaIndexName(int index, String name);

  /// No description provided for @agendaUnachievableRedraw.
  ///
  /// In en, this message translates to:
  /// **'Unachievable — redraw'**
  String get agendaUnachievableRedraw;

  /// No description provided for @discardedCount.
  ///
  /// In en, this message translates to:
  /// **'Discarded ({count})'**
  String discardedCount(int count);

  /// No description provided for @mulliganTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard & redraw?'**
  String get mulliganTitle;

  /// No description provided for @mulliganBody.
  ///
  /// In en, this message translates to:
  /// **'Discard \"{name}\" as unachievable and draw a replacement? Your opponent will see this.'**
  String mulliganBody(String name);

  /// No description provided for @actionDiscardRedraw.
  ///
  /// In en, this message translates to:
  /// **'Discard & redraw'**
  String get actionDiscardRedraw;

  /// No description provided for @scoreTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get scoreTabLabel;

  /// No description provided for @tooltipRewindTurn.
  ///
  /// In en, this message translates to:
  /// **'Rewind a turn'**
  String get tooltipRewindTurn;

  /// No description provided for @tooltipAdvanceTurn.
  ///
  /// In en, this message translates to:
  /// **'Advance a turn'**
  String get tooltipAdvanceTurn;

  /// No description provided for @turnOfTurns.
  ///
  /// In en, this message translates to:
  /// **'Turn {current} of {total}'**
  String turnOfTurns(int current, int total);

  /// No description provided for @vpLabel.
  ///
  /// In en, this message translates to:
  /// **'VP'**
  String get vpLabel;

  /// No description provided for @gameEnded.
  ///
  /// In en, this message translates to:
  /// **'You\'ve ended the game.'**
  String get gameEnded;

  /// No description provided for @actionUndoKeepScoring.
  ///
  /// In en, this message translates to:
  /// **'Undo — keep scoring'**
  String get actionUndoKeepScoring;

  /// No description provided for @actionEndGame.
  ///
  /// In en, this message translates to:
  /// **'End game'**
  String get actionEndGame;

  /// No description provided for @actionDraw.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get actionDraw;

  /// No description provided for @agendasNoneInHand.
  ///
  /// In en, this message translates to:
  /// **'No agendas in hand.'**
  String get agendasNoneInHand;

  /// No description provided for @sectionScored.
  ///
  /// In en, this message translates to:
  /// **'Scored'**
  String get sectionScored;

  /// No description provided for @sectionDiscarded.
  ///
  /// In en, this message translates to:
  /// **'Discarded'**
  String get sectionDiscarded;

  /// No description provided for @sectionInHand.
  ///
  /// In en, this message translates to:
  /// **'In hand'**
  String get sectionInHand;

  /// No description provided for @opponentAgendasTitle.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s Agendas'**
  String opponentAgendasTitle(String name);

  /// No description provided for @agendasHiddenSecret.
  ///
  /// In en, this message translates to:
  /// **'Hidden — this scenario has the Secret rule.'**
  String get agendasHiddenSecret;

  /// No description provided for @actionScore.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get actionScore;

  /// No description provided for @actionDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get actionDiscard;

  /// No description provided for @actionLog.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get actionLog;

  /// No description provided for @drawOriginTitle.
  ///
  /// In en, this message translates to:
  /// **'Draw an agenda via…'**
  String get drawOriginTitle;

  /// No description provided for @discardOriginTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard this agenda via…'**
  String get discardOriginTitle;

  /// No description provided for @originUnachievable.
  ///
  /// In en, this message translates to:
  /// **'Unachievable'**
  String get originUnachievable;

  /// No description provided for @originSpecialRule.
  ///
  /// In en, this message translates to:
  /// **'Special Rule'**
  String get originSpecialRule;

  /// No description provided for @originCommandPoint.
  ///
  /// In en, this message translates to:
  /// **'Command Point'**
  String get originCommandPoint;

  /// No description provided for @originLabelUnachievable.
  ///
  /// In en, this message translates to:
  /// **'unachievable'**
  String get originLabelUnachievable;

  /// No description provided for @originLabelSpecialRule.
  ///
  /// In en, this message translates to:
  /// **'special rule'**
  String get originLabelSpecialRule;

  /// No description provided for @originLabelCommandPoint.
  ///
  /// In en, this message translates to:
  /// **'command point'**
  String get originLabelCommandPoint;

  /// No description provided for @logYourLog.
  ///
  /// In en, this message translates to:
  /// **'Your log'**
  String get logYourLog;

  /// No description provided for @logPlayerLog.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s log'**
  String logPlayerLog(String name);

  /// No description provided for @logSecretNote.
  ///
  /// In en, this message translates to:
  /// **'Only resolved agendas are shown (Secret scenario).'**
  String get logSecretNote;

  /// No description provided for @logNoEvents.
  ///
  /// In en, this message translates to:
  /// **'No events yet.'**
  String get logNoEvents;

  /// No description provided for @logTurnHeader.
  ///
  /// In en, this message translates to:
  /// **'TURN {turn}'**
  String logTurnHeader(int turn);

  /// No description provided for @eventScored.
  ///
  /// In en, this message translates to:
  /// **'Scored'**
  String get eventScored;

  /// No description provided for @eventDiscarded.
  ///
  /// In en, this message translates to:
  /// **'Discarded'**
  String get eventDiscarded;

  /// No description provided for @eventDrew.
  ///
  /// In en, this message translates to:
  /// **'Drew'**
  String get eventDrew;

  /// No description provided for @gangsLoginPrompt.
  ///
  /// In en, this message translates to:
  /// **'Log in to build and manage your gangs'**
  String get gangsLoginPrompt;

  /// No description provided for @gangCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 gang} other{{count} gangs}}'**
  String gangCount(int count);

  /// No description provided for @gangDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Gang'**
  String get gangDeleteTitle;

  /// No description provided for @gangsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No gangs yet'**
  String get gangsEmptyTitle;

  /// No description provided for @gangsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap + to create your first gang'**
  String get gangsEmptySubtitle;

  /// No description provided for @gangsRosterNoModels.
  ///
  /// In en, this message translates to:
  /// **'No models hired yet.'**
  String get gangsRosterNoModels;

  /// No description provided for @gangViewerNoModels.
  ///
  /// In en, this message translates to:
  /// **'No models hired.'**
  String get gangViewerNoModels;

  /// No description provided for @gangBuilderNoModels.
  ///
  /// In en, this message translates to:
  /// **'No models hired yet'**
  String get gangBuilderNoModels;

  /// No description provided for @gangCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New Gang'**
  String get gangCreateTitle;

  /// No description provided for @gangNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Gang name'**
  String get gangNameLabel;

  /// No description provided for @gangPointLimit.
  ///
  /// In en, this message translates to:
  /// **'Point limit'**
  String get gangPointLimit;

  /// No description provided for @gangFactionLabel.
  ///
  /// In en, this message translates to:
  /// **'Faction'**
  String get gangFactionLabel;

  /// No description provided for @gangCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create Gang'**
  String get gangCreateButton;

  /// No description provided for @toastActivationFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the activation. Please try again.'**
  String get toastActivationFailed;

  /// No description provided for @toastSpellUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update that spell. Please try again.'**
  String get toastSpellUpdateFailed;

  /// No description provided for @toastRemoveModelFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not remove that model. Please try again.'**
  String get toastRemoveModelFailed;

  /// No description provided for @gangViewerLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load this gang.'**
  String get gangViewerLoadFailed;

  /// No description provided for @labelFactionRule.
  ///
  /// In en, this message translates to:
  /// **'Faction Rule'**
  String get labelFactionRule;

  /// No description provided for @labelSummon.
  ///
  /// In en, this message translates to:
  /// **'Summon'**
  String get labelSummon;

  /// No description provided for @counterStunned.
  ///
  /// In en, this message translates to:
  /// **'Stunned'**
  String get counterStunned;

  /// No description provided for @counterHidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get counterHidden;

  /// No description provided for @counterGuarding.
  ///
  /// In en, this message translates to:
  /// **'Guarding'**
  String get counterGuarding;

  /// No description provided for @counterCarryingObjective.
  ///
  /// In en, this message translates to:
  /// **'Carrying objective'**
  String get counterCarryingObjective;

  /// No description provided for @counterUnderwater.
  ///
  /// In en, this message translates to:
  /// **'Underwater'**
  String get counterUnderwater;

  /// No description provided for @tooltipActivatedThisTurn.
  ///
  /// In en, this message translates to:
  /// **'Activated this turn'**
  String get tooltipActivatedThisTurn;

  /// No description provided for @tooltipMarkActivated.
  ///
  /// In en, this message translates to:
  /// **'Mark as activated'**
  String get tooltipMarkActivated;

  /// No description provided for @tooltipRemoveSummoned.
  ///
  /// In en, this message translates to:
  /// **'Remove this summoned model'**
  String get tooltipRemoveSummoned;

  /// Violent Transformation: swaps a model to its other printed card mid-game.
  ///
  /// In en, this message translates to:
  /// **'Transform into {name}'**
  String tooltipTransformInto(String name);

  /// No description provided for @tooltipEditCounters.
  ///
  /// In en, this message translates to:
  /// **'Edit counters'**
  String get tooltipEditCounters;

  /// No description provided for @transformFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not transform that model. Please try again.'**
  String get transformFailed;

  /// No description provided for @counterToggleFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the counter. Please try again.'**
  String get counterToggleFailed;

  /// No description provided for @counterTapToToggle.
  ///
  /// In en, this message translates to:
  /// **'Tap a counter to toggle it.'**
  String get counterTapToToggle;

  /// No description provided for @tooltipEditModel.
  ///
  /// In en, this message translates to:
  /// **'Edit counters and tokens'**
  String get tooltipEditModel;

  /// No description provided for @actionActivate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get actionActivate;

  /// No description provided for @actionActivated.
  ///
  /// In en, this message translates to:
  /// **'Activated'**
  String get actionActivated;

  /// No description provided for @tokenUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the token. Please try again.'**
  String get tokenUpdateFailed;

  /// No description provided for @tokenTabGeneric.
  ///
  /// In en, this message translates to:
  /// **'Generic'**
  String get tokenTabGeneric;

  /// No description provided for @tokenTabCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get tokenTabCustom;

  /// No description provided for @tokenTabPredefined.
  ///
  /// In en, this message translates to:
  /// **'Predefined'**
  String get tokenTabPredefined;

  /// No description provided for @tokenSectionOnModel.
  ///
  /// In en, this message translates to:
  /// **'On this model'**
  String get tokenSectionOnModel;

  /// No description provided for @tokenSectionNew.
  ///
  /// In en, this message translates to:
  /// **'New token'**
  String get tokenSectionNew;

  /// No description provided for @tokenLabelHint.
  ///
  /// In en, this message translates to:
  /// **'Label — optional'**
  String get tokenLabelHint;

  /// Label for the option that makes a token one you can flip on/off on the card (a recurring effect), rather than only add and remove.
  ///
  /// In en, this message translates to:
  /// **'Toggleable'**
  String get tokenToggleable;

  /// No description provided for @tokenAdd.
  ///
  /// In en, this message translates to:
  /// **'Add token'**
  String get tokenAdd;

  /// No description provided for @tokenNoLabel.
  ///
  /// In en, this message translates to:
  /// **'No label'**
  String get tokenNoLabel;

  /// No description provided for @tokenNoneYet.
  ///
  /// In en, this message translates to:
  /// **'No tokens yet.'**
  String get tokenNoneYet;

  /// No description provided for @tokenLabelTaken.
  ///
  /// In en, this message translates to:
  /// **'Already on this model'**
  String get tokenLabelTaken;

  /// No description provided for @tokenCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get tokenCountLabel;

  /// No description provided for @tokenKindPlain.
  ///
  /// In en, this message translates to:
  /// **'Plain'**
  String get tokenKindPlain;

  /// No description provided for @tokenKindToggle.
  ///
  /// In en, this message translates to:
  /// **'Toggle'**
  String get tokenKindToggle;

  /// No description provided for @tokenKindCounter.
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get tokenKindCounter;

  /// No description provided for @tokenColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get tokenColorLabel;

  /// No description provided for @tokenPredefinedEmpty.
  ///
  /// In en, this message translates to:
  /// **'No spells or buffs to add for this gang.'**
  String get tokenPredefinedEmpty;

  /// No description provided for @tokenPredefinedSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon: tokens drawn from this model\'s own spells and rules.'**
  String get tokenPredefinedSoon;

  /// Tooltip on the tile button of a mask-giver model (e.g. Artisan Elena), which opens the modal to give one of its masks to another friendly model.
  ///
  /// In en, this message translates to:
  /// **'Give a mask'**
  String get grantTooltipMask;

  /// Tooltip on the tile button of a choice model (The Mask Maker, Master of Arcane Security), which opens the modal to pick the effect it gains this round.
  ///
  /// In en, this message translates to:
  /// **'Make a choice'**
  String get grantTooltipChoice;

  /// No description provided for @grantChooseTarget.
  ///
  /// In en, this message translates to:
  /// **'Choose a model to wear the mask'**
  String get grantChooseTarget;

  /// No description provided for @grantChooseEffect.
  ///
  /// In en, this message translates to:
  /// **'Choose an effect'**
  String get grantChooseEffect;

  /// No description provided for @grantNoTargets.
  ///
  /// In en, this message translates to:
  /// **'No eligible models to wear this mask.'**
  String get grantNoTargets;

  /// No description provided for @grantGive.
  ///
  /// In en, this message translates to:
  /// **'Give mask'**
  String get grantGive;

  /// Header shown in the mask modal once the mask has been given, naming the model that now wears it.
  ///
  /// In en, this message translates to:
  /// **'Worn by {name}'**
  String grantWornBy(String name);

  /// Toast shown when a debounced stat write fails and the displayed value rolls back to the last server-confirmed one. Not a retry prompt: the rollback already happened.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the change — reverted to the last synced value.'**
  String get statUpdateReverted;

  /// No description provided for @statLifePoints.
  ///
  /// In en, this message translates to:
  /// **'Life Points'**
  String get statLifePoints;

  /// No description provided for @statWillPoints.
  ///
  /// In en, this message translates to:
  /// **'Will Points'**
  String get statWillPoints;

  /// No description provided for @statCommandPoints.
  ///
  /// In en, this message translates to:
  /// **'Command Points'**
  String get statCommandPoints;

  /// No description provided for @summonTitle.
  ///
  /// In en, this message translates to:
  /// **'Summon a model'**
  String get summonTitle;

  /// No description provided for @summonBlurb.
  ///
  /// In en, this message translates to:
  /// **'Any model may be summoned, from any faction. It costs no ducats.'**
  String get summonBlurb;

  /// No description provided for @summonSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search names, abilities, rules...'**
  String get summonSearchHint;

  /// No description provided for @summonNoModels.
  ///
  /// In en, this message translates to:
  /// **'No models found.'**
  String get summonNoModels;

  /// No description provided for @summonFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not summon that model. Please try again.'**
  String get summonFailed;

  /// No description provided for @dismissTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String dismissTitle(String name);

  /// No description provided for @dismissBody.
  ///
  /// In en, this message translates to:
  /// **'This summoned model leaves the board. Its wounds and counters go with it.'**
  String get dismissBody;

  /// No description provided for @gangNoMentorChosen.
  ///
  /// In en, this message translates to:
  /// **'No mentor chosen'**
  String get gangNoMentorChosen;

  /// No description provided for @gangNoSpells.
  ///
  /// In en, this message translates to:
  /// **'No spells'**
  String get gangNoSpells;

  /// No description provided for @labelSpells.
  ///
  /// In en, this message translates to:
  /// **'Spells'**
  String get labelSpells;

  /// No description provided for @labelApprenticeship.
  ///
  /// In en, this message translates to:
  /// **'Apprenticeship'**
  String get labelApprenticeship;

  /// Gang builder: opens the card of a transforming model's alternate form. Preview only — the gang always holds the model as hired.
  ///
  /// In en, this message translates to:
  /// **'Other form'**
  String get labelOtherForm;

  /// No description provided for @gangRoleLeader.
  ///
  /// In en, this message translates to:
  /// **'leader'**
  String get gangRoleLeader;

  /// No description provided for @gangRoleHero.
  ///
  /// In en, this message translates to:
  /// **'hero'**
  String get gangRoleHero;

  /// No description provided for @gangHired.
  ///
  /// In en, this message translates to:
  /// **'Hired'**
  String get gangHired;

  /// No description provided for @gangTabList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get gangTabList;

  /// No description provided for @gangTabHire.
  ///
  /// In en, this message translates to:
  /// **'Hire'**
  String get gangTabHire;

  /// No description provided for @gangGoToHire.
  ///
  /// In en, this message translates to:
  /// **'Go to Hire to add models'**
  String get gangGoToHire;

  /// No description provided for @gangSectionMercenaries.
  ///
  /// In en, this message translates to:
  /// **'Mercenaries'**
  String get gangSectionMercenaries;

  /// No description provided for @gangSectionEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get gangSectionEquipment;

  /// No description provided for @gangNoProfilesForFaction.
  ///
  /// In en, this message translates to:
  /// **'No profiles for this faction.'**
  String get gangNoProfilesForFaction;

  /// No description provided for @gangNothingMatches.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches your search.'**
  String get gangNothingMatches;

  /// No description provided for @gangSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search models, equipment, abilities...'**
  String get gangSearchHint;

  /// No description provided for @sortRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get sortRole;

  /// No description provided for @sortName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sortName;

  /// No description provided for @sortCost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get sortCost;

  /// No description provided for @pointsBarSlashLimit.
  ///
  /// In en, this message translates to:
  /// **' / {limit} ducats'**
  String pointsBarSlashLimit(int limit);

  /// No description provided for @pointsBarLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} left'**
  String pointsBarLeft(int count);

  /// No description provided for @pointsBarOverBy.
  ///
  /// In en, this message translates to:
  /// **'−{count} left'**
  String pointsBarOverBy(int count);

  /// No description provided for @cardsProfileCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 profile} other{{count} profiles}}'**
  String cardsProfileCount(int count);

  /// No description provided for @cardsNoProfiles.
  ///
  /// In en, this message translates to:
  /// **'No profiles found.'**
  String get cardsNoProfiles;

  /// No description provided for @cardSwitchIllustration.
  ///
  /// In en, this message translates to:
  /// **'Switch illustration'**
  String get cardSwitchIllustration;

  /// No description provided for @cardAbilities.
  ///
  /// In en, this message translates to:
  /// **'Abilities'**
  String get cardAbilities;

  /// No description provided for @cardAbilitiesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load abilities.'**
  String get cardAbilitiesLoadFailed;

  /// No description provided for @cardNoAbilities.
  ///
  /// In en, this message translates to:
  /// **'This character has no special abilities.'**
  String get cardNoAbilities;

  /// No description provided for @cardCharacterAbilities.
  ///
  /// In en, this message translates to:
  /// **'Character Abilities'**
  String get cardCharacterAbilities;

  /// No description provided for @cardWeaponAbilities.
  ///
  /// In en, this message translates to:
  /// **'Weapon Abilities'**
  String get cardWeaponAbilities;

  /// No description provided for @rulesTitleUpper.
  ///
  /// In en, this message translates to:
  /// **'RULES'**
  String get rulesTitleUpper;

  /// No description provided for @rulesAvailableOffline.
  ///
  /// In en, this message translates to:
  /// **'Available offline'**
  String get rulesAvailableOffline;

  /// No description provided for @rulesDownloadsOnOpen.
  ///
  /// In en, this message translates to:
  /// **'Downloads on first open'**
  String get rulesDownloadsOnOpen;

  /// No description provided for @rulesAttribution.
  ///
  /// In en, this message translates to:
  /// **'Rules PDFs are published by TT Combat and served from their site. Carnevale is © TT Combat.'**
  String get rulesAttribution;

  /// No description provided for @tooltipSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get tooltipSearch;

  /// No description provided for @tooltipCloseSearch.
  ///
  /// In en, this message translates to:
  /// **'Close search'**
  String get tooltipCloseSearch;

  /// No description provided for @rulesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search this document'**
  String get rulesSearchHint;

  /// No description provided for @tooltipPreviousMatch.
  ///
  /// In en, this message translates to:
  /// **'Previous match'**
  String get tooltipPreviousMatch;

  /// No description provided for @tooltipNextMatch.
  ///
  /// In en, this message translates to:
  /// **'Next match'**
  String get tooltipNextMatch;

  /// No description provided for @rulesMatchNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get rulesMatchNone;

  /// No description provided for @rulesDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not download {title}'**
  String rulesDownloadFailed(String title);

  /// No description provided for @rulesOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open {title}'**
  String rulesOpenFailed(String title);

  /// No description provided for @rulesDownloadingPercent.
  ///
  /// In en, this message translates to:
  /// **'Downloading — {percent}%'**
  String rulesDownloadingPercent(int percent);

  /// No description provided for @apprMentor.
  ///
  /// In en, this message translates to:
  /// **'Mentor'**
  String get apprMentor;

  /// No description provided for @apprNoMentor.
  ///
  /// In en, this message translates to:
  /// **'No eligible mentor yet — hire a Hero with the Doctor keyword first.'**
  String get apprNoMentor;

  /// No description provided for @apprNoMentorSelected.
  ///
  /// In en, this message translates to:
  /// **'— No mentor selected —'**
  String get apprNoMentorSelected;

  /// No description provided for @apprAbilityToCopy.
  ///
  /// In en, this message translates to:
  /// **'Ability to copy'**
  String get apprAbilityToCopy;

  /// No description provided for @apprMageAbility.
  ///
  /// In en, this message translates to:
  /// **'Mage — copies the mentor\'s spell Disciplines'**
  String get apprMageAbility;

  /// No description provided for @apprCopyNote.
  ///
  /// In en, this message translates to:
  /// **'Copying a unique skill or weapon profile isn\'t supported yet — Mage is the only ability available here.'**
  String get apprCopyNote;

  /// No description provided for @spellsButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Spells · {cast}/{total} cast'**
  String spellsButtonLabel(int cast, int total);

  /// No description provided for @spellsKnownTitle.
  ///
  /// In en, this message translates to:
  /// **'Known spells'**
  String get spellsKnownTitle;

  /// No description provided for @spellAllCantrips.
  ///
  /// In en, this message translates to:
  /// **'All cantrips'**
  String get spellAllCantrips;

  /// No description provided for @spellDeselectHint.
  ///
  /// In en, this message translates to:
  /// **'Deselect a spell in another Discipline to pick here instead.'**
  String get spellDeselectHint;

  /// No description provided for @spellPoolTitle.
  ///
  /// In en, this message translates to:
  /// **'Spell pool'**
  String get spellPoolTitle;

  /// No description provided for @spellNoMentorSetup.
  ///
  /// In en, this message translates to:
  /// **'No mentor chosen — set one up via Apprenticeship first'**
  String get spellNoMentorSetup;

  /// No description provided for @spellMentorLabel.
  ///
  /// In en, this message translates to:
  /// **'Mentor: {name}'**
  String spellMentorLabel(String name);

  /// No description provided for @spellUpToDisciplines.
  ///
  /// In en, this message translates to:
  /// **'up to {count} Disciplines at once'**
  String spellUpToDisciplines(int count);

  /// No description provided for @spellNoDisciplineChosen.
  ///
  /// In en, this message translates to:
  /// **'No Discipline chosen'**
  String get spellNoDisciplineChosen;

  /// No description provided for @spellsSlashCount.
  ///
  /// In en, this message translates to:
  /// **'{count}/{total} spells'**
  String spellsSlashCount(int count, int total);

  /// No description provided for @spellsKnownCountLong.
  ///
  /// In en, this message translates to:
  /// **'{known}/{total} spells known'**
  String spellsKnownCountLong(int known, int total);

  /// No description provided for @spellCantripOnly.
  ///
  /// In en, this message translates to:
  /// **'Cantrip only'**
  String get spellCantripOnly;

  /// No description provided for @spellDistinctPool.
  ///
  /// In en, this message translates to:
  /// **'Must be a different Discipline from this model\'s other pool.'**
  String get spellDistinctPool;

  /// No description provided for @spellDistinctCopy.
  ///
  /// In en, this message translates to:
  /// **'Already chosen by another copy of this model in the gang.'**
  String get spellDistinctCopy;

  /// No description provided for @spellsAndDisciplines.
  ///
  /// In en, this message translates to:
  /// **'{spells}/{slots} spells known · {chosen}/{of} Disciplines chosen'**
  String spellsAndDisciplines(int spells, int slots, int chosen, int of);

  /// No description provided for @spellAlwaysKnown.
  ///
  /// In en, this message translates to:
  /// **'always known'**
  String get spellAlwaysKnown;

  /// No description provided for @spellGranted.
  ///
  /// In en, this message translates to:
  /// **'Granted'**
  String get spellGranted;

  /// No description provided for @spellsPlural.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 spell} other{{count} spells}}'**
  String spellsPlural(int count);

  /// No description provided for @spellGrantedLower.
  ///
  /// In en, this message translates to:
  /// **'granted'**
  String get spellGrantedLower;

  /// No description provided for @navCollection.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get navCollection;

  /// No description provided for @collectionFilter.
  ///
  /// In en, this message translates to:
  /// **'My collection'**
  String get collectionFilter;

  /// No description provided for @collectionOwned.
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get collectionOwned;

  /// No description provided for @collectionBuilt.
  ///
  /// In en, this message translates to:
  /// **'Built'**
  String get collectionBuilt;

  /// No description provided for @collectionPainted.
  ///
  /// In en, this message translates to:
  /// **'Painted'**
  String get collectionPainted;

  /// No description provided for @collectionNestingHint.
  ///
  /// In en, this message translates to:
  /// **'A painted miniature is necessarily built: lowering a total trims the ones above it.'**
  String get collectionNestingHint;

  /// No description provided for @collectionTabMine.
  ///
  /// In en, this message translates to:
  /// **'My collection'**
  String get collectionTabMine;

  /// No description provided for @collectionTabAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get collectionTabAdd;

  /// No description provided for @collectionSearchMine.
  ///
  /// In en, this message translates to:
  /// **'Search my collection...'**
  String get collectionSearchMine;

  /// No description provided for @collectionSearchAdd.
  ///
  /// In en, this message translates to:
  /// **'Add a miniature...'**
  String get collectionSearchAdd;

  /// No description provided for @collectionProgress.
  ///
  /// In en, this message translates to:
  /// **'{owned} / {total} profiles'**
  String collectionProgress(int owned, int total);

  /// No description provided for @collectionProgressDetail.
  ///
  /// In en, this message translates to:
  /// **'{miniatures} miniatures, {painted} painted'**
  String collectionProgressDetail(int miniatures, int painted);

  /// No description provided for @collectionAbsentCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 miniature not in your collection yet} other{{count} miniatures not in your collection yet}}'**
  String collectionAbsentCount(int count);

  /// No description provided for @collectionEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing in your collection yet.'**
  String get collectionEmpty;

  /// No description provided for @collectionAllAdded.
  ///
  /// In en, this message translates to:
  /// **'Every model is already in your collection.'**
  String get collectionAllAdded;

  /// No description provided for @collectionSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save that change.'**
  String get collectionSaveFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
