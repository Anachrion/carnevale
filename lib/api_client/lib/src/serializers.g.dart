// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers =
    (Serializers().toBuilder()
          ..add(Ability.serializer)
          ..add(AbilityCategoryEnum.serializer)
          ..add(Account.serializer)
          ..add(Agenda.serializer)
          ..add(AgendaHistoryEntry.serializer)
          ..add(AgendaHistoryEntryActionEnum.serializer)
          ..add(AgendaHistoryEntryAgenda.serializer)
          ..add(AgendaHistoryEntryOriginEnum.serializer)
          ..add(AvailableGang.serializer)
          ..add(CardManifestEntry.serializer)
          ..add(CardReference.serializer)
          ..add(CreateCableTicket201Response.serializer)
          ..add(CreateGameInput.serializer)
          ..add(DiscardAgendaInput.serializer)
          ..add(DiscardAgendaInputOriginEnum.serializer)
          ..add(DrawAgendaInput.serializer)
          ..add(DrawAgendaInputOriginEnum.serializer)
          ..add(DrawAgendasResponse.serializer)
          ..add(EntryIllustrationInput.serializer)
          ..add(EntryIllustrationInputEntry.serializer)
          ..add(EntryInput.serializer)
          ..add(EntryInputEntry.serializer)
          ..add(EntryInputEntryEntryTypeEnum.serializer)
          ..add(EntryPositionInput.serializer)
          ..add(EntryPositionInputEntry.serializer)
          ..add(EntryStatValue.serializer)
          ..add(EntryState.serializer)
          ..add(EntryUpgradeInput.serializer)
          ..add(EntryUpgradeInputEntry.serializer)
          ..add(Equipment.serializer)
          ..add(ForgotPasswordInput.serializer)
          ..add(ForgotPasswordInputUser.serializer)
          ..add(Game.serializer)
          ..add(GamePlayer.serializer)
          ..add(GamePlayerRoleEnum.serializer)
          ..add(GameStatusEnum.serializer)
          ..add(GameViewerVisibilityEnum.serializer)
          ..add(GangSummary.serializer)
          ..add(GetCardsManifest200Response.serializer)
          ..add(GrantedSpell.serializer)
          ..add(GrantedSpellDisciplineEnum.serializer)
          ..add(JoinGameInput.serializer)
          ..add(ListEntry.serializer)
          ..add(ListEntryEntryTypeEnum.serializer)
          ..add(ListInput.serializer)
          ..add(ListInputList.serializer)
          ..add(LoginInput.serializer)
          ..add(LoginInputUser.serializer)
          ..add(LogoutRequest.serializer)
          ..add(ModelList.serializer)
          ..add(PoolSpell.serializer)
          ..add(PoolSpellDisciplineEnum.serializer)
          ..add(Profile.serializer)
          ..add(RefreshInput.serializer)
          ..add(RegistrationInput.serializer)
          ..add(RegistrationInputUser.serializer)
          ..add(ResetPasswordInput.serializer)
          ..add(ResetPasswordInputUser.serializer)
          ..add(RoleInput.serializer)
          ..add(RoleInputRoleEnum.serializer)
          ..add(RulesDocument.serializer)
          ..add(Scenario.serializer)
          ..add(ScenarioAgendaRulesEnum.serializer)
          ..add(SelectGangInput.serializer)
          ..add(Session.serializer)
          ..add(SessionUser.serializer)
          ..add(SetEntrySpellsInput.serializer)
          ..add(SetEntrySpellsInputEntry.serializer)
          ..add(SetEntrySpellsInputEntryPoolSelectionsInner.serializer)
          ..add(
            SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum
                .serializer,
          )
          ..add(SpecialRule.serializer)
          ..add(Spell.serializer)
          ..add(SpellDisciplineEnum.serializer)
          ..add(SpellPool.serializer)
          ..add(SpellRuleRef.serializer)
          ..add(SummonModelRequest.serializer)
          ..add(Token.serializer)
          ..add(TokenColorEnum.serializer)
          ..add(UpdateAccountInput.serializer)
          ..add(UpdateAccountInputUser.serializer)
          ..add(UpdateCountersInput.serializer)
          ..add(UpdateCountersInputCounters.serializer)
          ..add(UpdateSpellCastInput.serializer)
          ..add(UpdateSpellCastInputSpellCast.serializer)
          ..add(UpdateStatsInput.serializer)
          ..add(UpdateStatsInputStats.serializer)
          ..add(UpdateTokenInput.serializer)
          ..add(ValidationErrors.serializer)
          ..add(Weapon.serializer)
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(Agenda)]),
            () => ListBuilder<Agenda>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(Agenda)]),
            () => ListBuilder<Agenda>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(AgendaHistoryEntry),
            ]),
            () => ListBuilder<AgendaHistoryEntry>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(CardManifestEntry),
            ]),
            () => ListBuilder<CardManifestEntry>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(GamePlayer)]),
            () => ListBuilder<GamePlayer>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(SetEntrySpellsInputEntryPoolSelectionsInner),
            ]),
            () => ListBuilder<SetEntrySpellsInputEntryPoolSelectionsInner>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(
                SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum,
              ),
            ]),
            () =>
                ListBuilder<
                  SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum
                >(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(int)]),
            () => ListBuilder<int>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(ListEntry)]),
            () => ListBuilder<ListEntry>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(ScenarioAgendaRulesEnum),
            ]),
            () => ListBuilder<ScenarioAgendaRulesEnum>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(SpellPool)]),
            () => ListBuilder<SpellPool>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(GrantedSpell)]),
            () => ListBuilder<GrantedSpell>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(PoolSpell)]),
            () => ListBuilder<PoolSpell>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(PoolSpell)]),
            () => ListBuilder<PoolSpell>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(String)]),
            () => ListBuilder<String>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(Weapon)]),
            () => ListBuilder<Weapon>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(SpecialRule)]),
            () => ListBuilder<SpecialRule>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(CardReference)]),
            () => ListBuilder<CardReference>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(Token)]),
            () => ListBuilder<Token>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType(BuiltList, const [const FullType(String)]),
            ]),
            () => MapBuilder<String, BuiltList<String>>(),
          ))
        .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
