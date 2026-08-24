// Carnevale Companion
// Copyright (C) 2026 Anachrion and contributors
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
// details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

/// The two gates in front of the Collection feature (CARNEVALEB-76).
///
/// Both answers come from the *account*, not from local settings: someone who tracks a collection
/// does it the same way on every device they own, so the switches follow them from phone to tablet
/// to web exactly as the collection itself does. Signed out there is no account and therefore no
/// collection, and every screen behaves exactly as it did before the feature existed.
library;

import 'main.dart';

/// Whether the feature is offered at all — the home-screen entry and the menu item.
///
/// This is what the Settings switch drives. It stays true through the introduction, so a player
/// who has not switched the feature on yet can still find their way to it.
bool get collectionOffered =>
    authService.currentUser?.collectionVisible ?? false;

/// Whether the feature is live: the marks in the catalogue and the hire list, the collection button
/// on a card, the summary in the gang builder.
///
/// Hiding the feature in the settings switches all of that off without forgetting that it had been
/// turned on, so switching it back returns to the collection rather than to the introduction.
bool get collectionLive =>
    collectionOffered && (authService.currentUser?.collectionEnabled ?? false);
