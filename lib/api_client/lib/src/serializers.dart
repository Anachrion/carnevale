//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:carnevale_api/src/date_serializer.dart';
import 'package:carnevale_api/src/model/date.dart';

import 'package:carnevale_api/src/model/agenda.dart';
import 'package:carnevale_api/src/model/agenda_history_entry.dart';
import 'package:carnevale_api/src/model/agenda_history_entry_agenda.dart';
import 'package:carnevale_api/src/model/available_gang.dart';
import 'package:carnevale_api/src/model/card_reference.dart';
import 'package:carnevale_api/src/model/create_game_input.dart';
import 'package:carnevale_api/src/model/discard_agenda_input.dart';
import 'package:carnevale_api/src/model/draw_agenda_input.dart';
import 'package:carnevale_api/src/model/draw_agendas_response.dart';
import 'package:carnevale_api/src/model/entry_input.dart';
import 'package:carnevale_api/src/model/entry_input_entry.dart';
import 'package:carnevale_api/src/model/entry_position_input.dart';
import 'package:carnevale_api/src/model/entry_position_input_entry.dart';
import 'package:carnevale_api/src/model/entry_stat_value.dart';
import 'package:carnevale_api/src/model/entry_state.dart';
import 'package:carnevale_api/src/model/equipment.dart';
import 'package:carnevale_api/src/model/forgot_password_input.dart';
import 'package:carnevale_api/src/model/forgot_password_input_user.dart';
import 'package:carnevale_api/src/model/game.dart';
import 'package:carnevale_api/src/model/game_player.dart';
import 'package:carnevale_api/src/model/gang_summary.dart';
import 'package:carnevale_api/src/model/join_game_input.dart';
import 'package:carnevale_api/src/model/list_entry.dart';
import 'package:carnevale_api/src/model/list_input.dart';
import 'package:carnevale_api/src/model/list_input_list.dart';
import 'package:carnevale_api/src/model/login_input.dart';
import 'package:carnevale_api/src/model/login_input_user.dart';
import 'package:carnevale_api/src/model/model_list.dart';
import 'package:carnevale_api/src/model/profile.dart';
import 'package:carnevale_api/src/model/registration_input.dart';
import 'package:carnevale_api/src/model/registration_input_user.dart';
import 'package:carnevale_api/src/model/reset_password_input.dart';
import 'package:carnevale_api/src/model/reset_password_input_user.dart';
import 'package:carnevale_api/src/model/role_input.dart';
import 'package:carnevale_api/src/model/scenario.dart';
import 'package:carnevale_api/src/model/score_agenda_input.dart';
import 'package:carnevale_api/src/model/select_gang_input.dart';
import 'package:carnevale_api/src/model/session.dart';
import 'package:carnevale_api/src/model/session_user.dart';
import 'package:carnevale_api/src/model/set_entry_spells_input.dart';
import 'package:carnevale_api/src/model/set_entry_spells_input_entry.dart';
import 'package:carnevale_api/src/model/special_rule.dart';
import 'package:carnevale_api/src/model/spell.dart';
import 'package:carnevale_api/src/model/update_account_input.dart';
import 'package:carnevale_api/src/model/update_account_input_user.dart';
import 'package:carnevale_api/src/model/update_counters_input.dart';
import 'package:carnevale_api/src/model/update_counters_input_counters.dart';
import 'package:carnevale_api/src/model/update_stats_input.dart';
import 'package:carnevale_api/src/model/update_stats_input_stats.dart';
import 'package:carnevale_api/src/model/validation_errors.dart';
import 'package:carnevale_api/src/model/weapon.dart';

part 'serializers.g.dart';

@SerializersFor([
  Agenda,
  AgendaHistoryEntry,
  AgendaHistoryEntryAgenda,
  AvailableGang,
  CardReference,
  CreateGameInput,
  DiscardAgendaInput,
  DrawAgendaInput,
  DrawAgendasResponse,
  EntryInput,
  EntryInputEntry,
  EntryPositionInput,
  EntryPositionInputEntry,
  EntryStatValue,
  EntryState,
  Equipment,
  ForgotPasswordInput,
  ForgotPasswordInputUser,
  Game,
  GamePlayer,
  GangSummary,
  JoinGameInput,
  ListEntry,
  ListInput,
  ListInputList,
  LoginInput,
  LoginInputUser,
  ModelList,
  Profile,
  RegistrationInput,
  RegistrationInputUser,
  ResetPasswordInput,
  ResetPasswordInputUser,
  RoleInput,
  Scenario,
  ScoreAgendaInput,
  SelectGangInput,
  Session,
  SessionUser,
  SetEntrySpellsInput,
  SetEntrySpellsInputEntry,
  SpecialRule,
  Spell,
  UpdateAccountInput,
  UpdateAccountInputUser,
  UpdateCountersInput,
  UpdateCountersInputCounters,
  UpdateStatsInput,
  UpdateStatsInputStats,
  ValidationErrors,
  Weapon,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Equipment)]),
        () => ListBuilder<Equipment>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Spell)]),
        () => ListBuilder<Spell>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Game)]),
        () => ListBuilder<Game>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Scenario)]),
        () => ListBuilder<Scenario>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Profile)]),
        () => ListBuilder<Profile>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ModelList)]),
        () => ListBuilder<ModelList>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(AvailableGang)]),
        () => ListBuilder<AvailableGang>(),
      )
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer())
    ).build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
