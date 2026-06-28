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

import 'package:carnevale_api/src/model/card_reference.dart';
import 'package:carnevale_api/src/model/entry_input.dart';
import 'package:carnevale_api/src/model/entry_input_entry.dart';
import 'package:carnevale_api/src/model/entry_position_input.dart';
import 'package:carnevale_api/src/model/entry_position_input_entry.dart';
import 'package:carnevale_api/src/model/list_entry.dart';
import 'package:carnevale_api/src/model/list_input.dart';
import 'package:carnevale_api/src/model/list_input_list.dart';
import 'package:carnevale_api/src/model/model_list.dart';
import 'package:carnevale_api/src/model/profile.dart';
import 'package:carnevale_api/src/model/special_rule.dart';
import 'package:carnevale_api/src/model/validation_errors.dart';
import 'package:carnevale_api/src/model/weapon.dart';

part 'serializers.g.dart';

@SerializersFor([
  CardReference,
  EntryInput,
  EntryInputEntry,
  EntryPositionInput,
  EntryPositionInputEntry,
  ListEntry,
  ListInput,
  ListInputList,
  ModelList,
  Profile,
  SpecialRule,
  ValidationErrors,
  Weapon,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Profile)]),
        () => ListBuilder<Profile>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ModelList)]),
        () => ListBuilder<ModelList>(),
      )
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer())
    ).build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
