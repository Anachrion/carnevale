import 'package:test/test.dart';
import 'package:carnevale_api/carnevale_api.dart';

// tests for AgendaHistoryEntry
void main() {
  final instance = AgendaHistoryEntryBuilder();
  // TODO add properties to the builder and call build()

  group(AgendaHistoryEntry, () {
    // int turn
    test('to test the property `turn`', () async {
      // TODO
    });

    // String action
    test('to test the property `action`', () async {
      // TODO
    });

    // Why this event happened. Always null for `scored` events — scoring just resolves the Agenda's own printed condition, it isn't granted by an external rule the way drawing/discarding mid-game is.
    // String origin
    test('to test the property `origin`', () async {
      // TODO
    });

    // Set only when origin is `recycle` — the id of the scored/discarded event (within this same list) that triggered this replacement draw.
    // int causedByEventId
    test('to test the property `causedByEventId`', () async {
      // TODO
    });

    // AgendaHistoryEntryAgenda agenda
    test('to test the property `agenda`', () async {
      // TODO
    });

  });
}
