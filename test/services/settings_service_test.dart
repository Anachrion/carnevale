import 'package:carnevale/services/settings_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('card download mode', () {
    test('defaults to on-demand', () async {
      SharedPreferences.setMockInitialValues({});
      final service = SettingsService();
      await service.load();
      expect(service.cardDownloadMode, CardDownloadMode.onDemand);
    });

    test('persists a change and restores it on the next load', () async {
      SharedPreferences.setMockInitialValues({});
      final service = SettingsService();

      await service.setCardDownloadMode(CardDownloadMode.wifiOnly);
      expect(service.cardDownloadMode, CardDownloadMode.wifiOnly);

      // A fresh load (as at app launch) reads it back from storage.
      await service.load();
      expect(service.cardDownloadMode, CardDownloadMode.wifiOnly);
    });
  });
}
