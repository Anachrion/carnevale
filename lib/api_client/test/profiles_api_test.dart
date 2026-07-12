import 'package:test/test.dart';
import 'package:carnevale_api/carnevale_api.dart';

/// tests for ProfilesApi
void main() {
  final instance = CarnevaleApi().getProfilesApi();

  group(ProfilesApi, () {
    // Get a profile
    //
    //Future<Profile> getProfile(int id) async
    test('test getProfile', () async {
      // TODO
    });

    // List all profiles
    //
    //Future<BuiltList<Profile>> getProfiles({ String faction }) async
    test('test getProfiles', () async {
      // TODO
    });
  });
}
