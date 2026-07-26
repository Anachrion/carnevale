// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageSystem => 'Langue de l\'appareil';

  @override
  String get settingsThemeMode => 'Thème';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsAppearance => 'APPARENCE';

  @override
  String get settingsCardImages => 'IMAGES DES CARTES';

  @override
  String get settingsAccount => 'COMPTE';

  @override
  String get settingsCardFlip => 'Retournement';

  @override
  String get settingsCardFlipFlip => 'Rotation';

  @override
  String get settingsCardFlipSwipe => 'Glissement';

  @override
  String get settingsDownload => 'Téléchargement';

  @override
  String get settingsDownloadOnDemand => 'À la demande';

  @override
  String get settingsDownloadAlways => 'Toujours';

  @override
  String get settingsDownloadWifiOnly => 'Wi-Fi uniquement';

  @override
  String get settingsNotLoggedIn => 'Non connecté';

  @override
  String get settingsSignedInAs => 'Connecté en tant que';

  @override
  String get settingsChangeUsername => 'Changer de nom d\'utilisateur';

  @override
  String get settingsSyncBlurb =>
      'Téléchargez les images de cartes manquantes ou obsolètes sur cet appareil.';

  @override
  String get settingsSyncCards => 'Synchroniser les cartes';

  @override
  String settingsSyncCardsWithCount(String details) {
    return 'Synchroniser les cartes ($details)';
  }

  @override
  String get settingsSyncChecking => 'Recherche de mises à jour…';

  @override
  String settingsSyncDownloading(int done, int total) {
    return 'Téléchargement $done / $total';
  }

  @override
  String get settingsSyncUpToDate => 'Toutes les cartes sont déjà à jour';

  @override
  String settingsSyncedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count images de cartes synchronisées',
      one: '1 image de carte synchronisée',
    );
    return '$_temp0';
  }

  @override
  String get settingsAbout => 'À PROPOS';

  @override
  String get settingsAboutButton => 'À propos de Carnevale';

  @override
  String get aboutDescription =>
      'Une application compagnon non officielle et amateur pour le jeu de table.';

  @override
  String get aboutCredits => 'Créé par Anachrion et Eldrim.';

  @override
  String get aboutSourceHeading => 'Code source';

  @override
  String get aboutSourceApp => 'Application (Flutter)';

  @override
  String get aboutSourceServer => 'Serveur (Rails)';

  @override
  String get aboutLegalHeading => 'Confidentialité et données';

  @override
  String get aboutPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get aboutAccountDeletion => 'Supprimer votre compte';

  @override
  String get aboutViewLicenses => 'Licences';

  @override
  String get aboutLegalese =>
      'Carnevale est un jeu de figurines créé et publié par TT Combat, qui détient l\'ensemble des droits de propriété intellectuelle associés, y compris le nom, les illustrations et les marques Carnevale. Nous n\'en revendiquons aucune propriété. Ceci est une application compagnon indépendante et amateur — sans caractère officiel. Elle n\'est ni affiliée à TT Combat ni approuvée par elle, et est utilisée avec son aimable autorisation ; elle est fournie gratuitement et n\'est jamais vendue. Tous les noms, marques et illustrations demeurent la propriété de TT Combat et de leurs détenteurs respectifs.\n\n© 2026 Anachrion & Eldrim. Distribué sous licence Apache, version 2.0.';

  @override
  String get toastUsernameUpdated => 'Nom d\'utilisateur mis à jour !';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionClose => 'Fermer';

  @override
  String get actionDelete => 'Supprimer';

  @override
  String get actionGotIt => 'Compris';

  @override
  String get actionLogOut => 'Se déconnecter';

  @override
  String get actionLogIn => 'Se connecter';

  @override
  String get actionSignUp => 'S\'inscrire';

  @override
  String get actionSave => 'Enregistrer';

  @override
  String get actionSend => 'Envoyer';

  @override
  String get actionDone => 'Terminé';

  @override
  String get actionRetry => 'Réessayer';

  @override
  String get actionEdit => 'Modifier';

  @override
  String get actionRemove => 'Retirer';

  @override
  String get actionJoin => 'Rejoindre';

  @override
  String get actionSelect => 'Sélectionner';

  @override
  String get actionDeselect => 'Désélectionner';

  @override
  String get navHome => 'Accueil';

  @override
  String get navCards => 'Cartes';

  @override
  String get navGangs => 'Gangs';

  @override
  String get navGames => 'Parties';

  @override
  String get navRules => 'Règles';

  @override
  String get fieldUsername => 'Nom d\'utilisateur';

  @override
  String get fieldEmail => 'E-mail';

  @override
  String get fieldEmailOrUsername => 'E-mail ou nom d\'utilisateur';

  @override
  String get fieldPassword => 'Mot de passe';

  @override
  String get fieldConfirmPassword => 'Confirmer le mot de passe';

  @override
  String get fieldNewPassword => 'Nouveau mot de passe';

  @override
  String get fieldConfirmNewPassword => 'Confirmer le nouveau mot de passe';

  @override
  String get validationRequired => 'Requis';

  @override
  String get validationEmailInvalid => 'Saisissez une adresse e-mail valide';

  @override
  String get validationPasswordTooShort => 'Au moins 6 caractères';

  @override
  String get validationPasswordMismatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get errorCouldNotReachServer => 'Impossible de joindre le serveur';

  @override
  String get errorGeneric => 'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get toastLoggedOut => 'Déconnecté';

  @override
  String get toastLoggedIn => 'Connexion réussie !';

  @override
  String get toastAccountCreated => 'Compte créé !';

  @override
  String get toastResetEmailSent => 'E-mail de réinitialisation envoyé !';

  @override
  String get toastPasswordReset =>
      'Mot de passe réinitialisé ! Veuillez vous connecter.';

  @override
  String get accountTitle => 'Compte';

  @override
  String get authForgotPassword => 'Mot de passe oublié ?';

  @override
  String get authResetPassword => 'Réinitialiser le mot de passe';

  @override
  String get authResetPasswordBlurb =>
      'Saisissez votre e-mail et nous vous enverrons un lien pour réinitialiser votre mot de passe.';

  @override
  String get authHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get authNoAccount => 'Pas encore de compte ? ';

  @override
  String get resetPasswordBlurb =>
      'Choisissez un nouveau mot de passe pour votre compte.';

  @override
  String get drawerDarkTheme => 'THÈME SOMBRE';

  @override
  String get drawerLightTheme => 'THÈME CLAIR';

  @override
  String deleteGangConfirm(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String gangModelCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count figurines',
      one: '1 figurine',
      zero: 'Aucune figurine',
    );
    return '$_temp0';
  }

  @override
  String ducatsAmount(int count) {
    return '$count ducats';
  }

  @override
  String get attackerDefender => 'Attaquant/Défenseur';

  @override
  String get roleAttacker => 'Attaquant';

  @override
  String get roleDefender => 'Défenseur';

  @override
  String get youCap => 'Vous';

  @override
  String get youLower => 'vous';

  @override
  String get opponentLabel => 'Adversaire';

  @override
  String get agendaRuleCycle => 'Cycle';

  @override
  String get agendaRuleSecondary => 'Secondaire';

  @override
  String get agendaRuleDouble => 'Double';

  @override
  String get agendaRuleSecret => 'Secret';

  @override
  String get agendaRuleTotal => 'Total';

  @override
  String get agendaRuleCycleDesc =>
      'Marquer un agenda en fait immédiatement piocher un nouveau.';

  @override
  String get agendaRuleSecondaryDesc =>
      'Vous devez réaliser au moins un agenda pour marquer des points de victoire de quelque source que ce soit.';

  @override
  String get agendaRuleDoubleDesc =>
      'En réalisant un agenda, vous pouvez le garder en jeu ; le réaliser à nouveau rapporte le double, sinon rien.';

  @override
  String get agendaRuleSecretDesc =>
      'Gardez vos agendas secrets de votre adversaire jusqu\'à leur réalisation. Sans cette règle, tous les joueurs voient les agendas des autres.';

  @override
  String get agendaRuleTotalDesc =>
      'Vous devez réaliser tous vos agendas pour marquer leurs points de victoire.';

  @override
  String get gamesTabActive => 'En cours';

  @override
  String get gamesTabArchived => 'Archivées';

  @override
  String get gamesLoginPrompt =>
      'Connectez-vous pour créer ou rejoindre une partie';

  @override
  String get gamesEmptyActiveTitle => 'Aucune partie';

  @override
  String get gamesEmptyActiveSubtitle =>
      'Créez une partie ou rejoignez-en une avec un code';

  @override
  String get gamesEmptyArchivedTitle => 'Aucune partie archivée';

  @override
  String get gamesEmptyArchivedSubtitle =>
      'Les parties que vous archivez apparaîtront ici';

  @override
  String get toastGameArchived => 'Partie archivée';

  @override
  String get toastGameArchiveFailed => 'Impossible d\'archiver cette partie';

  @override
  String get toastGameRestored => 'Partie restaurée';

  @override
  String get toastGameRestoreFailed => 'Impossible de restaurer cette partie';

  @override
  String get toastGameDeleted => 'Partie supprimée';

  @override
  String get toastGameDeleteFailed => 'Impossible de supprimer cette partie';

  @override
  String gameStatusCodeLine(String status, String code) {
    return '$status · Code $code';
  }

  @override
  String gameVersus(String p1, String p2) {
    return '$p1 vs $p2';
  }

  @override
  String get gameWaitingForOpponentInline => 'en attente d\'un adversaire';

  @override
  String get tooltipDeleteGame => 'Supprimer la partie';

  @override
  String get tooltipRestoreGame => 'Restaurer la partie';

  @override
  String get tooltipArchiveGame => 'Archiver la partie';

  @override
  String get tooltipOpenGame => 'Ouvrir la partie';

  @override
  String get gameDeleteTitle => 'Supprimer la partie';

  @override
  String get gameDeleteBody =>
      'Supprimer cette partie ? Vous ne pourrez plus la voir, même si votre adversaire le peut encore.';

  @override
  String gamePlayerListLine(String name, String gang) {
    return '$name : $gang';
  }

  @override
  String get gameNoGangSelected => 'Aucun gang sélectionné';

  @override
  String get actionCreateGame => 'Créer une partie';

  @override
  String get actionJoinGame => 'Rejoindre une partie';

  @override
  String get gameNewTitle => 'Nouvelle partie';

  @override
  String get gameLoadScenariosFailed => 'Impossible de charger les scénarios';

  @override
  String get gameScenarioLabel => 'Scénario';

  @override
  String get gameNameOptional => 'Nom de la partie (facultatif)';

  @override
  String get gameDucatLimit => 'Limite de ducats';

  @override
  String get gameBoardSizeOverride =>
      'Taille du plateau (remplacement facultatif)';

  @override
  String gameScenarioMeta(int ducats, String duration) {
    return '$ducats ducats · $duration';
  }

  @override
  String get gameJoinCode => 'Code de la partie';

  @override
  String get gameJoinFailed =>
      'Impossible de rejoindre — vérifiez le code et réessayez.';

  @override
  String get toastCouldNotOpenGang => 'Impossible d\'ouvrir ce gang.';

  @override
  String get gameFallbackTitle => 'Partie';

  @override
  String get sessionViewGangs => 'Voir les gangs';

  @override
  String get sessionMyGang => 'Mon gang';

  @override
  String get deployTitle => 'Déployez vos gangs';

  @override
  String deployBodyWithWinner(String name) {
    return '$name a gagné le jet de déploiement. Convenez des zones de déploiement et placez vos figurines sur la table.';
  }

  @override
  String get deployBodyNoWinner =>
      'Convenez des zones de déploiement et placez vos figurines sur la table.';

  @override
  String get toastSessionLoadFailed => 'Impossible de charger cette partie.';

  @override
  String get sessionExpired =>
      'Votre session a expiré. Veuillez vous reconnecter.';

  @override
  String get lobbyTitle => 'En attente d\'un adversaire';

  @override
  String get lobbyShareCode => 'Partagez ce code avec l\'autre joueur :';

  @override
  String get toastJoinCodeCopied => 'Code de partie copié';

  @override
  String get rolloffWonTitle => 'Vous avez gagné le jet !';

  @override
  String get rolloffChooseRole => 'Choisissez votre rôle :';

  @override
  String get rolloffTitle => 'Jet pour les rôles';

  @override
  String rolloffWaitingForWinner(String name) {
    return 'En attente que $name choisisse un rôle...';
  }

  @override
  String get rolloffDetermining => 'Détermination de qui choisit un rôle...';

  @override
  String get gangPickTitle => 'Choisissez votre gang';

  @override
  String gangPickDucatLimit(int limit) {
    return 'Limite de ducats : $limit';
  }

  @override
  String get gangPickNoGangs =>
      'Vous n\'avez pas encore de gang — créez-en un maintenant.';

  @override
  String get gangPickBuildNew => 'Créer un nouveau gang';

  @override
  String get gangPickWaitingOpponent =>
      'En attente que l\'adversaire choisisse un gang...';

  @override
  String get gangOverLimit => 'Hors limite';

  @override
  String get actionSetUp => 'Configurer';

  @override
  String get agendaDealingTitle => 'Distribution de vos agendas';

  @override
  String get agendaDealingSecret =>
      'Gardés secrets de votre adversaire jusqu\'à leur réalisation (scénario Secret).';

  @override
  String get agendaDealingOpen =>
      'Votre adversaire peut les voir — ce scénario n\'est pas Secret.';

  @override
  String get yourSpellsTitle => 'Vos sorts';

  @override
  String get yourSpellsSubtitle =>
      'Vérifiez les sorts de chaque Mage avant de confirmer — Prêt les verrouille en même temps que vos agendas.';

  @override
  String get spellsNoMentor => 'Aucun mentor choisi pour l\'instant';

  @override
  String spellsKnownCount(int known, int total) {
    return '$known/$total sorts';
  }

  @override
  String get yourAgendasTitle => 'Vos agendas';

  @override
  String get yourAgendasSubtitle =>
      'Tout agenda impossible ou en double peut être défaussé et repioché — convenez avec votre adversaire qu\'il est irréalisable.';

  @override
  String get agendaConfirmBlurb =>
      'Confirmer verrouille vos agendas et vos sorts ensemble pour le reste de la partie.';

  @override
  String get actionReady => 'Prêt';

  @override
  String get waitingOpponentReady =>
      'En attente que l\'adversaire soit prêt...';

  @override
  String agendaIndexName(int index, String name) {
    return '$index - $name';
  }

  @override
  String get agendaUnachievableRedraw => 'Irréalisable — repiocher';

  @override
  String discardedCount(int count) {
    return 'Défaussés ($count)';
  }

  @override
  String get mulliganTitle => 'Défausser et repiocher ?';

  @override
  String mulliganBody(String name) {
    return 'Défausser « $name » comme irréalisable et piocher un remplaçant ? Votre adversaire le verra.';
  }

  @override
  String get actionDiscardRedraw => 'Défausser et repiocher';

  @override
  String get scoreTabLabel => 'Score';

  @override
  String get tooltipRewindTurn => 'Reculer d\'un tour';

  @override
  String get tooltipAdvanceTurn => 'Avancer d\'un tour';

  @override
  String turnOfTurns(int current, int total) {
    return 'Tour $current sur $total';
  }

  @override
  String get vpLabel => 'PV';

  @override
  String get gameEnded => 'Vous avez terminé la partie.';

  @override
  String get actionUndoKeepScoring => 'Annuler — continuer à marquer';

  @override
  String get actionEndGame => 'Terminer la partie';

  @override
  String get actionDraw => 'Piocher';

  @override
  String get agendasNoneInHand => 'Aucun agenda en main.';

  @override
  String get sectionScored => 'Marqués';

  @override
  String get sectionDiscarded => 'Défaussés';

  @override
  String get sectionInHand => 'En main';

  @override
  String opponentAgendasTitle(String name) {
    return 'Agendas de $name';
  }

  @override
  String get agendasHiddenSecret =>
      'Cachés — ce scénario utilise la règle Secret.';

  @override
  String get actionScore => 'Marquer';

  @override
  String get actionDiscard => 'Défausser';

  @override
  String get actionLog => 'Journal';

  @override
  String get drawOriginTitle => 'Piocher un agenda via…';

  @override
  String get discardOriginTitle => 'Défausser cet agenda via…';

  @override
  String get originUnachievable => 'Irréalisable';

  @override
  String get originSpecialRule => 'Règle spéciale';

  @override
  String get originCommandPoint => 'Point de commandement';

  @override
  String get originLabelUnachievable => 'irréalisable';

  @override
  String get originLabelSpecialRule => 'règle spéciale';

  @override
  String get originLabelCommandPoint => 'point de commandement';

  @override
  String get logYourLog => 'Votre journal';

  @override
  String logPlayerLog(String name) {
    return 'Journal de $name';
  }

  @override
  String get logSecretNote =>
      'Seuls les agendas résolus sont affichés (scénario Secret).';

  @override
  String get logNoEvents => 'Aucun événement pour l\'instant.';

  @override
  String logTurnHeader(int turn) {
    return 'TOUR $turn';
  }

  @override
  String get eventScored => 'Marqué';

  @override
  String get eventDiscarded => 'Défaussé';

  @override
  String get eventDrew => 'Pioché';

  @override
  String get gangsLoginPrompt => 'Connectez-vous pour créer et gérer vos gangs';

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
  String get gangDeleteTitle => 'Supprimer le gang';

  @override
  String get gangsEmptyTitle => 'Aucun gang';

  @override
  String get gangsEmptySubtitle =>
      'Appuyez sur + pour créer votre premier gang';

  @override
  String get gangsRosterNoModels => 'Aucune figurine engagée.';

  @override
  String get gangViewerNoModels => 'Aucune figurine engagée.';

  @override
  String get gangBuilderNoModels => 'Aucune figurine engagée';

  @override
  String get gangCreateTitle => 'Nouveau gang';

  @override
  String get gangNameLabel => 'Nom du gang';

  @override
  String get gangPointLimit => 'Limite de points';

  @override
  String get gangFactionLabel => 'Faction';

  @override
  String get gangCreateButton => 'Créer le gang';

  @override
  String get toastActivationFailed =>
      'Impossible de mettre à jour l\'activation. Veuillez réessayer.';

  @override
  String get toastSpellUpdateFailed =>
      'Impossible de mettre à jour ce sort. Veuillez réessayer.';

  @override
  String get toastRemoveModelFailed =>
      'Impossible de retirer cette figurine. Veuillez réessayer.';

  @override
  String get gangViewerLoadFailed => 'Impossible de charger ce gang.';

  @override
  String get labelFactionRule => 'Règle de faction';

  @override
  String get labelSummon => 'Invoquer';

  @override
  String get counterStunned => 'Étourdi';

  @override
  String get counterHidden => 'Caché';

  @override
  String get counterGuarding => 'En garde';

  @override
  String get counterCarryingObjective => 'Porte l\'objectif';

  @override
  String get counterUnderwater => 'Sous l\'eau';

  @override
  String get tooltipActivatedThisTurn => 'Activé ce tour-ci';

  @override
  String get tooltipMarkActivated => 'Marquer comme activé';

  @override
  String get tooltipRemoveSummoned => 'Retirer cette figurine invoquée';

  @override
  String get tooltipEditCounters => 'Modifier les marqueurs';

  @override
  String get counterToggleFailed =>
      'Impossible de mettre à jour le marqueur. Veuillez réessayer.';

  @override
  String get counterTapToToggle => 'Appuyez sur un marqueur pour l\'activer.';

  @override
  String get tooltipEditModel => 'Modifier marqueurs et jetons';

  @override
  String get actionActivate => 'Activer';

  @override
  String get actionActivated => 'Activé';

  @override
  String get tokenUpdateFailed =>
      'Impossible de mettre à jour le jeton. Veuillez réessayer.';

  @override
  String get tokenTabGeneric => 'Génériques';

  @override
  String get tokenTabCustom => 'Personnalisés';

  @override
  String get tokenTabPredefined => 'Prédéfinis';

  @override
  String get tokenSectionOnModel => 'Sur ce modèle';

  @override
  String get tokenSectionNew => 'Nouveau jeton';

  @override
  String get tokenLabelHint => 'Libellé — facultatif';

  @override
  String get tokenToggleable => 'Activable';

  @override
  String get tokenAdd => 'Ajouter le jeton';

  @override
  String get tokenNoLabel => 'Sans libellé';

  @override
  String get tokenNoneYet => 'Aucun jeton pour l\'instant.';

  @override
  String get tokenLabelTaken => 'Déjà sur ce modèle';

  @override
  String get tokenCountLabel => 'Compteur';

  @override
  String get tokenKindPlain => 'Simple';

  @override
  String get tokenKindToggle => 'Bascule';

  @override
  String get tokenKindCounter => 'Compteur';

  @override
  String get tokenColorLabel => 'Couleur';

  @override
  String get tokenPredefinedEmpty =>
      'Aucun sort ou buff à ajouter pour cette bande.';

  @override
  String get tokenPredefinedSoon =>
      'Bientôt : des jetons tirés des sorts et règles de ce modèle.';

  @override
  String get grantTooltipMask => 'Donner un masque';

  @override
  String get grantTooltipChoice => 'Faire un choix';

  @override
  String get grantChooseTarget => 'Choisir un modèle pour porter le masque';

  @override
  String get grantChooseEffect => 'Choisir un effet';

  @override
  String get grantNoTargets => 'Aucun modèle éligible pour porter ce masque.';

  @override
  String get grantGive => 'Donner le masque';

  @override
  String grantWornBy(String name) {
    return 'Porté par $name';
  }

  @override
  String get statUpdateReverted =>
      'Échec de l\'enregistrement — retour à la dernière valeur synchronisée.';

  @override
  String get statLifePoints => 'Points de vie';

  @override
  String get statWillPoints => 'Points de volonté';

  @override
  String get statCommandPoints => 'Points de commandement';

  @override
  String get summonTitle => 'Invoquer une figurine';

  @override
  String get summonBlurb =>
      'N\'importe quelle figurine peut être invoquée, de n\'importe quelle faction. Cela ne coûte aucun ducat.';

  @override
  String get summonSearchHint => 'Rechercher noms, capacités, règles...';

  @override
  String get summonNoModels => 'Aucune figurine trouvée.';

  @override
  String get summonFailed =>
      'Impossible d\'invoquer cette figurine. Veuillez réessayer.';

  @override
  String dismissTitle(String name) {
    return 'Retirer $name ?';
  }

  @override
  String get dismissBody =>
      'Cette figurine invoquée quitte la table. Ses blessures et ses marqueurs disparaissent avec elle.';

  @override
  String get gangNoMentorChosen => 'Aucun mentor choisi';

  @override
  String get gangNoSpells => 'Aucun sort';

  @override
  String get labelSpells => 'Sorts';

  @override
  String get labelApprenticeship => 'Apprentissage';

  @override
  String get gangRoleLeader => 'chef';

  @override
  String get gangRoleHero => 'héros';

  @override
  String get gangHired => 'Engagé';

  @override
  String get gangTabList => 'Liste';

  @override
  String get gangTabHire => 'Engager';

  @override
  String get gangGoToHire => 'Allez dans Engager pour ajouter des figurines';

  @override
  String get gangSectionMercenaries => 'Mercenaires';

  @override
  String get gangSectionEquipment => 'Équipement';

  @override
  String get gangNoProfilesForFaction => 'Aucun profil pour cette faction.';

  @override
  String get gangNothingMatches => 'Aucun résultat pour votre recherche.';

  @override
  String get gangSearchHint => 'Rechercher figurines, équipement, capacités...';

  @override
  String get sortRole => 'Rôle';

  @override
  String get sortName => 'Nom';

  @override
  String get sortCost => 'Coût';

  @override
  String pointsBarSlashLimit(int limit) {
    return ' / $limit ducats';
  }

  @override
  String pointsBarLeft(int count) {
    return '$count restants';
  }

  @override
  String pointsBarOverBy(int count) {
    return '−$count restants';
  }

  @override
  String cardsProfileCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count profils',
      one: '1 profil',
    );
    return '$_temp0';
  }

  @override
  String get cardsNoProfiles => 'Aucun profil trouvé.';

  @override
  String get cardSwitchIllustration => 'Changer d\'illustration';

  @override
  String cardViewerHint(int current, int total) {
    return '$current / $total  •  appuyer/←→ retourner  •  glisser ↑↓ naviguer';
  }

  @override
  String get cardAbilities => 'Capacités';

  @override
  String get cardAbilitiesLoadFailed => 'Impossible de charger les capacités.';

  @override
  String get cardNoAbilities => 'Ce personnage n\'a aucune capacité spéciale.';

  @override
  String get cardCharacterAbilities => 'Capacités de personnage';

  @override
  String get cardWeaponAbilities => 'Capacités d\'arme';

  @override
  String get rulesTitleUpper => 'RÈGLES';

  @override
  String get rulesAvailableOffline => 'Disponible hors ligne';

  @override
  String get rulesDownloadsOnOpen => 'Se télécharge à la première ouverture';

  @override
  String get rulesAttribution =>
      'Les PDF des règles sont publiés par TT Combat et servis depuis leur site. Carnevale est © TT Combat.';

  @override
  String get tooltipSearch => 'Rechercher';

  @override
  String get tooltipCloseSearch => 'Fermer la recherche';

  @override
  String get rulesSearchHint => 'Rechercher dans ce document';

  @override
  String get tooltipPreviousMatch => 'Résultat précédent';

  @override
  String get tooltipNextMatch => 'Résultat suivant';

  @override
  String get rulesMatchNone => 'Aucun';

  @override
  String rulesDownloadFailed(String title) {
    return 'Impossible de télécharger $title';
  }

  @override
  String rulesOpenFailed(String title) {
    return 'Impossible d\'ouvrir $title';
  }

  @override
  String rulesDownloadingPercent(int percent) {
    return 'Téléchargement — $percent %';
  }

  @override
  String get apprMentor => 'Mentor';

  @override
  String get apprNoMentor =>
      'Aucun mentor éligible — engagez d\'abord un Héros avec le mot-clé Docteur.';

  @override
  String get apprNoMentorSelected => '— Aucun mentor sélectionné —';

  @override
  String get apprAbilityToCopy => 'Capacité à copier';

  @override
  String get apprMageAbility =>
      'Mage — copie les Disciplines de sorts du mentor';

  @override
  String get apprCopyNote =>
      'La copie d\'une compétence unique ou d\'un profil d\'arme n\'est pas encore prise en charge — Mage est la seule capacité disponible ici.';

  @override
  String spellsButtonLabel(int cast, int total) {
    return 'Sorts · $cast/$total lancés';
  }

  @override
  String get spellsKnownTitle => 'Sorts connus';

  @override
  String get spellAllCantrips => 'Tous les cantrips';

  @override
  String get spellDeselectHint =>
      'Désélectionnez un sort d\'une autre Discipline pour choisir ici à la place.';

  @override
  String get spellPoolTitle => 'Réserve de sorts';

  @override
  String get spellNoMentorSetup =>
      'Aucun mentor choisi — configurez-en un via Apprentissage d\'abord';

  @override
  String spellMentorLabel(String name) {
    return 'Mentor : $name';
  }

  @override
  String spellUpToDisciplines(int count) {
    return 'jusqu\'à $count Disciplines à la fois';
  }

  @override
  String get spellNoDisciplineChosen => 'Aucune Discipline choisie';

  @override
  String spellsSlashCount(int count, int total) {
    return '$count/$total sorts';
  }

  @override
  String spellsKnownCountLong(int known, int total) {
    return '$known/$total sorts connus';
  }

  @override
  String get spellCantripOnly => 'Cantrip uniquement';

  @override
  String get spellDistinctPool =>
      'Doit être une Discipline différente de l\'autre réserve de cette figurine.';

  @override
  String get spellDistinctCopy =>
      'Déjà choisie par une autre copie de cette figurine dans le gang.';

  @override
  String spellsAndDisciplines(int spells, int slots, int chosen, int of) {
    return '$spells/$slots sorts connus · $chosen/$of Disciplines choisies';
  }

  @override
  String get spellAlwaysKnown => 'toujours connu';

  @override
  String get spellGranted => 'Accordés';

  @override
  String spellsPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sorts',
      one: '1 sort',
    );
    return '$_temp0';
  }

  @override
  String get spellGrantedLower => 'accordé';
}
