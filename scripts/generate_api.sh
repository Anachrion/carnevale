#!/usr/bin/env bash
set -euo pipefail

SPEC="../carnevale-backend/doc/openapi.yaml"
OUT="lib/api_client"

# Portable across macOS (BSD) and Linux (GNU): the CLI is packaged as `openapi-generator` (brew) or
# `openapi-generator-cli` (npm), and in-place sed takes `-i ''` on BSD but `-i` on GNU.
GEN="$(command -v openapi-generator || command -v openapi-generator-cli)"
sedi() { if sed --version >/dev/null 2>&1; then sed -i "$@"; else sed -i '' "$@"; fi; }

"$GEN" generate \
  -i "$SPEC" \
  -g dart-dio \
  -o "$OUT" \
  --additional-properties=pubName=carnevale_api,pubAuthor=Anachrion

# The dart-dio generator has a bug: schemas named "List" conflict with Dart's
# built-in List type, so every method that should return ModelList is generated
# as returning BuiltList instead. Apply fixes:

# Align SDK version with the main package so library and .g.dart parts share the same language version
sedi "s/sdk: '>=2.18.0 <4.0.0'/sdk: '>=3.12.0 <4.0.0'/" "$OUT/pubspec.yaml"

LISTS_API="$OUT/lib/src/api/lists_api.dart"
LIST_ENTRIES_API="$OUT/lib/src/api/list_entries_api.dart"
GAMES_API="$OUT/lib/src/api/games_api.dart"
SERIALIZERS="$OUT/lib/src/serializers.dart"

# lists_api.dart — add ModelList import, fix all BuiltList return types
sedi "s|import 'package:carnevale_api/src/model/list_input.dart';|import 'package:carnevale_api/src/model/list_input.dart';\nimport 'package:carnevale_api/src/model/model_list.dart';|" "$LISTS_API"
sedi 's/Future<Response<BuiltList<BuiltList>>>/Future<Response<BuiltList<ModelList>>>/g' "$LISTS_API"
sedi 's/BuiltList<BuiltList>? _responseData/BuiltList<ModelList>? _responseData/g' "$LISTS_API"
sedi 's/FullType(BuiltList, \[FullType(BuiltList)\])/FullType(BuiltList, [FullType(ModelList)])/g' "$LISTS_API"
sedi 's/as BuiltList<BuiltList>/as BuiltList<ModelList>/g' "$LISTS_API"
sedi 's/Response<BuiltList<BuiltList>>/Response<BuiltList<ModelList>>/g' "$LISTS_API"
sedi 's/Future<Response<BuiltList>> createList(/Future<Response<ModelList>> createList(/g' "$LISTS_API"
sedi 's/Future<Response<BuiltList>> getList(/Future<Response<ModelList>> getList(/g' "$LISTS_API"
sedi 's/Future<Response<BuiltList>> updateList(/Future<Response<ModelList>> updateList(/g' "$LISTS_API"
sedi 's/BuiltList? _responseData/ModelList? _responseData/g' "$LISTS_API"
sedi 's/FullType(BuiltList),/FullType(ModelList),/g' "$LISTS_API"
sedi 's/) as BuiltList;/) as ModelList;/g' "$LISTS_API"
sedi 's/Response<BuiltList>(/Response<ModelList>(/g' "$LISTS_API"

# list_entries_api.dart — add ModelList import, fix BuiltList return types
sedi "s|import 'package:carnevale_api/src/model/entry_input.dart';|import 'package:carnevale_api/src/model/entry_input.dart';\nimport 'package:carnevale_api/src/model/model_list.dart';|" "$LIST_ENTRIES_API"
sedi 's/Future<Response<BuiltList>>/Future<Response<ModelList>>/g' "$LIST_ENTRIES_API"
sedi 's/BuiltList? _responseData/ModelList? _responseData/g' "$LIST_ENTRIES_API"
sedi 's/FullType(BuiltList),/FullType(ModelList),/g' "$LIST_ENTRIES_API"
sedi 's/) as BuiltList;/) as ModelList;/g' "$LIST_ENTRIES_API"
sedi 's/Response<BuiltList>(/Response<ModelList>(/g' "$LIST_ENTRIES_API"

# games_api.dart — add ModelList import, fix BuiltList return type for getPlayerList
sedi "s|import 'package:carnevale_api/src/model/create_game_input.dart';|import 'package:carnevale_api/src/model/create_game_input.dart';\nimport 'package:carnevale_api/src/model/model_list.dart';|" "$GAMES_API"
sedi 's/Future<Response<BuiltList>>/Future<Response<ModelList>>/g' "$GAMES_API"
sedi 's/BuiltList? _responseData/ModelList? _responseData/g' "$GAMES_API"
sedi 's/FullType(BuiltList),/FullType(ModelList),/g' "$GAMES_API"
sedi 's/) as BuiltList;/) as ModelList;/g' "$GAMES_API"
sedi 's/Response<BuiltList>(/Response<ModelList>(/g' "$GAMES_API"

# serializers.dart — fix BuiltList<BuiltList> builder to BuiltList<ModelList>
sedi 's/FullType(BuiltList, \[FullType(BuiltList)\])/FullType(BuiltList, [FullType(ModelList)])/g' "$SERIALIZERS"
sedi 's/ListBuilder<BuiltList>()/ListBuilder<ModelList>()/g' "$SERIALIZERS"

# gang_import_result.dart — the same "List" collision. POST /lists/import answers { list, warnings },
# and the generator types that `list` as Dart's BuiltList instead of the ModelList schema, so the
# gang comes back untyped and unusable.
#
# Only the *bare* `FullType(BuiltList)` is the gang; `warnings` is a genuine BuiltList<String> and
# its `FullType(BuiltList, [FullType(String)])` must survive untouched — hence matching the trailing
# comma rather than the bare name.
IMPORT_RESPONSE="$OUT/lib/src/model/gang_import_result.dart"
sedi "s|import 'package:built_collection/built_collection.dart';|import 'package:built_collection/built_collection.dart';\nimport 'package:carnevale_api/src/model/model_list.dart';|" "$IMPORT_RESPONSE"
sedi 's/  BuiltList get list;/  ModelList get list;/' "$IMPORT_RESPONSE"
sedi 's/const FullType(BuiltList),/const FullType(ModelList),/g' "$IMPORT_RESPONSE"
sedi 's/) as BuiltList;/) as ModelList;/g' "$IMPORT_RESPONSE"

echo "✓ API generated and patched. Now run:"
echo "  dart run build_runner build --delete-conflicting-outputs"
