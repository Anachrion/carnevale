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

/// The site that links handed to *other people* point at (CARNEVALEB-74).
///
/// Deliberately not `ApiClient.origin`. That is where this particular build talks to, and it
/// defaults to a local dev server — so a shared link built on it reads `http://localhost:3000/join`
/// or, from the Android emulator, `http://10.0.2.2:3000/join`. Those are correct addresses for the
/// phone that produced them and useless to everyone else, which is the one thing a shared link
/// cannot be.
///
/// So this is a constant of the product, not of the build: the public site, over https, matching
/// the hosts the Android manifest claims as App Links and the paths Rails serves the app at. It
/// stays overridable for a staging site that serves its own copy of the app, but the default is the
/// real one — the opposite trade-off from API_HOST, and for the opposite reason.
const shareSiteOrigin = String.fromEnvironment(
  'SHARE_SITE_ORIGIN',
  defaultValue: 'https://carnevale-app.com',
);
