// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System default';

  @override
  String get settingsThemeMode => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsAppearance => 'APPEARANCE';

  @override
  String get settingsCardImages => 'CARD IMAGES';

  @override
  String get settingsAccount => 'ACCOUNT';

  @override
  String get settingsCardFlip => 'Card flip';

  @override
  String get settingsCardFlipFlip => 'Flip';

  @override
  String get settingsCardFlipSwipe => 'Swipe';

  @override
  String get settingsDownload => 'Download';

  @override
  String get settingsDownloadOnDemand => 'On demand';

  @override
  String get settingsDownloadAlways => 'Always';

  @override
  String get settingsDownloadWifiOnly => 'Wi-Fi only';

  @override
  String get settingsNotLoggedIn => 'Not logged in';

  @override
  String get settingsSignedInAs => 'Signed in as';

  @override
  String get settingsSyncBlurb =>
      'Download any card images that are missing or out of date on this device.';

  @override
  String get settingsSyncCards => 'Sync Cards';

  @override
  String settingsSyncCardsWithCount(String details) {
    return 'Sync Cards ($details)';
  }

  @override
  String get settingsSyncChecking => 'Checking for updates…';

  @override
  String settingsSyncDownloading(int done, int total) {
    return 'Downloading $done / $total';
  }

  @override
  String get settingsSyncUpToDate => 'All cards are already up to date';

  @override
  String settingsSyncedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Synced $count card images',
      one: 'Synced 1 card image',
    );
    return '$_temp0';
  }

  @override
  String get toastUsernameUpdated => 'Username updated!';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionGotIt => 'Got it';

  @override
  String get actionLogOut => 'Log Out';

  @override
  String get actionLogIn => 'Log In';

  @override
  String get actionSignUp => 'Sign Up';

  @override
  String get actionSave => 'Save';

  @override
  String get actionSend => 'Send';

  @override
  String get actionDone => 'Done';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionRemove => 'Remove';

  @override
  String get actionJoin => 'Join';

  @override
  String get actionSelect => 'Select';

  @override
  String get actionDeselect => 'Deselect';

  @override
  String get navHome => 'Home';

  @override
  String get navCards => 'Cards';

  @override
  String get navGangs => 'Gangs';

  @override
  String get navGames => 'Games';

  @override
  String get navRules => 'Rules';

  @override
  String get fieldUsername => 'Username';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldEmailOrUsername => 'Email or Username';

  @override
  String get fieldPassword => 'Password';

  @override
  String get fieldConfirmPassword => 'Confirm Password';

  @override
  String get fieldNewPassword => 'New Password';

  @override
  String get fieldConfirmNewPassword => 'Confirm New Password';

  @override
  String get validationRequired => 'Required';

  @override
  String get validationEmailInvalid => 'Enter a valid email';

  @override
  String get validationPasswordTooShort => 'At least 6 characters';

  @override
  String get validationPasswordMismatch => 'Passwords do not match';

  @override
  String get errorCouldNotReachServer => 'Could not reach server';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get toastLoggedOut => 'Logged out';

  @override
  String get toastLoggedIn => 'Logged in successfully!';

  @override
  String get toastAccountCreated => 'Account created!';

  @override
  String get toastResetEmailSent => 'Password reset email sent!';

  @override
  String get toastPasswordReset => 'Password reset! Please log in.';

  @override
  String get accountTitle => 'Account';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authResetPassword => 'Reset Password';

  @override
  String get authResetPasswordBlurb =>
      'Enter your email and we\'ll send you a link to reset your password.';

  @override
  String get authHaveAccount => 'Already have an account? ';

  @override
  String get authNoAccount => 'Don\'t have an account yet? ';

  @override
  String get resetPasswordBlurb => 'Choose a new password for your account.';

  @override
  String get drawerDarkTheme => 'DARK THEME';

  @override
  String get drawerLightTheme => 'LIGHT THEME';

  @override
  String deleteGangConfirm(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String gangModelCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count models',
      one: '1 model',
      zero: 'No models',
    );
    return '$_temp0';
  }

  @override
  String ducatsAmount(int count) {
    return '$count ducats';
  }

  @override
  String get attackerDefender => 'Attacker/Defender';

  @override
  String get roleAttacker => 'Attacker';

  @override
  String get roleDefender => 'Defender';

  @override
  String get youCap => 'You';

  @override
  String get youLower => 'you';

  @override
  String get opponentLabel => 'Opponent';

  @override
  String get agendaRuleCycle => 'Cycle';

  @override
  String get agendaRuleSecondary => 'Secondary';

  @override
  String get agendaRuleDouble => 'Double';

  @override
  String get agendaRuleSecret => 'Secret';

  @override
  String get agendaRuleTotal => 'Total';

  @override
  String get agendaRuleCycleDesc =>
      'Scoring an agenda immediately draws a replacement.';

  @override
  String get agendaRuleSecondaryDesc =>
      'You must achieve at least one agenda to score any Victory Points from any source.';

  @override
  String get agendaRuleDoubleDesc =>
      'On achieving an agenda you may keep it in play; achieving it again scores double, otherwise nothing.';

  @override
  String get agendaRuleSecretDesc =>
      'Keep your agendas secret from your opponent until achieved. Without this rule, all players can see each other\'s agendas.';

  @override
  String get agendaRuleTotalDesc =>
      'You must achieve all of your agendas to score their Victory Points.';

  @override
  String get gamesTabActive => 'Active';

  @override
  String get gamesTabArchived => 'Archived';

  @override
  String get gamesLoginPrompt => 'Log in to create or join a game';

  @override
  String get gamesEmptyActiveTitle => 'No games yet';

  @override
  String get gamesEmptyActiveSubtitle =>
      'Create a game or join one with a code';

  @override
  String get gamesEmptyArchivedTitle => 'No archived games';

  @override
  String get gamesEmptyArchivedSubtitle =>
      'Games you archive will show up here';

  @override
  String get toastGameArchived => 'Game archived';

  @override
  String get toastGameArchiveFailed => 'Could not archive this game';

  @override
  String get toastGameRestored => 'Game restored';

  @override
  String get toastGameRestoreFailed => 'Could not restore this game';

  @override
  String get toastGameDeleted => 'Game deleted';

  @override
  String get toastGameDeleteFailed => 'Could not delete this game';

  @override
  String gameStatusCodeLine(String status, String code) {
    return '$status · Code $code';
  }

  @override
  String gameVersus(String p1, String p2) {
    return '$p1 vs $p2';
  }

  @override
  String get gameWaitingForOpponentInline => 'waiting for an opponent';

  @override
  String get tooltipDeleteGame => 'Delete game';

  @override
  String get tooltipRestoreGame => 'Restore game';

  @override
  String get tooltipArchiveGame => 'Archive game';

  @override
  String get tooltipOpenGame => 'Open game';

  @override
  String get gameDeleteTitle => 'Delete Game';

  @override
  String get gameDeleteBody =>
      'Delete this game? You won\'t be able to see it again, even if your opponent still can.';

  @override
  String gamePlayerListLine(String name, String gang) {
    return '$name: $gang';
  }

  @override
  String get gameNoGangSelected => 'No gang selected yet';

  @override
  String get actionCreateGame => 'Create Game';

  @override
  String get actionJoinGame => 'Join Game';

  @override
  String get gameNewTitle => 'New Game';

  @override
  String get gameLoadScenariosFailed => 'Could not load scenarios';

  @override
  String get gameScenarioLabel => 'Scenario';

  @override
  String get gameNameOptional => 'Game name (optional)';

  @override
  String get gameDucatLimit => 'Ducat limit';

  @override
  String get gameBoardSizeOverride => 'Board size (optional override)';

  @override
  String gameScenarioMeta(int ducats, String duration) {
    return '$ducats ducats · $duration';
  }

  @override
  String get gameJoinCode => 'Join code';

  @override
  String get gameJoinFailed => 'Could not join — check the code and try again.';

  @override
  String get toastCouldNotOpenGang => 'Could not open that gang.';

  @override
  String get gameFallbackTitle => 'Game';

  @override
  String get sessionViewGangs => 'View gangs';

  @override
  String get sessionMyGang => 'My Gang';

  @override
  String get deployTitle => 'Deploy your gangs';

  @override
  String deployBodyWithWinner(String name) {
    return '$name won the deployment roll-off. Agree on deployment zones and place your miniatures at the table.';
  }

  @override
  String get deployBodyNoWinner =>
      'Agree on deployment zones and place your miniatures at the table.';

  @override
  String get toastSessionLoadFailed => 'Could not load this game.';

  @override
  String get sessionExpired => 'Your session expired. Please log in again.';

  @override
  String get lobbyTitle => 'Waiting for an opponent';

  @override
  String get lobbyShareCode => 'Share this code with the other player:';

  @override
  String get toastJoinCodeCopied => 'Join code copied';

  @override
  String get rolloffWonTitle => 'You won the roll-off!';

  @override
  String get rolloffChooseRole => 'Choose your role:';

  @override
  String get rolloffTitle => 'Role roll-off';

  @override
  String rolloffWaitingForWinner(String name) {
    return 'Waiting for $name to choose a role...';
  }

  @override
  String get rolloffDetermining => 'Determining who picks a role...';

  @override
  String get gangPickTitle => 'Pick your gang';

  @override
  String gangPickDucatLimit(int limit) {
    return 'Ducat limit: $limit';
  }

  @override
  String get gangPickNoGangs => 'You have no gangs yet — build one now.';

  @override
  String get gangPickBuildNew => 'Build a new gang';

  @override
  String get gangPickWaitingOpponent =>
      'Waiting for the opponent to pick a gang...';

  @override
  String get gangOverLimit => 'Over limit';

  @override
  String get actionSetUp => 'Set up';

  @override
  String get agendaDealingTitle => 'Dealing your Agendas';

  @override
  String get agendaDealingSecret =>
      'Kept secret from your opponent until achieved (Secret scenario).';

  @override
  String get agendaDealingOpen =>
      'Your opponent can see these — this scenario is not Secret.';

  @override
  String get yourSpellsTitle => 'Your Spells';

  @override
  String get yourSpellsSubtitle =>
      'Review each Mage\'s spells before confirming — Ready locks these in together with your Agendas.';

  @override
  String get spellsNoMentor => 'No mentor chosen yet';

  @override
  String spellsKnownCount(int known, int total) {
    return '$known/$total spells';
  }

  @override
  String get yourAgendasTitle => 'Your Agendas';

  @override
  String get yourAgendasSubtitle =>
      'Any agenda that is impossible or duplicated can be discarded and redrawn — agree with your opponent that it is unachievable.';

  @override
  String get agendaConfirmBlurb =>
      'Confirming locks in your Agendas and your Spells together for the rest of the game.';

  @override
  String get actionReady => 'Ready';

  @override
  String get waitingOpponentReady => 'Waiting for the opponent to be ready...';

  @override
  String agendaIndexName(int index, String name) {
    return '$index - $name';
  }

  @override
  String get agendaUnachievableRedraw => 'Unachievable — redraw';

  @override
  String discardedCount(int count) {
    return 'Discarded ($count)';
  }

  @override
  String get mulliganTitle => 'Discard & redraw?';

  @override
  String mulliganBody(String name) {
    return 'Discard \"$name\" as unachievable and draw a replacement? Your opponent will see this.';
  }

  @override
  String get actionDiscardRedraw => 'Discard & redraw';

  @override
  String get scoreTabLabel => 'Score';

  @override
  String get tooltipRewindTurn => 'Rewind a turn';

  @override
  String get tooltipAdvanceTurn => 'Advance a turn';

  @override
  String turnOfTurns(int current, int total) {
    return 'Turn $current of $total';
  }

  @override
  String get vpLabel => 'VP';

  @override
  String get gameEnded => 'You\'ve ended the game.';

  @override
  String get actionUndoKeepScoring => 'Undo — keep scoring';

  @override
  String get actionEndGame => 'End game';

  @override
  String get actionDraw => 'Draw';

  @override
  String get agendasNoneInHand => 'No agendas in hand.';

  @override
  String get sectionScored => 'Scored';

  @override
  String get sectionDiscarded => 'Discarded';

  @override
  String get sectionInHand => 'In hand';

  @override
  String opponentAgendasTitle(String name) {
    return '$name\'s Agendas';
  }

  @override
  String get agendasHiddenSecret =>
      'Hidden — this scenario has the Secret rule.';

  @override
  String get actionScore => 'Score';

  @override
  String get actionDiscard => 'Discard';

  @override
  String get actionLog => 'Log';

  @override
  String get drawOriginTitle => 'Draw an agenda via…';

  @override
  String get discardOriginTitle => 'Discard this agenda via…';

  @override
  String get originUnachievable => 'Unachievable';

  @override
  String get originSpecialRule => 'Special Rule';

  @override
  String get originCommandPoint => 'Command Point';

  @override
  String get originLabelUnachievable => 'unachievable';

  @override
  String get originLabelSpecialRule => 'special rule';

  @override
  String get originLabelCommandPoint => 'command point';

  @override
  String get logYourLog => 'Your log';

  @override
  String logPlayerLog(String name) {
    return '$name\'s log';
  }

  @override
  String get logSecretNote =>
      'Only resolved agendas are shown (Secret scenario).';

  @override
  String get logNoEvents => 'No events yet.';

  @override
  String logTurnHeader(int turn) {
    return 'TURN $turn';
  }

  @override
  String get eventScored => 'Scored';

  @override
  String get eventDiscarded => 'Discarded';

  @override
  String get eventDrew => 'Drew';

  @override
  String get gangsLoginPrompt => 'Log in to build and manage your gangs';

  @override
  String gangCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gangs',
      one: '1 gang',
    );
    return '$_temp0';
  }

  @override
  String get gangDeleteTitle => 'Delete Gang';

  @override
  String get gangsEmptyTitle => 'No gangs yet';

  @override
  String get gangsEmptySubtitle => 'Tap + to create your first gang';

  @override
  String get gangsRosterNoModels => 'No models hired yet.';

  @override
  String get gangViewerNoModels => 'No models hired.';

  @override
  String get gangBuilderNoModels => 'No models hired yet';

  @override
  String get gangCreateTitle => 'New Gang';

  @override
  String get gangNameLabel => 'Gang name';

  @override
  String get gangPointLimit => 'Point limit';

  @override
  String get gangFactionLabel => 'Faction';

  @override
  String get gangCreateButton => 'Create Gang';

  @override
  String get toastActivationFailed =>
      'Could not update the activation. Please try again.';

  @override
  String get toastSpellUpdateFailed =>
      'Could not update that spell. Please try again.';

  @override
  String get toastRemoveModelFailed =>
      'Could not remove that model. Please try again.';

  @override
  String get gangViewerLoadFailed => 'Could not load this gang.';

  @override
  String get labelFactionRule => 'Faction Rule';

  @override
  String get labelSummon => 'Summon';

  @override
  String get counterStunned => 'Stunned';

  @override
  String get counterHidden => 'Hidden';

  @override
  String get counterGuarding => 'Guarding';

  @override
  String get counterCarryingObjective => 'Carrying objective';

  @override
  String get counterUnderwater => 'Underwater';

  @override
  String get tooltipActivatedThisTurn => 'Activated this turn';

  @override
  String get tooltipMarkActivated => 'Mark as activated';

  @override
  String get tooltipRemoveSummoned => 'Remove this summoned model';

  @override
  String get tooltipEditCounters => 'Edit counters';

  @override
  String get counterToggleFailed =>
      'Could not update the counter. Please try again.';

  @override
  String get counterTapToToggle => 'Tap a counter to toggle it.';

  @override
  String get tooltipEditModel => 'Edit counters and tokens';

  @override
  String get actionActivate => 'Activate';

  @override
  String get actionActivated => 'Activated';

  @override
  String get tokenUpdateFailed =>
      'Could not update the token. Please try again.';

  @override
  String get tokenTabGeneric => 'Generic';

  @override
  String get tokenTabCustom => 'Custom';

  @override
  String get tokenTabPredefined => 'Predefined';

  @override
  String get tokenSectionOnModel => 'On this model';

  @override
  String get tokenSectionNew => 'New token';

  @override
  String get tokenLabelHint => 'Label — optional';

  @override
  String get tokenToggleable => 'Toggleable';

  @override
  String get tokenAdd => 'Add token';

  @override
  String get tokenNoLabel => 'No label';

  @override
  String get tokenNoneYet => 'No tokens yet.';

  @override
  String get tokenLabelTaken => 'Already on this model';

  @override
  String get tokenCountLabel => 'Count';

  @override
  String get tokenKindPlain => 'Plain';

  @override
  String get tokenKindToggle => 'Toggle';

  @override
  String get tokenKindCounter => 'Counter';

  @override
  String get tokenColorLabel => 'Color';

  @override
  String get tokenPredefinedEmpty => 'No spells or buffs to add for this gang.';

  @override
  String get tokenPredefinedSoon =>
      'Coming soon: tokens drawn from this model\'s own spells and rules.';

  @override
  String get grantTooltipMask => 'Give a mask';

  @override
  String get grantTooltipChoice => 'Make a choice';

  @override
  String get grantChooseTarget => 'Choose a model to wear the mask';

  @override
  String get grantChooseEffect => 'Choose an effect';

  @override
  String get grantNoTargets => 'No eligible models to wear this mask.';

  @override
  String get grantGive => 'Give mask';

  @override
  String grantWornBy(String name) {
    return 'Worn by $name';
  }

  @override
  String get statUpdateReverted =>
      'Couldn\'t save the change — reverted to the last synced value.';

  @override
  String get statLifePoints => 'Life Points';

  @override
  String get statWillPoints => 'Will Points';

  @override
  String get statCommandPoints => 'Command Points';

  @override
  String get summonTitle => 'Summon a model';

  @override
  String get summonBlurb =>
      'Any model may be summoned, from any faction. It costs no ducats.';

  @override
  String get summonSearchHint => 'Search names, abilities, rules...';

  @override
  String get summonNoModels => 'No models found.';

  @override
  String get summonFailed => 'Could not summon that model. Please try again.';

  @override
  String dismissTitle(String name) {
    return 'Remove $name?';
  }

  @override
  String get dismissBody =>
      'This summoned model leaves the board. Its wounds and counters go with it.';

  @override
  String get gangNoMentorChosen => 'No mentor chosen';

  @override
  String get gangNoSpells => 'No spells';

  @override
  String get labelSpells => 'Spells';

  @override
  String get labelApprenticeship => 'Apprenticeship';

  @override
  String get gangRoleLeader => 'leader';

  @override
  String get gangRoleHero => 'hero';

  @override
  String get gangHired => 'Hired';

  @override
  String get gangTabList => 'List';

  @override
  String get gangTabHire => 'Hire';

  @override
  String get gangGoToHire => 'Go to Hire to add models';

  @override
  String get gangSectionMercenaries => 'Mercenaries';

  @override
  String get gangSectionEquipment => 'Equipment';

  @override
  String get gangNoProfilesForFaction => 'No profiles for this faction.';

  @override
  String get gangNothingMatches => 'Nothing matches your search.';

  @override
  String get gangSearchHint => 'Search models, equipment, abilities...';

  @override
  String get sortRole => 'Role';

  @override
  String get sortName => 'Name';

  @override
  String get sortCost => 'Cost';

  @override
  String pointsBarSlashLimit(int limit) {
    return ' / $limit ducats';
  }

  @override
  String pointsBarLeft(int count) {
    return '$count left';
  }

  @override
  String pointsBarOverBy(int count) {
    return '−$count left';
  }

  @override
  String cardsProfileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count profiles',
      one: '1 profile',
    );
    return '$_temp0';
  }

  @override
  String get cardsNoProfiles => 'No profiles found.';

  @override
  String get cardSwitchIllustration => 'Switch illustration';

  @override
  String cardViewerHint(int current, int total) {
    return '$current / $total  •  tap/←→ flip  •  swipe ↑↓ navigate';
  }

  @override
  String get cardAbilities => 'Abilities';

  @override
  String get cardAbilitiesLoadFailed => 'Could not load abilities.';

  @override
  String get cardNoAbilities => 'This character has no special abilities.';

  @override
  String get cardCharacterAbilities => 'Character Abilities';

  @override
  String get cardWeaponAbilities => 'Weapon Abilities';

  @override
  String get rulesTitleUpper => 'RULES';

  @override
  String get rulesAvailableOffline => 'Available offline';

  @override
  String get rulesDownloadsOnOpen => 'Downloads on first open';

  @override
  String get rulesAttribution =>
      'Rules PDFs are published by TT Combat and served from their site. Carnevale is © TT Combat.';

  @override
  String get tooltipSearch => 'Search';

  @override
  String get tooltipCloseSearch => 'Close search';

  @override
  String get rulesSearchHint => 'Search this document';

  @override
  String get tooltipPreviousMatch => 'Previous match';

  @override
  String get tooltipNextMatch => 'Next match';

  @override
  String get rulesMatchNone => 'None';

  @override
  String rulesDownloadFailed(String title) {
    return 'Could not download $title';
  }

  @override
  String rulesOpenFailed(String title) {
    return 'Could not open $title';
  }

  @override
  String rulesDownloadingPercent(int percent) {
    return 'Downloading — $percent%';
  }

  @override
  String get apprMentor => 'Mentor';

  @override
  String get apprNoMentor =>
      'No eligible mentor yet — hire a Hero with the Doctor keyword first.';

  @override
  String get apprNoMentorSelected => '— No mentor selected —';

  @override
  String get apprAbilityToCopy => 'Ability to copy';

  @override
  String get apprMageAbility => 'Mage — copies the mentor\'s spell Disciplines';

  @override
  String get apprCopyNote =>
      'Copying a unique skill or weapon profile isn\'t supported yet — Mage is the only ability available here.';

  @override
  String spellsButtonLabel(int cast, int total) {
    return 'Spells · $cast/$total cast';
  }

  @override
  String get spellsKnownTitle => 'Known spells';

  @override
  String get spellAllCantrips => 'All cantrips';

  @override
  String get spellDeselectHint =>
      'Deselect a spell in another Discipline to pick here instead.';

  @override
  String get spellPoolTitle => 'Spell pool';

  @override
  String get spellNoMentorSetup =>
      'No mentor chosen — set one up via Apprenticeship first';

  @override
  String spellMentorLabel(String name) {
    return 'Mentor: $name';
  }

  @override
  String spellUpToDisciplines(int count) {
    return 'up to $count Disciplines at once';
  }

  @override
  String get spellNoDisciplineChosen => 'No Discipline chosen';

  @override
  String spellsSlashCount(int count, int total) {
    return '$count/$total spells';
  }

  @override
  String spellsKnownCountLong(int known, int total) {
    return '$known/$total spells known';
  }

  @override
  String get spellCantripOnly => 'Cantrip only';

  @override
  String get spellDistinctPool =>
      'Must be a different Discipline from this model\'s other pool.';

  @override
  String get spellDistinctCopy =>
      'Already chosen by another copy of this model in the gang.';

  @override
  String spellsAndDisciplines(int spells, int slots, int chosen, int of) {
    return '$spells/$slots spells known · $chosen/$of Disciplines chosen';
  }

  @override
  String get spellAlwaysKnown => 'always known';

  @override
  String get spellGranted => 'Granted';

  @override
  String spellsPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spells',
      one: '1 spell',
    );
    return '$_temp0';
  }

  @override
  String get spellGrantedLower => 'granted';
}
