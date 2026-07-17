// Copyright 2026 Anachrion
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// The dimension a [Facet] filters on. Each is a small, closed vocabulary the catalog defines by
/// example — across the 312 profiles there are ~35 character abilities, ~26 keywords and 13 weapon
/// abilities — so the whole thing can be indexed on the device and offered as suggestions.
enum FacetKind { keyword, ability, weaponAbility }

extension FacetKindLabel on FacetKind {
  String get label => switch (this) {
    FacetKind.keyword => 'keyword',
    FacetKind.ability => 'ability',
    FacetKind.weaponAbility => 'weapon',
  };
}

/// One picked filter, e.g. the `Leader` keyword or the `Brave` ability.
///
/// The name is always the *base* name, with any "(X)" rating stripped (see
/// [AbilityService.baseName]): a profile prints "Acrobatic (2)" or "Acrobatic (3)", but both are
/// the one `Acrobatic` ability, and a filter on it must match either.
class Facet {
  const Facet(this.kind, this.name);

  final FacetKind kind;
  final String name;

  @override
  bool operator ==(Object other) =>
      other is Facet && other.kind == kind && other.name == name;

  @override
  int get hashCode => Object.hash(kind, name);

  @override
  String toString() => '${kind.label}:$name';
}

/// A search over the catalog: free text, plus any number of exact filters.
///
/// The three dimensions combine as: faction is OR (any of the picked factions), facets are AND
/// (a model must carry *every* one — two ability facets mean "has both"), and the text must match
/// on top of that. So "leaders who are brave" is the `Leader` keyword facet and the `Brave` ability
/// facet together, which is the question a single text box cannot ask.
class ProfileQuery {
  const ProfileQuery({
    this.text = '',
    this.factions = const {},
    this.facets = const {},
  });

  /// Free text, swept across the profile's name, keywords, abilities, weapons and special rules.
  final String text;
  final Set<String> factions;
  final Set<Facet> facets;

  bool get isEmpty =>
      text.trim().isEmpty && factions.isEmpty && facets.isEmpty;
}

/// A facet offered as you type, with the number of models in the catalog that carry it.
class FacetSuggestion {
  const FacetSuggestion({required this.facet, required this.count});

  final Facet facet;

  /// How many profiles in the catalog carry this facet.
  final int count;
}
