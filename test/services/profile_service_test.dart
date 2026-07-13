import 'package:built_value/serializer.dart';
import 'package:carnevale/models/profile_query.dart';
import 'package:carnevale/services/profile_service.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';

/// The catalog is searched entirely on the device, so these exercise the real matching rules against
/// a miniature catalog: ratings stripped to a base facet, facets ANDed, free text sweeping every
/// string on the profile.
void main() {
  final service = ProfileService();

  List<String> namesOf(List<api.Profile> profiles) =>
      profiles.map((p) => p.name).toList()..sort();

  setUpAll(() async {
    final adapter = installFakeApi();
    adapter.stub(
      'GET',
      '/profiles',
      listBody<api.Profile>([
        fakeProfile(
          id: 1,
          name: 'Capodecina',
          faction: 'guild',
          keywords: const ['Leader'],
          abilities: const ['Brave', 'Acrobatic (2)'],
          weapons: [
            fakeWeapon(name: 'Stiletto', abilities: const ['Poisoned']),
          ],
          specialRules: [fakeSpecialRule(name: 'Blood Frenzy')],
        ),
        fakeProfile(
          id: 2,
          name: 'Bombardier',
          faction: 'guild',
          keywords: const ['Henchman'],
          abilities: const ['Brave'],
          weapons: [
            fakeWeapon(
              id: 2,
              name: 'Bomb',
              abilities: const ['Blast', 'Reload (2)'],
            ),
          ],
        ),
        fakeProfile(
          id: 3,
          name: 'Doge',
          faction: 'patricians',
          keywords: const ['Leader'],
          abilities: const ['Fear (1)'],
          specialRules: [
            fakeSpecialRule(
              id: 2,
              name: 'Patron of the Arts',
              description: 'Inspires nearby models.',
              spellName: 'Blood Boil',
              spellDescription: 'Boils the blood of a target.',
            ),
          ],
        ),
        fakeProfile(
          id: 4,
          name: 'Advanced Hybrid',
          faction: 'rashaar',
          keywords: const ['Henchman'],
          abilities: const ['Acrobatic (3)'],
        ),
      ], const FullType(api.Profile)),
    );
    await service.loadAll();
  });

  group('matching', () {
    test('an empty query returns the whole catalog', () {
      expect(service.matching(const ProfileQuery()).length, 4);
    });

    test('free text still matches a name', () {
      expect(namesOf(service.matching(const ProfileQuery(text: 'capo'))), [
        'Capodecina',
      ]);
    });

    test(
      'free text reaches abilities, keywords, weapons and special rules',
      () {
        // An ability, on two models.
        expect(namesOf(service.matching(const ProfileQuery(text: 'brave'))), [
          'Bombardier',
          'Capodecina',
        ]);
        // A weapon's name, and a weapon ability.
        expect(
          namesOf(service.matching(const ProfileQuery(text: 'stiletto'))),
          ['Capodecina'],
        );
        expect(namesOf(service.matching(const ProfileQuery(text: 'blast'))), [
          'Bombardier',
        ]);
        // A special rule's name, and the spell it grants.
        expect(
          namesOf(service.matching(const ProfileQuery(text: 'blood frenzy'))),
          ['Capodecina'],
        );
        expect(
          namesOf(service.matching(const ProfileQuery(text: 'blood boil'))),
          ['Doge'],
        );
      },
    );

    test('every word must match, so extra words narrow the results', () {
      expect(
        namesOf(service.matching(const ProfileQuery(text: 'brave leader'))),
        ['Capodecina'],
      );
      expect(service.matching(const ProfileQuery(text: 'brave doge')), isEmpty);
    });

    test('an ability facet ignores the "(X)" rating', () {
      // "Acrobatic (2)" and "Acrobatic (3)" are the same ability.
      expect(
        namesOf(
          service.matching(
            ProfileQuery(facets: {Facet(FacetKind.ability, 'Acrobatic')}),
          ),
        ),
        ['Advanced Hybrid', 'Capodecina'],
      );
    });

    test('facets are ANDed: leaders who are also brave', () {
      expect(
        namesOf(
          service.matching(
            ProfileQuery(
              facets: {
                Facet(FacetKind.keyword, 'Leader'),
                Facet(FacetKind.ability, 'Brave'),
              },
            ),
          ),
        ),
        ['Capodecina'],
      );
    });

    test('a weapon-ability facet matches the model carrying the weapon', () {
      expect(
        namesOf(
          service.matching(
            ProfileQuery(facets: {Facet(FacetKind.weaponAbility, 'Reload')}),
          ),
        ),
        ['Bombardier'],
      );
    });

    test('facets, faction and text all narrow together', () {
      expect(
        service
            .matching(
              ProfileQuery(
                text: 'bomb',
                factions: {'guild'},
                facets: {Facet(FacetKind.ability, 'Brave')},
              ),
            )
            .single
            .name,
        'Bombardier',
      );
      // Same query against the wrong faction finds nothing.
      expect(
        service.matching(
          ProfileQuery(
            text: 'bomb',
            factions: {'rashaar'},
            facets: {Facet(FacetKind.ability, 'Brave')},
          ),
        ),
        isEmpty,
      );
    });
  });

  group('suggest', () {
    test('offers matching facets with their catalog count', () {
      final hits = service.suggest('brav');
      expect(hits.single.facet, const Facet(FacetKind.ability, 'Brave'));
      expect(hits.single.count, 2);
    });

    test(
      'offers keywords and weapon abilities, not just character abilities',
      () {
        expect(
          service.suggest('lead').single.facet,
          const Facet(FacetKind.keyword, 'Leader'),
        );
        expect(
          service.suggest('poison').single.facet,
          const Facet(FacetKind.weaponAbility, 'Poisoned'),
        );
      },
    );

    test('ranks prefix matches first, then the most common facets', () {
      // Only "Acrobatic" starts with an "a", so it leads despite tying on count; the rest contain
      // one, and fall back to count (2 each) then alphabetical order.
      final hits = service.suggest('a');
      expect(hits.take(4).map((h) => h.facet.name), [
        'Acrobatic',
        'Brave',
        'Henchman',
        'Leader',
      ]);
    });

    test('never offers a facet the user already picked', () {
      expect(
        service.suggest(
          'brav',
          exclude: {const Facet(FacetKind.ability, 'Brave')},
        ),
        isEmpty,
      );
    });

    test('an empty query offers nothing', () {
      expect(service.suggest('   '), isEmpty);
    });
  });
}
