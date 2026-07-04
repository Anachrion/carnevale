#!/usr/bin/env bash
set -euo pipefail

SPEC="../carnevale-backend/doc/openapi.yaml"
OUT="lib/api_client"

openapi-generator generate \
  -i "$SPEC" \
  -g dart-dio \
  -o "$OUT" \
  --additional-properties=pubName=carnevale_api,pubAuthor=Anachrion

# The dart-dio generator has a bug: schemas named "List" conflict with Dart's
# built-in List type, so every method that should return ModelList is generated
# as returning BuiltList instead. Apply fixes:

# Align SDK version with the main package so library and .g.dart parts share the same language version
sed -i '' "s/sdk: '>=2.18.0 <4.0.0'/sdk: '>=3.12.0 <4.0.0'/" "$OUT/pubspec.yaml"

LISTS_API="$OUT/lib/src/api/lists_api.dart"
LIST_ENTRIES_API="$OUT/lib/src/api/list_entries_api.dart"
GAMES_API="$OUT/lib/src/api/games_api.dart"
SERIALIZERS="$OUT/lib/src/serializers.dart"

# lists_api.dart — add ModelList import, fix all BuiltList return types
sed -i '' "s|import 'package:carnevale_api/src/model/list_input.dart';|import 'package:carnevale_api/src/model/list_input.dart';\nimport 'package:carnevale_api/src/model/model_list.dart';|" "$LISTS_API"
sed -i '' 's/Future<Response<BuiltList<BuiltList>>>/Future<Response<BuiltList<ModelList>>>/g' "$LISTS_API"
sed -i '' 's/BuiltList<BuiltList>? _responseData/BuiltList<ModelList>? _responseData/g' "$LISTS_API"
sed -i '' 's/FullType(BuiltList, \[FullType(BuiltList)\])/FullType(BuiltList, [FullType(ModelList)])/g' "$LISTS_API"
sed -i '' 's/as BuiltList<BuiltList>/as BuiltList<ModelList>/g' "$LISTS_API"
sed -i '' 's/Response<BuiltList<BuiltList>>/Response<BuiltList<ModelList>>/g' "$LISTS_API"
sed -i '' 's/Future<Response<BuiltList>> createList(/Future<Response<ModelList>> createList(/g' "$LISTS_API"
sed -i '' 's/Future<Response<BuiltList>> getList(/Future<Response<ModelList>> getList(/g' "$LISTS_API"
sed -i '' 's/Future<Response<BuiltList>> updateList(/Future<Response<ModelList>> updateList(/g' "$LISTS_API"
sed -i '' 's/BuiltList? _responseData/ModelList? _responseData/g' "$LISTS_API"
sed -i '' 's/FullType(BuiltList),/FullType(ModelList),/g' "$LISTS_API"
sed -i '' 's/) as BuiltList;/) as ModelList;/g' "$LISTS_API"
sed -i '' 's/Response<BuiltList>(/Response<ModelList>(/g' "$LISTS_API"

# list_entries_api.dart — add ModelList import, fix BuiltList return types
sed -i '' "s|import 'package:carnevale_api/src/model/entry_input.dart';|import 'package:carnevale_api/src/model/entry_input.dart';\nimport 'package:carnevale_api/src/model/model_list.dart';|" "$LIST_ENTRIES_API"
sed -i '' 's/Future<Response<BuiltList>>/Future<Response<ModelList>>/g' "$LIST_ENTRIES_API"
sed -i '' 's/BuiltList? _responseData/ModelList? _responseData/g' "$LIST_ENTRIES_API"
sed -i '' 's/FullType(BuiltList),/FullType(ModelList),/g' "$LIST_ENTRIES_API"
sed -i '' 's/) as BuiltList;/) as ModelList;/g' "$LIST_ENTRIES_API"
sed -i '' 's/Response<BuiltList>(/Response<ModelList>(/g' "$LIST_ENTRIES_API"

# games_api.dart — add ModelList import, fix BuiltList return type for getPlayerList
sed -i '' "s|import 'package:carnevale_api/src/model/create_game_input.dart';|import 'package:carnevale_api/src/model/create_game_input.dart';\nimport 'package:carnevale_api/src/model/model_list.dart';|" "$GAMES_API"
sed -i '' 's/Future<Response<BuiltList>>/Future<Response<ModelList>>/g' "$GAMES_API"
sed -i '' 's/BuiltList? _responseData/ModelList? _responseData/g' "$GAMES_API"
sed -i '' 's/FullType(BuiltList),/FullType(ModelList),/g' "$GAMES_API"
sed -i '' 's/) as BuiltList;/) as ModelList;/g' "$GAMES_API"
sed -i '' 's/Response<BuiltList>(/Response<ModelList>(/g' "$GAMES_API"

# serializers.dart — fix BuiltList<BuiltList> builder to BuiltList<ModelList>
sed -i '' 's/FullType(BuiltList, \[FullType(BuiltList)\])/FullType(BuiltList, [FullType(ModelList)])/g' "$SERIALIZERS"
sed -i '' 's/ListBuilder<BuiltList>()/ListBuilder<ModelList>()/g' "$SERIALIZERS"

echo "✓ API generated and patched. Now run:"
echo "  dart run build_runner build --delete-conflicting-outputs"
