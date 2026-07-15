# Code review — Carnevale app & backend

Full review of the two repositories, conducted on 2026-07-15:

- `carnevale-anachrion` (this repo) — the Flutter companion app, reviewed at commit `6718d58` (findings re-checked against `8c19811`, which added a Role sort to the Cards page and a dev-only `dev.sh` change; no finding is affected)
- `carnevale-backend` — the Rails 8.1 API + backoffice, reviewed at commit `a33d7e4`

The review focused on: bugs, oversights around multiple/asynchronous data sources, smartphone-specific concerns (flaky networks, backgrounding, data usage, memory), details that could make features silently not work, and general code quality and maintainability. The card sync pipeline (catalog JSON + card images) was reviewed end-to-end as its own subject.

Every finding below was verified against the actual code (both sides where a claim depends on the other repo). Locations are given as `file:line` at the commits above. Findings have stable IDs (`C-n` critical, `B-n` backend, `A-n` app, `S-n` card sync) so they can be referenced in tickets.

**Severity scale:**

- **Critical** — security exposure, permanent data corruption, or a core feature breaking under normal use.
- **Major** — a real user-facing failure under plausible conditions (races both players will hit, offline/flaky network, retries), or spec drift that breaks the generated client.
- **Minor** — edge cases, latent bugs, hygiene, performance.

---

## Executive summary

The codebases are well-crafted on the happy path: consistent conventions, unusually good comments, solid backend test coverage, careful REST authorization, and genuinely well-designed subsystems (cable tickets, card image versioning, catalog snapshot). The serious findings cluster into four themes:

1. **Backend concurrency** — a repeated *check in-memory state → mutate → maybe transition* pattern without locks. Two players acting simultaneously (the normal case in a two-player lobby) can double-deal agenda hands, create 3-player games, destroy a list mid-game, or lose the game's completed status. One shared `with_lock` helper eliminates the class.
2. **App connection resilience** — the app assumes a reliable network. No Dio timeouts anywhere, no dead-socket detection, no app-lifecycle handling, REST mutation responses discarded in favour of websocket echoes, and an infinite 401 loop on token expiry.
3. **Silent error handling in the app UI** — the gang builder and list screens perform mutations with `try/finally` and no `catch`: offline failures produce ghost entries, duplicate gangs, permanent spinners, and a back-button trap.
4. **Card sync coherence** — catalog JSON and card images travel two independent pipelines with no shared version signal. Stale-JSON-with-fresh-images (and the reverse) is reachable in at least five distinct ways, plus a ~600 MB unconsented first-launch download on whatever network is available.

Two standalone security criticals: production seeding creates a backoffice admin with a hardcoded password from the public repo, and an unvalidated polymorphic type lets a single API request semi-permanently brick an account.

---

## 1. Critical findings

### C-1. Production can boot with a publicly-known backoffice admin password

**Backend — `db/seeds.rb:51-54`, `bin/docker-entrypoint:4-6`**

Seeds create `admin@dev.local` / `password123` with `admin: true` (the `.update!(admin: true)` re-asserts admin on every seed run), plus `player1@dev.local` / `player2@dev.local` with the same password. The production Docker entrypoint runs `rails db:prepare`, which **seeds a freshly created database**.

**Failure scenario:** first production boot against a new database (initial deploy, disaster recovery, new environment) creates these accounts. Anyone who reads the public repository can sign in at `/users/sign_in` with full backoffice control: edit the entire catalog, overwrite `public/cards`, and publish altered cards to every app user.

**Suggested fix:** guard the dev accounts with `unless Rails.env.production?` (or move them to a conditionally-loaded `db/seeds/development.rb`), and never seed a static admin password — create no admin in production, or read credentials from ENV.

### C-2. Unvalidated polymorphic `entry_type` lets one request brick an account

**Backend — `app/models/gang/entry.rb:8`, `app/controllers/api/v1/list_entries_controller.rb:9-11`**

`entry_type` is client-controlled and has no inclusion validation anywhere; the polymorphic `belongs_to` will constantize any ActiveRecord class name.

**Failure scenario:** `POST /api/v1/list_entries` with `entry: { entry_type: "Encounter::Game", entry_id: <any id> }` (or `"User"`, `"Gang::List"`…) saves successfully. `ListSortingService` and `EntrySerializer` then call `.cost`/`.name` on the foreign object and raise `NoMethodError`: every subsequent `GET /lists`, `GET /lists/:id`, list snapshot, and the opponent-facing `GET /games/:id/players/:pid/list` returns 500. Even `DELETE` on the bad entry 500s inside the `after_commit` revalidation, so the account's list/game flows are semi-permanently broken. It also enables a limited cross-user data probe (`.name` of arbitrary records by id, e.g. another user's game name).

**Suggested fix:** `validates :entry_type, inclusion: { in: %w[Catalog::CardReference Catalog::Equipment] }` on `Gang::Entry` (this matches the OpenAPI enum) and reject early in the controller.

### C-3. Concurrent `select_gang` deals both opening agenda hands twice

**Backend — `app/controllers/api/v1/games_controller.rb:331-344`, `app/models/encounter/agenda_deck.rb:16-23`**

`maybe_advance_to_agenda_draw!` guards the phase transition with the in-memory `@game.status` loaded at request start, and takes no lock. `AgendaDeck#draw_initial` starts from `drawn = []`, excluding only its own batch — not existing drawn events.

**Failure scenario:** both players tap "Select" within each other's request window — very likely, since they are sitting at the same table being told to pick a gang. Both requests see `status == "gang_selection"`, both see two lists committed, both run the transaction: `draw_initial` runs **twice per player**. With a large agenda pool the second deal usually doesn't collide with the unique `(game_player_id, agenda_id, action)` index, so it commits: each player has a 6-card hand instead of 3, with no in-app way to shed the extras (mulligan is 1-for-1). If it does collide, the loser gets an unrescued `RecordInvalid` → 500.

**Suggested fix:** wrap the check-and-deal in `@game.with_lock { break unless @game.reload.gang_selection?; ... }`, and make `draw_initial` idempotent (skip if the player already has `origin: "initial"` events; exclude `game_player.drawn_agenda_ids` from `draw_one`). Apply the same treatment to `maybe_start_game!`.

### C-4. The app cannot detect a dead websocket

**App — `lib/services/action_cable_client.dart:75-78, 100-104`; no `WidgetsBindingObserver` anywhere in `lib/`**

ActionCable `ping` frames (sent by the server every 3 s precisely for liveness detection) are explicitly discarded, there is no staleness watchdog, and nothing in the app observes app lifecycle. `_scheduleReconnect` only fires from `onDone`/`onError`, which a half-open socket may never trigger — the client never writes to the socket after subscribing, so nothing forces an error.

**Failure scenario:** the app is backgrounded, the phone sleeps, or the network switches wifi→cellular; the TCP connection dies without a FIN (NAT timeout / suspended socket). The game screen silently freezes: the opponent's actions stop arriving, and — because of A-2 below — the player's *own* actions stop rendering too, with no indication anything is wrong.

**Suggested fix:** reset a ~6-10 s watchdog timer on every incoming frame (pings included) and force close + reconnect when it fires; additionally observe `AppLifecycleState.resumed` in `GameService`/`GameSessionScreen` and trigger a reconnect + resync.

### C-5. `GameService.watch()` has no cancellation guard

**App — `lib/services/game_service.dart:311-329`**

`watch()` awaits `getGame()` and then unconditionally installs state and a cable, with no check that it is still the active watch.

**Failure scenario A (leak):** open a game on a slow network → `GameSessionScreen._init` calls `watch(5)`, which is awaiting `getGame(5)` → the user taps back → `dispose()` calls `stopWatching()`, a no-op since `_watchedGameId`/`_cable` are still null → `getGame(5)` resolves and `watch` proceeds: sets `currentGame`, creates an `ActionCableClient`, subscribes. Nothing ever disposes this cable — it holds a live websocket and a 3-second reconnect loop (minting a cable ticket per attempt) for the rest of the process lifetime.

**Failure scenario B (wrong data):** same start, but the user immediately opens game 6. `watch(6)`'s leading `stopWatching()` runs before `watch(5)`'s await completes; when `getGame(5)` resolves it installs cable-5 and `_watchedGameId = 5`; when `getGame(6)` resolves it overwrites `_cable` (cable-5 leaked, still subscribed) and sets game 6. Every subsequent game-5 broadcast reaches `_onChannelMessage`, which unconditionally replaces `currentGame` — the screen for game 6 flips to game 5's state on each broadcast.

**Suggested fix:** give each `watch` a generation token (or check `identical(_cable, myCable)` / `_watchedGameId == gameId`) after every await, bail out and dispose the freshly created cable if superseded, and make `stopWatching` invalidate the generation so a disposed screen's in-flight `watch` aborts.

### C-6. Offline or failed loads leave core screens on infinite spinners; no network timeouts anywhere

**App — `lib/screens/cards_screen.dart:85-90`, `lib/screens/gang_builder_screen.dart:252-267`, `lib/services/api_client.dart:29-34`, `lib/services/rules_service.dart:50`, `lib/main.dart:25`**

Neither Dio instance configures `connectTimeout`/`receiveTimeout`. `main()` awaits `CardImageService().init()` — which performs an HTTP GET for the image manifest — before `runApp`. The Cards screen and gang builder load methods have no error handling at all, and the catalog JSON is never persisted to disk (unlike the card images, which are all on disk).

**Failure scenario:** on a captive-portal or black-hole network at launch, the manifest request hangs indefinitely and the app never renders its first frame. Starting in airplane mode, the Cards screen and gang builder show spinners forever with unhandled exceptions and no retry UI — even though every card image is already on disk. On flaky networks, every REST call and the rules PDF download can spin indefinitely. The `ProfileService` doc comment ("keeps search working offline") is only true within a session that already fetched once.

**Suggested fix:** set timeouts (e.g. 10 s connect / 30 s receive) on both Dio `BaseOptions`; don't block `runApp` on the manifest; wrap the load methods in try/catch with an `_error` state and the existing `ErrorRetryView`; persist the last-good catalog JSON keyed by a version, mirroring what `CardImageService` already does for images.

---

## 2. Backend — concurrency and game lifecycle

The root cause behind most findings here is one repeated pattern: **check in-memory `@game` state → mutate → maybe transition**, with no lock and no reload. `GamesController#destroy` already handles its race correctly (`with_lock` + `RecordNotFound` rescue) — that pattern should be extracted into a shared `with_game_lock` helper (reload + re-check status) and applied to `join`, `select_gang`, `deselect_gang`, `confirm_agendas`, and `finish`/`unfinish`. Ideally the `maybe_advance_*`/`maybe_start_*` transition logic moves onto `Encounter::Game` where it can be locked coherently.

### B-1. Major — `join` race creates a 3-player game and wedges it

`app/controllers/api/v1/games_controller.rb:47-64`. The game-full check is a non-transactional check-then-create. Two users posting the same join code concurrently both pass `count >= 2` (each sees 1 player) and both create a `Player`. `assign_roll_winners!` then reloads, sees 3 players, and returns **without assigning any roll winner** — yet status still flips to `gang_selection`. For an asymmetric scenario, `role_roll_winner` is nil forever, so `ensure_roles_resolved!` 422s `select_gang` for everyone: the game is permanently stuck. For symmetric scenarios the 2-player UI (`_opponent` = first other player) shows different opponents to different players. Alternatively, two racing joins can each reach `assign_roll_winners!` and the partial unique indexes turn the loser into an unrescued `RecordNotUnique` 500. **Fix:** `game.with_lock` around count-check + create + roll assignment + status flip (reject a third player inside the lock); make `assign_roll_winners!` a no-op when winners already exist.

### B-2. Major — `deselect_gang` racing the opponent's select destroys a list the game depends on

`app/controllers/api/v1/games_controller.rb:112-126`. Both `select_gang` and `deselect_gang` validate `@game.gang_selection?` against the stale in-memory game. If A taps Select (completing both picks → advances to `agenda_draw`, deals hands) at the same moment B taps Deselect, B's request passes the status check and destroys B's snapshot. The game is now in `agenda_draw`/`in_progress` with B list-less: `start!`'s `create_entry_states!` skips the nil list, `player_list` 422s ("List not selected yet"), the gang tab shows "Could not load this gang" forever, and B can never re-select (status guard). The game is permanently bricked for B. **Fix:** same `with_lock` + reload-status re-check on both endpoints.

### B-3. Major — both players finishing simultaneously permanently loses the `completed` status

`app/models/encounter/player.rb:76-84`, `app/models/encounter/game.rb:81-90`. `finish!` wraps `update!(finished: true)` and `refresh_completion!` in one transaction, so the reload of the opponent's row happens **before commit**. If A and B finish concurrently (natural at game end), each reads the other's uncommitted `finished: false`, both `refresh_completion!` calls no-op, both commit: both players are finished but `status` stays `in_progress`, with nothing left to re-derive it. (By contrast, `confirm_agendas` is safe: the flag commit precedes the read.) **Fix:** run `refresh_completion!` after commit, or take `game.with_lock` around flag-write + derivation.

### B-4. Major — same user on two devices can end up with two gang snapshots

`app/controllers/api/v1/games_controller.rb:101-105`. `lists` has no unique index on `(owner_type, owner_id)`; two concurrent `select_gang` requests both see `@game_player.list` nil (or destroy the same old one), both call `snapshot_for` → two `Gang::List` rows owned by one `Encounter::Player`. `has_one :list` then returns an arbitrary one; the orphan is invisible and never cleaned. **Fix:** lock the game_player row for the destroy + snapshot, and/or add a partial unique index on `lists(owner_type, owner_id)` for `owner_type = 'Encounter::Player'`.

### B-5. Major — no idempotency for retried mobile mutations

`app/controllers/api/v1/games_controller.rb:131-143`, `app/controllers/api/v1/list_entries_controller.rb:6-16`. A Flutter client that times out and retries `POST /games/:id/agendas/draw` draws two agendas (separate events, no client request id); the extra one can only be removed by attributing a fictitious discard. Retrying `POST /list_entries` hires the same model twice — legal for non-unique models, so silent. Two devices adding entries concurrently also race `maximum(:position) + 1` into the `(list_id, position)` unique index → unrescued `RecordNotUnique` → 500. **Fix:** accept an idempotency key on mutating game/list endpoints (unique-indexed); retry position assignment on `RecordNotUnique`.

### B-6. Minor — concurrent `confirm_agendas` 500s for the loser

`app/models/encounter/game.rb:66-75`. Both players tapping "Ready" together can both pass `start!`'s checks; the loser hits the `EntryState` unique `list_entry_id` validation/index → unrescued 500 (state self-heals via the winner's broadcast). **Fix:** `game.with_lock` in `start!`, re-checking `in_progress?` after reload.

### B-7. Minor — agenda score/discard and the recycle draw are not atomic

`app/models/encounter/agenda_deck.rb:38-52`. The resolved event and the Cycle/recycle replacement draw are two statements with no transaction. If the replacement draw raises (deck exhausted → nil `agenda_id` → `RecordInvalid`, or a drawn-collision), the scored/discarded event persists but the request 500s and `broadcast_state!` never runs — both screens are stale until the next unrelated action, and the retry 422s "Agenda not in hand" while the UI still shows the agenda in hand. **Fix:** wrap event + recycle draw in a transaction.

### B-8. Minor — finished players can edit entry states; counter updates can be lost

`app/controllers/api/v1/games_controller.rb:360-377`. `update_entry_state!` checks only `@game.status == "in_progress"`, not `@game_player.playing?` — a finished player can keep editing counters/stats (the draw/score/turn endpoints all block this). `counters.merge` is an unlocked read-modify-write, so the same user on two devices can lose a counter toggle. **Fix:** add the `finished?` guard; optionally `state.with_lock`.

### B-9. Minor — mulligan allowed server-side after hand confirmation

`app/controllers/api/v1/games_controller.rb:172-181`. `mulligan_window?` is game-level (`agenda_draw?`), so a player who confirmed their hand can keep swapping agendas via the API until the opponent confirms. The Flutter UI hides the button; the server doesn't enforce it. **Fix:** also require `!@game_player.agendas_confirmed?` for the agenda_draw path.

### B-10. Minor — soft-deleted-game players can still subscribe to broadcasts

`app/channels/game_channel.rb:3`. `subscribed` uses `current_user.game_players.find_by(game_id:)` without the `visibility != "deleted"` scoping that `set_game_and_player` applies to every REST action. No real data leak (they were a participant), but the authorization boundary is inconsistent between REST and cable.

### B-11. Minor — `join` resurrects a soft-deleted membership

`app/controllers/api/v1/games_controller.rb:49-55` vs `doc/openapi.yaml:752-758`. The spec says delete "hides the game … permanently", but `join` finds the deleted game_player and flips it back to `active`, restoring full history — so two clients of the same user can disagree about whether a game exists. **Fix:** exclude deleted players in join, or document the resurrection.

### B-12. Minor — `select_gang` never checks list validity or actual cost

`app/controllers/api/v1/games_controller.rb:89-95`. Only `list.points > @game.ducat_limit` is checked — `points` is the player-declared limit, not `total_cost`, and `selection_valid` is ignored. A 100-point list containing 300 ducats of models is selectable and freezes into the game. **Fix:** also reject on `total_cost > ducat_limit` or `!selection_valid`; reflect it in `available_lists.selectable`.

### B-13. Minor — game creation is not transactional

`app/controllers/api/v1/games_controller.rb:27-41`. `game.save` then `game_players.create!` — if the second raises, an orphaned game with no players persists (unreachable but permanent, join code reserved). **Fix:** wrap in a transaction.

---

## 3. Backend — API contract, errors, and OpenAPI drift

The generated Dart client (built_value) is strict about required/nullable fields, so spec drift directly breaks the app. Run a spec-vs-serializer audit before the next `scripts/generate_api.sh` run. (Note: that script uses `sed -i ''`, the macOS/BSD form — it fails on Linux.)

### B-14. Major — `GamePlayer.required` includes a field that doesn't exist

`doc/openapi.yaml:2305`. `ready` appears in the required list but not in `properties`, and `PlayerSerializer` never emits it — likely a leftover from a removed readiness flag. Depending on generator behaviour, this either produces a phantom required field (deserialization failure on every Game payload) or is silently dropped; either way the spec is wrong. **Fix:** delete `ready` from the required list.

### B-15. Major — `ListInput.name` documented optional/nullable but the model requires presence

`doc/openapi.yaml:1570-1574` vs `app/models/gang/list.rb:8`. A spec-conforming client may POST `/lists` without a name and get an unpredicted 422; the `List` response schema also marks `name` nullable although it can never be null. **Fix:** align spec and model (server-side default name, or mark `name` required/non-nullable).

### B-16. Minor — assorted spec drift

- `doc/openapi.yaml:469-489` — `/spells` declares bearerAuth + a 401 response but `SpellsController` is public (no `authenticate_user!`).
- `doc/openapi.yaml:735` — the `/games/{id}` description claims agendas are only populated for the requester, contradicting both `PlayerSerializer` (opponent's hand visible unless the Secret rule applies) and the correct schema description at `:2343`.
- `doc/openapi.yaml:1682-1688` — `DrawAgendaInput` requestBody is `required: false` and `origin` isn't required, yet the controller 422s without a valid origin.
- `doc/openapi.yaml:71-84` — `/logout` documents a 401 but `sessions#destroy` always returns 204 (revocation silently skipped when the token is absent/invalid).

### B-17. Minor — unrescued errors produce non-API-shaped responses

`app/controllers/api/v1/base_controller.rb:6`, `app/controllers/api/v1/list_entries_controller.rb:40-44`. `BaseController` rescues only `RecordNotFound`. A bogus `spell_id` raises `RecordInvalid` → 500; any `params.require` miss — including `PATCH .../counters` with `counters: {}`, which raises `ParameterMissing` on an empty hash even though the spec allows a partial set — returns Rails' default 400 body, not the documented `{errors:{...}}` shape the app parses. **Fix:** `rescue_from RecordInvalid` → `render_error(record.errors)` and `rescue_from ParameterMissing` → 400 in the API error shape. This also converts several of the benign race losers above from 500s into clean 422s.

---

## 4. Backend — security and auth

Verified good, for the record: JWT secret lives in encrypted credentials (`config/master.key` not committed); denylist revocation is wired to `DELETE /logout`; `CableTicket` is a genuinely good design (30 s TTL, row-lock single-use redemption, opportunistic pruning, per-device tickets); IDOR scoping is consistently correct (`current_user.lists`, `find_owned_entry` join, `set_game_and_player`); mass assignment is tight (`admin` never permittable); Rack::Attack has sane general + auth throttles with API-shaped 429 bodies; CORS fails closed to localhost when `ALLOWED_ORIGINS` is unset; Secret-rule agenda hands are trimmed per-viewer in `PlayerSerializer` for both REST and per-player broadcast streams.

### B-18. Major — the render token grants every backoffice GET, not just the card page

`app/controllers/backoffice/base_controller.rb:39-45`. `valid_render_token?` only checks `request.get?`, but `edit`, `index`, `publish`, `illustration_editor`, and crucially `export_pdf`/`export_png` are all GETs — contradicting the comment ("it can never reach the editing/export… actions"). The token is a permanent SHA-256 of `secret_key_base` (unrotatable without rotating the app secret) and can leak via proxy/CDN logs that record query strings. Anyone holding it can browse the entire backoffice read surface and trigger full-catalog PDF export, which spawns headless Chrome per face — a cheap DoS. **Fix:** restrict the bypass to the one action it exists for (`valid_render_token? && action_name == "card"`), and ideally switch to a short-lived signed token (`message_verifier.generate(profile_id, expires_in: 5.minutes)`).

### B-19. Major — `X-Api-Key` is silently not enforced on any auth endpoint

`app/controllers/api/v1/sessions_controller.rb`, `registrations_controller.rb`, `passwords_controller.rb`. These inherit `Devise::*Controller` → `ApplicationController`, not `Api::V1::BaseController`, so `authenticate_client!` never runs on `/api/v1/login`, `/signup`, `/password`, `/account`, `/logout` — yet `doc/openapi.yaml` declares ApiKeyAuth globally ("Required on every request"). The endpoints most worth gating against bots (credential stuffing, spam signups) are exactly the ones without the key; only Rack::Attack covers them. **Fix:** extract `authenticate_client!` into a concern and `before_action` it in the three Devise-derived controllers, or move the check to Rack middleware scoped to `/api`. A small shared API auth base class would also remove the inherited `ActionController::Base` extras (layouts, CSRF machinery) these controllers must skip.

### B-20. Minor — account enumeration on password reset

`app/controllers/api/v1/passwords_controller.rb:9-17`. Devise `paranoid` is off, so an unknown email returns 422 `{errors:{email:["not found"]}}` — confirming which emails have accounts. The OpenAPI description even promises paranoid behaviour ("instructions sent if the email is on file"). **Fix:** `config.paranoid = true`.

### B-21. Minor — JWT denylist grows forever

`app/models/jwt_denylist.rb`. Every logout inserts a row with `exp`, but nothing ever deletes expired rows. Unbounded growth and a slowly fattening index consulted on every authenticated request. **Fix:** recurring `JwtDenylist.where(exp: ..Time.current).delete_all`, mirroring `CableTicket.issue!`'s opportunistic prune. Related: there is no token refresh flow at all — with a 1-day TTL, users must re-login daily (see A-5 for what happens when the token expires mid-game).

### B-22. Minor — no server-side validation on illustration uploads

`app/controllers/backoffice/profiles_controller.rb:326-340`. The `accept=` attribute is client-side only; a 500 MB file or a non-image is stored by ActiveStorage, the card render draws a broken portrait, and `render_to_catalog` stamps and publishes the broken face. **Fix:** validate content type (`png/jpeg/webp`) and a byte-size cap on the model.

### B-23. Minor — production config gaps

`config/environments/production.rb:52-53, 100-104`. `solid_cache` is in the Gemfile but `cache_store` is never set, so `Rails.cache` (and Rack::Attack counters) uses the default file store — fine single-host, silently per-host on any scale-out. `config.hosts` is unset, so Host-header protection relies entirely on kamal-proxy. **Fix:** `config.cache_store = :solid_cache_store`; configure `config.hosts`.

---

## 5. Backend — data integrity and models

### B-24. Major — catalog edits never refresh gangs' cached validity

`app/models/concerns/refreshes_list_selection_validity.rb`, `app/controllers/backoffice/profiles_controller.rb:93-113`. The `selection_valid`/`selection_errors` refresh fires only on `Gang::List`/`Entry`/`EntrySpell` commits — verified to be the only call sites. A backoffice rebalance (raising a profile's ducats, adding/removing Leader/Unique/Mage/Discipline keywords) leaves every existing gang containing that model claiming `selection_valid: true` until the owner happens to touch the list; the same applies after `CatalogSnapshot.import` on an existing environment. `spec/models/list_entry_spec.rb:55-64` even has to call `entry.touch` to propagate a ducat change. **Fix:** after a backoffice profile save (and after import), refresh affected lists: `Gang::List.where(id: Gang::Entry.where(entry_type: "Catalog::CardReference", entry_id: profile.card_references.select(:id)).select(:list_id)).find_each(&:refresh_selection_validity)` — ideally in a job.

### B-25. Minor — Unique-model check groups by card reference, not profile

`app/services/list_validation_service.rb:66-71`. A Unique model hired via two different references of the same profile is not flagged. Latent today (verified: no Unique profile currently has more than one reference), but the backoffice can create a Unique A/B pair any day, and `list_entries#illustration` explicitly supports repointing an entry to a sibling reference — a player could then field the same Unique character twice with `selection_valid: true`. **Fix:** group by `cr.profile_id`.

### B-26. Minor — missing unique indexes and foreign keys

`db/schema.rb:69-77, 261-277, 290-299, 214, 191-203`:

- Uniqueness validations without backing unique indexes: `agendas.name`, `scenarios.name`, `spells(name, discipline)` — concurrent seeds/imports can insert duplicates the models claim impossible.
- `lists.source_list_id` has no FK: deleting a source list leaves dead pointers that are serialized to the client. **Fix:** `add_foreign_key :lists, :lists, column: :source_list_id, on_delete: :nullify`.
- Polymorphic `list_entries.entry_(type,id)` can orphan when catalog rows are deleted (console/backoffice): `ListValidationService#check_spell_selections` then does `list_entry.entry.name` on nil **inside an `after_commit`**, breaking every subsequent edit to that list. **Fix:** nil-guard `entry` in the validation service; consider `restrict_with_error`-style guards on catalog destroys.

### B-27. Minor — `Catalog::Equipment` has zero validations and nullable columns

`app/models/catalog/equipment.rb`, `db/schema.rb:128-134`. A console/import mistake creates equipment with nil `cost`/`name`: serializers coerce with `to_i` so totals silently treat it as free — and worse, `cost: null` violates the spec's required non-nullable `ListEntry.cost`/`Equipment.cost`, so built_value refuses the payload **for every user whose list contains it**. **Fix:** presence/numericality validations + NOT NULL constraints.

### B-28. Minor — `spell_discipline` accepts any string

`app/models/gang/entry.rb` (schema `spell_discipline`). Writing `"Blood Rites"` (display case) instead of `"blood_rites"` is accepted and merely flips the list invalid with a confusing error. **Fix:** `validates :spell_discipline, inclusion: { in: Catalog::Spell::DISCIPLINES }, allow_nil: true`.

### B-29. Minor — validity refresh never bumps `updated_at`

`app/models/gang/list.rb:25-30`. `refresh_selection_validity` writes via `update_columns`, and entry changes don't `touch` the list. Latent: the first `fresh_when @list` added to the API will serve stale validity/entries. **Fix:** bump `updated_at` in the same call, or `touch: true` on the entry association.

### B-30. Minor — seed hygiene

`db/seeds.rb:56, 83`. Sample lists use `find_or_create_by!(name:, faction:)` unscoped to owner — re-seeding a dev DB where a real user owns "Guild Sample List" destroys that user's entries. Glossary seeds set descriptions only inside the create block, so corrections never reach an existing database. **Fix:** scope lookups to the owner; upsert descriptions.

---

## 6. Backend — backoffice and card rendering

### B-31. Major — render fallback and staleness fingerprint disagree about which illustration a card uses

`app/controllers/backoffice/profiles_controller.rb:138-139` vs `app/models/catalog/card_reference.rb:40-44`. The `card` action falls back to `illustrations.first` when the requested slot doesn't exist, but `CardReference#illustration` (used by `source_fingerprint`/`stale?`) uses an exact `detect` and hashes nil. Create an A/B pair with art only in slot 1 and render both: card B's front is rendered **with art 1** but fingerprinted as having **no illustration**. Repositioning or replacing art 1 marks only card A stale; card B keeps advertising itself as up-to-date on the publish page while its published PNG shows the old framing — wrong art served forever. **Fix:** make the two code paths share one resolution rule (drop the `.first` fallback, or make `CardReference#illustration` apply the same fallback so the fingerprint covers what is actually drawn).

### B-32. Minor — card rendering depends on Google Fonts at render time

`app/views/backoffice/profiles/card.html.erb:7-9`. The fonts are fetched from fonts.googleapis.com during render and are outside `template_digest`. A production container without outbound network (or a fonts CDN hiccup) makes Grover screenshot system-font fallbacks — visibly different cards get published, and nothing ever reports them stale because the bytes are stamped as current. **Fix:** vendor Pirata One / EB Garamond into `public/card-template/` (already covered by `template_digest`), as Buckingham already is.

### B-33. Minor — backoffice robustness collection

- `profiles_controller.rb:376-381` — a blank card identifier with "A/B pair" checked creates cards named `-a`/`-b` (the presence validation only rejects the single-card case); these become permanent app-facing keys. Validate identifier presence/format.
- `profiles_controller.rb:98-105` — `update` doesn't rescue `RecordInvalid` from `replace_weapons!`/`replace_special_rules!` (unlike `create`): a stale weapon id from another tab → 500 instead of a form error.
- `profiles_controller.rb:306-318` + `catalog/illustration.rb:14` — `illustration_position` for a slot with no record builds an illustration with `path: ""`, which its own validation forbids → 500. Return 404 instead (mirror `illustration_editor`'s `find_by!`).
- `weapons_controller.rb:63-73`, `special_rules_controller.rb:60-70` — TOCTOU on the delete guard: a racing attach makes destroy hit the FK → 500 instead of the alert. Rescue `InvalidForeignKey`.
- `profiles/weapons/special_rules` search — LIKE wildcards (`%`, `_`) unescaped (parameterized, so not injectable — just wrong results). Use `sanitize_sql_like`.

---

## 7. Backend — performance

### B-34. Major — `games#index` N+1 despite the "no N+1" comment

`app/serializers/player_serializer.rb:57, 62`, `app/serializers/list_summary_serializer.rb:8`. `agenda_history` chains `.includes(:agenda).order(:turn, :id)` on the association, which **discards the controller's preload** and issues a fresh query per player; `hand_agendas` runs a `Catalog::Agenda.where` per player; `ListSummarySerializer` calls `Gang::List#total_cost` = 2 aggregate queries per player. `GET /api/v1/games` — the app's landing call — costs ~5 queries per player, ~10 per game: 20 games ≈ 200 queries. The controller comment claims this was fixed (B-P2-4), and there is no query-count spec to pin it. **Fix:** sort/serialize the already-preloaded `agenda_events` in Ruby, batch the agenda name lookup, precompute `total_cost` in one grouped query — and add a `count_queries` assertion.

### B-35. Minor — broadcasts omit entry states, multiplying HTTP chatter

`Encounter::GameBroadcaster` payload + `lib/screens/gang_viewer_screen.dart:283-286` (app side). Every `game_state` broadcast triggers a debounced full `player_list` refetch per gang tab per client — four extra HTTP requests across the table per counter toggle. Including entry states in the game payload (or a slim `entry_state` event) would cut chatter and remove the app's optimistic-update/`_mutationSeq` reconciliation complexity.

### B-36. Minor — list revalidation N+1s on every write

`app/services/list_validation_service.rb:44-46, 66-99`. `projected_items` preloads `:entry` but every `cr.profile`/`cr.cost` in the five checks queries per card reference, and `check_spell_selections` reloads all entries a second time: ~30-40 queries per entry/spell commit on a 15-model list — the hottest callback in the write path. **Fix:** batch-preload profiles; reuse `projected_items`.

---

## 8. App — live game connection resilience

(See also C-4 and C-5.)

### A-1. Major — REST mutation responses are discarded; the UI updates only via websocket echo

`lib/services/game_service.dart:96-198`, `lib/screens/game_session_screen.dart:126-137, 852-864`. Every mutation returns the fresh `api.Game`, but `_run(() => _service.advanceTurn(game.id))` throws it away and `currentGame` is only ever set by broadcasts. With the socket dead or lagging (C-4), a player scores an agenda or advances the turn — the server persists it, but the screen doesn't change; a retry then 422s ("Agenda not in hand") → generic "Something went wrong" toast while the score still looks un-scored. Double-tapping "advance turn" with a dead socket advances it twice. The `GameService` class doc ("every update, REST or broadcast, fully replaces it") describes behaviour the code does not implement. **Fix:** in every `Game`-returning method, `currentGame = res.data!; notifyListeners()` (guarded by `_watchedGameId == gameId`) — a one-line-per-method resilience win that also removes the HTTP-200→broadcast latency gap.

### A-2. Major — token expiry mid-session: endless 401 loop plus a crash

`lib/services/api_client.dart:45-49`, `lib/services/action_cable_client.dart:38-43, 100-104`, `lib/screens/game_session_screen.dart:54`, `lib/services/auth_service.dart:62`. Token expires during a live game → the next reconnect mints a ticket → `POST /cable_tickets` 401s → the interceptor calls `AuthService._clear()` → the cable client catches and schedules another attempt in 3 s → forever (no backoff, no give-up, one sign-out notification per 3 s). Meanwhile `GameSessionScreen._me` does `authService.currentUser!.id` while `currentGame` is still set → null-assert throws during build → red error screen. `isTokenExpired` is only consulted at cold start. **Fix:** stop reconnecting after an auth failure and surface it (so `GameService` can `stopWatching` and the UI routes to login); make the session screen react to `AuthService` sign-out.

### A-3. Minor — reconnect resync can apply an older snapshot over a newer one

`lib/services/game_service.dart:331-340`. On `welcome` after reconnect, three sources race: the REST `_resyncSnapshot`, the channel's transmit-on-subscribe, and live broadcasts. A slow REST response fetched before an opponent's action can be applied after that action's broadcast, briefly reverting the screen (e.g. a scored agenda un-scores). Snapshots carry no sequence number, and with a multi-process backend two near-simultaneous broadcasts have no ordering guarantee either. **Fix:** include `updated_at`/a monotonic sequence in the `game_state` payload and apply-only-if-newer in `_applySnapshot` — this single mechanism also hardens A-1 and C-5.

### A-4. Minor — cable client protocol gaps

`lib/services/action_cable_client.dart`:

- `:89-91` — `reject_subscription` is silently swallowed: a rejected subscription looks like a working one (REST snapshot shown, no live updates, no error, `onReconnect` never fires). A server `disconnect` frame with `reconnect: false` is also ignored. Surface both via callbacks.
- `:100-104` — fixed 3 s reconnect with no backoff/jitter: with the backend down, every open session hammers the ticket endpoint + WS handshake every 3 s indefinitely (battery; thundering herd on recovery). Use capped exponential backoff with jitter.
- `:73-74` — `_handleFrame` can throw out of `onData` (`raw as String` on a binary frame, `jsonDecode` on malformed data) as an unhandled zone error. Wrap in try/catch.

### A-5. Minor — `/join` deep link while a session is open kills the screen underneath

`lib/main.dart:61, 71-79`, `lib/screens/game_home_screen.dart:103`. With session A open, tapping a join link pushes a second `GameSessionScreen` on the singleton `GameService`; popping it calls `stopWatching()`, leaving screen A with `currentGame == null`, no cable, and no re-watch — a dead screen until manually re-entered. Also `_lastHandledLink` dedupes the same link **forever**, so tapping the same join link twice is ignored. **Fix:** `stopWatching` only if this screen is the current watcher; re-`watch` on `didPopNext` via a `RouteObserver`; dedupe links by time window.

---

## 9. App — UI error handling and lifecycle

Verified good, for the record: controller/listener disposal and `mounted` guards after awaits are near-universal; lists are builder-virtualized; keyboard insets are handled in the shared bottom sheet; the `_mutationSeq` stale-response guard in `_GangTabState` (`gang_viewer_screen.dart:225-265`) is a well-designed solution to the optimistic-update-vs-refetch race.

The systemic gap: the in-game dialogs catch and toast errors; the gang builder and list screens don't. A small shared helper — `Future<void> guard(BuildContext context, Future<void> Function() action)` that toasts `ApiException.message` — would fix A-6 through A-9 in one pass. Relatedly, `GameSessionScreen._run` (`game_session_screen.dart:126-137`) collapses every failure into "Something went wrong", discarding the human-readable messages the services carefully build; surfacing `ApiException.message` would make the backend races self-explaining instead of mysterious.

### A-6. Major — all gang-builder mutations fail silently; reorder never rolls back

`lib/screens/gang_builder_screen.dart:326-400`. `_add`, `_addEquipment`, `_remove`, `_removeEntry`, `_editSpells`, `_reorderEntry` all use `try/finally` with **no catch**: on network failure the `_busy` spinner appears and disappears, the tap seems to have worked, nothing happened, and the exception is unhandled. `_reorderEntry` (381-400) is worst: it applies the reorder optimistically to `_gang` before the request and never rolls back, so the UI shows an order the server doesn't have until the screen reloads. **Fix:** catch + toast everywhere; roll back the optimistic reorder.

### A-7. Major — remove-entry animation runs before the removal is confirmed

`lib/screens/gang_builder_tiles.dart:112-114`, `lib/screens/gang_builder_screen.dart:369-379`. `_handleRemove` plays the full slide/fade/collapse animation, *then* calls `_removeEntry`. If the request fails (offline) or is skipped (tap remove on tile B while tile A's request is in flight — the `if (_busy) return;` silently no-ops), the tile's `AnimationController` is left at its end value: the entry is **invisible but still present** in `_gang`, still counted in `totalCost` and validity, until the user leaves and re-enters. **Fix:** run the request first (or in parallel) and reverse the animation on failure/skip; toast errors.

### A-8. Major — double-submit creates duplicate gangs; creation failures are invisible

`lib/widgets/create_gang_sheet.dart:52-63, 76`. The button is disabled while saving but the name field's `onSubmitted` has no `_saving` guard — pressing Enter/Done twice creates two gangs (the duplicate invisible until the list reloads). `catch (_)` just resets `_saving`: on any error the spinner stops and nothing says why. Also line 55: an unparseable point-limit input silently becomes 100. **Fix:** early-return when `_saving`; show the error in the catch.

### A-9. Major — deleting a gang offline silently does nothing

`lib/screens/gangs_screen.dart:83-86, 279-282`. `_deleteGang` is fire-and-forget from the confirm dialog and `GangService.delete` throws on failure: the dialog closes, the gang stays, no message. **Fix:** await + try/catch with a toast.

### A-10. Major — back-button trap when tapping "Hire" during load

`lib/screens/gang_builder_screen.dart:150-160, 44, 406-411`. During `_loading` the tab bar is shown but the `PageView` isn't built, so `_selectTab` falls back to `setState(() => _tab = tab)`. The `PageView` then mounts at `initialPage: 0` while `_tab == _Tab.hire`: `PopScope.canPop` is false and `_handleBack` calls `animateToPage(0)` — which never fires `onPageChanged` because the page is already 0 — so back is permanently swallowed until the user happens to swipe to Hire and back. Easy to hit on a slow network. **Fix:** set `_tab` in `_selectTab`'s fallback (or in `_handleBack` directly), or recreate the controller with the right `initialPage`.

### A-11. Minor — assorted UI findings

- `card_viewer_screen.dart:380-381` — `FutureBuilder(future: AbilityService().load())` creates a new future on every rebuild of the `DraggableScrollableSheet`, whose builder re-runs on every drag: the abilities list flashes a spinner while dragging, and if the first load failed, every drag frame fires a fresh network request. Hoist the future / memoize the in-flight future in the service.
- `gang_viewer_dialogs.dart:509-514` — summon picker `_load()` doesn't catch `ApiException`: cache-cold offline open hangs the dialog spinner forever.
- `gang_viewer_screen.dart:274-277, 400-409` — a gang tab that fails its first load shows "Could not load this gang." with no retry affordance (recovery only via a later broadcast). Use `ErrorRetryView`.
- `gang_viewer_body.dart:171-173` — tapping the second copy of a duplicated model opens the card viewer on the first copy (`indexWhere` by `cardReferenceId`, not entry). The builder fixed exactly this (`gang_builder_screen.dart:680`); apply the same fix.
- `gang_builder_screen.dart:272-281` — `_onEntryIllustrationChanged` has no error handling: on failure the viewer shows the new art, the entry keeps the old, silently.
- `gang_builder_screen.dart:522`, `account_screen.dart:379` — `RichText` doesn't read `MediaQuery.textScaler`: the validity-panel errors and the "Sign Up" toggle ignore accessibility text scaling. Use `Text.rich` or pass the scaler.
- `app_drawer.dart:19-26` — drawer navigation always `push`es: hopping Cards → Gangs → Cards grows an unbounded navigator stack of live screens; OS back unwinds through every visit. Use `pushReplacement` for peer sections.

### A-12. Minor — services-layer robustness collection

- `api_exception.dart:24` — `(entry.value as List)` throws `TypeError` if a backend `errors` value is ever not a list (latent: the backend currently always wraps in arrays). This is the app-wide error path; type-check and fall back gracefully.
- `auth_service.dart:116, 185` — `res.data!.user` null-asserts inside a `try` that only catches `DioException`: a body-less 2xx surfaces as a raw `TypeError`, breaking the documented `AuthException` contract.
- `rules_service.dart:143-161` — two concurrent `localPath()` calls for the same doc download into the same `.part` file (interleaved writes → a corrupt PDF can be promoted and recorded as cached forever), and `temp.rename`'s `FileSystemException` isn't caught by the `on DioException` handler. Dedupe with an in-flight future map; unique temp names.
- `profile_service.dart:40-52`, `ability_service.dart:38-51`, `rules_service.dart:64-78` — no in-flight future dedup on first-call caches: concurrent first callers duplicate the full-catalog fetch. `_cacheFuture ??= _fetch()` fixes this and the `_initialised` TOCTOU.
- `lib/models/gang.dart` — dead empty file (self-documented as deletable). Remove it.

---

## 10. Card sync pipeline (catalog JSON + card images)

### Architecture (as implemented)

Catalog JSON and card images travel **two separate pipelines** from the same Rails source of truth:

- **JSON:** public endpoints under `/api/v1` (`profiles`, `abilities`, `equipment`, `spells`, …), each guarded by a relation-derived ETag (`stale?`) plus `expires_in 1.hour, public: true`. On the app side, `ProfileService`/`AbilityService` cache in memory once per session (`EquipmentService` not at all), with no persistence, no ETag awareness in dio, and no invalidation hook. Freshness on mobile comes solely from process restarts; on web, from the browser HTTP cache honouring the backend headers.
- **Images:** card faces are pre-rendered server-side (backoffice button or `rake cards:render` drives headless Chrome over an HTML template) into static PNGs under `public/cards/`, served with `max-age=1y, immutable` in production. Versioning is byte-driven: `CardReference#reversion!` bumps an integer `internal_version` when the face bytes' SHA-256 changes; a second digest (`source_digest` vs `source_fingerprint`) tracks whether the PNGs have drifted from the data, **purely as an operator tool**. `GET /api/v1/cards/manifest` publishes per-card `internal_version`, byte sizes, and version-busted URLs. On the app side, `CardImageService` is the one component with real sync machinery: a persisted filename→version map, sequential downloads of missing/outdated faces, `ImageCache` eviction on overwrite, orphan pruning, and a `FileImage`→`NetworkImage` fallback (web is always `NetworkImage`; `sync()` is a no-op there). ActiveStorage holds only illustration sources and the catalog snapshot — no signed URLs ever reach the app, so URL expiry is not a concern.

The structural problem: **the only version signal in the system is the image `internal_version`; nothing ties a JSON catalog state to an image set.** That is the root of S-1 through S-4. Recommended direction: introduce a catalog version (the profiles ETag or a tiny version endpoint), persist the last-good JSON, check the version on resume/refresh, and make "Sync Cards" refresh both pipelines atomically from the client's perspective.

### S-1. Major — the profiles ETag doesn't cover embedded shared data

`app/controllers/api/v1/profiles_controller.rb:7, 16`. `stale?(scope)` derives the ETag from `profiles` count + `max(updated_at)`, but the payload embeds `weapons` and `special_rules` — shared records edited independently in the backoffice without touching any profile row, and `card_references` additions likewise. After a weapon errata, web clients revalidate to 304 (plus the 1-hour public cache) and keep stale stats **indefinitely**, until some unrelated profile row changes. Meanwhile the cards manifest ETag *does* change when faces are re-rendered, so the web app can show a freshly re-rendered card image whose printed stats disagree with the JSON in the abilities sheet and gang builder. Mobile is unaffected only because dio has no HTTP cache at all. **Fix:** `touch: true` chains from `ProfileWeapon`/`ProfileSpecialRule`/`CardReference` up to `Profile` (and touch affected profiles when a shared weapon/rule is edited), or fold the shared tables' `maximum(:updated_at)` into the ETag.

### S-2. Major — images re-render only manually, so JSON and PNGs drift with no signal

`app/models/catalog/card_reference.rb:104-124`, `lib/tasks/cards.rake:14-57`. A backoffice stat edit makes `/api/v1/profiles` serve the new numbers immediately, but `public/cards/*.png` shows the old ones until someone runs `cards:render` or clicks render-to-catalog. `stale?`/`cards:stale` can *detect* the drift, but nothing enforces or advertises it — the manifest's `internal_version` stays put, so clients (correctly, per the protocol) keep the outdated face. Players comparing on-card stats to the abilities sheet see contradictory numbers. **Fix:** trigger rendering (or at least a `stale: true` flag in the manifest from `CardReference#stale?`) automatically after catalog-affecting saves, or run `cards:render` + `reversion` from a scheduled job.

### S-3. Major — "Sync Cards" refreshes images but the session's JSON caches stay frozen

`lib/services/profile_service.dart:30, 40-52`, `lib/services/ability_service.dart:38-51`, `lib/screens/settings_screen.dart:456`. `ProfileService._cache` is set once per session; there is no pull-to-refresh and no version check anywhere. A player who keeps the app alive for days (common on tablets at game night) taps "Sync Cards" after a backoffice publish: `sync(refresh: true)` pulls the new manifest and PNGs, but profiles/abilities/equipment JSON stays frozen — new illustrations don't appear in the viewer's cycle button, renamed identifiers point at faces the JSON no longer matches, and stats lag the re-rendered art until a full app restart. **Fix:** check a catalog version on resume/refresh; make "Sync Cards" also invalidate the JSON caches.

### S-4. Major — web: a failed startup manifest pins year-immutable unversioned images

`lib/services/card_image_service.dart:127-130, 151-153`, `config/environments/production.rb:21` (backend). On web, `sync()` is an immediate no-op and `loadManifest` is only called from `init()`. If the startup manifest request fails (flaky Wi-Fi, server blip), `_manifestLoaded` stays false for the whole session and every face resolves to the **unversioned** `/cards/<file>.png` — which production serves with `cache-control: public, max-age=31536000, immutable`. The browser then serves whatever it cached under that URL, arbitrarily old, with no in-session recovery (the Settings sync button is hidden on web). **Fix:** retry the manifest on web; use a shorter/`no-cache` policy for the unversioned URL form; or persist the last manifest and never emit unversioned URLs once one has been seen.

### S-5. Major — first launch silently downloads the entire catalog's images

`lib/services/card_image_service.dart:151-204`, `lib/main.dart:26`. A fresh install fires `sync()` which downloads all ~750 card faces (the service's own comment estimates ~600 MB in production) **sequentially**, over whatever network is available — no consent, no Wi-Fi/metered check, no size preflight, even though the manifest already ships `front_bytes`/`back_bytes` (added in `cards_controller.rb:27-28` precisely for this). Progress is only visible if the user happens to open Settings. Faces that fail mid-run are only `debugPrint`ed and retried at the *next* sync; the run ends reporting success-shaped progress. **Fix:** gate the bulk sync behind explicit user action or Wi-Fi (show the total from the manifest byte sizes), download with modest concurrency, and count/report failures with backoff retry.

### S-6. Minor — card image cache robustness collection

- `card_image_service.dart:84-95` — `loadManifest` only ever adds to `_faces`; cards deleted/renamed on the backend are never pruned within a session (`_pruneOrphans` is effectively restart-only). Rebuild `_faces` from scratch on an unfiltered manifest load.
- `card_image_service.dart:188-193` — face bytes are written in place (no temp + rename): a kill mid-write leaves a truncated PNG that `provider()` serves until the next launch's sync. `RulesService` already does temp + rename; do the same here.
- `card_image_service.dart:141-143` — `provider()` does blocking `File.existsSync()` on every image resolve on the UI thread; consult the in-memory `_downloaded` map instead (it is already persisted).
- `card_image_service.dart:60-61` — the image cache lives in `getApplicationSupportDirectory`, which iOS includes in iCloud/device backups: hundreds of MB of re-downloadable PNGs inflate every user's backup. Use a caches directory or mark it excluded.
- `card_viewer_screen.dart:526-541` — faces decode at full source resolution (~795×1362 ≈ 4.3 MB RGBA each) with no `cacheWidth`/`ResizeImage` anywhere in the app: decode jank and `ImageCache` churn when paging through 300+ profiles on low-end devices. A `NetworkImage` failure also renders a permanent broken-image icon with no retry affordance.
- `equipment_service.dart:13-20` — equipment is the one catalog collection with **no cache at all**, refetched on every builder/viewer open — so within one session equipment can be newer than the profiles it is combined with. Cache it like the others, with the shared invalidation from S-3.
- `cards_controller.rb:13` (backend) — `expires_in 1.hour, public: true` on the manifest means a CDN/proxy can serve an hour-old manifest, so "Sync Cards" right after a publish can honestly say "already up to date". Acceptable, but consider `no-cache` + ETag for the manifest (revalidation is cheap and the ETag is correct for this endpoint).

---

## 11. Quality and maintainability

### Backend

- `GamesController` is 390 lines / 22 actions spanning lobby, roll-off, gang selection, agendas, entry state, and lifecycle. The agenda/entry-state groups belong in their own controllers or service objects; the phase-transition logic belongs on `Encounter::Game` where it can be locked properly (see section 2).
- `card.html.erb` is a 625-line single-file template with per-faction theme hashes and a 20-gsub keyword lambda whose hardcoded ability-name regex (line 248) duplicates the `Catalog::Ability` glossary — a glossary ability added via seeds won't be bolded until someone edits the regex. Generate the alternation from the glossary (it feeds `template_digest`, so invalidation semantics stay correct). The template-digest design itself is thoughtful and well tested.
- Filter/sort logic is triplicated in `Backoffice::ProfilesController` (`index`, `card`, `export_scope`); extract one `filtered_profiles` method. `def sort_link` is defined inside ERB (`profiles/index.html.erb:6-11`); move it to `CatalogHelper`.
- `ListSortingService` re-sorts the entire list on every `list_entries#create`, clobbering any manual order made via the reorder endpoint — confirm that's intended UX. Entry positions go sparse after destroy (tolerated by the reorder algorithm, but clients must not assume contiguous 1..N).
- Annotation drift: `profiles.faction` annotation says `default(NULL)` while the schema has `default: ""` — and `""` is not a valid enum value, a small landmine for validation-skipping code paths. Re-run annotate.
- `Gang::List#total_cost` is used only by `ListSummarySerializer` while `ListSerializer` deliberately re-implements it — the "keep the two in step" comment is doing load-bearing work a shared method could do.
- Docker: solid multi-stage build; `COPY vendor/* ./vendor/` flattens directory contents (works today, fragile); Chromium `--no-sandbox` is the usual container tradeoff and the process runs as uid 1000.
- `docs/GAME_SETUP_FLOW.md` is significantly stale versus the implementation (per-`join_code` channel vs actual per-`game_player` streams; `deployment_rolloff`/`deploying` statuses, `role_roll`, `deployment_zone`, `ready` endpoints that don't exist; agenda draw is automatic, not client-initiated). Worth a superseded-by-implementation pass so it stops misleading readers.
- The seeds/snapshot architecture (`CatalogSnapshot` as source of truth, seeds importing it) is well designed and round-trip tested. Migration hygiene is good.

### App

- State management (plain `setState` + singleton `ChangeNotifier` services) is used consistently and with discipline. The main systemic gap is the error-handling inconsistency described in section 9.
- `GameService` is drifting toward a god class (30+ endpoints plus connection lifecycle). Splitting the pure REST facade from the live-session state machine (`currentGame` + cable) would keep the race-prone part small and testable; passing the service (or a watch handle) down from the route instead of the singleton would make ownership explicit and structurally fix C-5/A-5.
- The `DioException → ApiException` wrapper (`_guard`) is copy-pasted across GameService/GangService and open-coded in four more services — one shared helper would guarantee the app-wide contract the comments promise.
- Rendering cost: every screen stacks a full-screen `BackdropFilter` (`AppBackground`) plus one more `BackdropFilter` per list row via `GlassPanel` (gang tiles, menu items, search field, points bar). Each filter forces a `saveLayer`; long glass lists will tax low-end GPUs. Consider a plain translucent decoration for repeated rows, reserving blur for one-off surfaces.
- `gang_builder_screen.dart` is 944 lines; `_buildListTab` alone is ~150 lines mixing display-name computation, entry/profile joins, and navigation closures. The display-name numbering logic exists in three variants (builder id-keyed, gangs-screen name-keyed, viewer); extract one helper. `_isDead`/ordering logic is duplicated between `_ReadOnlyGangBody` and `_GangEntryList`.
- Dead code: `AppPalette.paleStone`, `AppPalette.newsCard`, `_MenuItem.icon` (every call site passes `imagePath`), `lib/models/gang.dart`. Nit: `score_tab.dart:231` has `score == 1 ? 'VP' : 'VP'` — identical branches.
- Comment discipline is notably good (explaining *why*, citing rulebook pages and past findings) — which makes the `watch()` doc-comment/behaviour mismatch (C-5, A-1) worth fixing so the docs stay trustworthy.
- Tooling: `scripts/generate_api.sh` uses `sed -i ''` (macOS/BSD form) and fails on Linux.

### Test coverage gaps

Backend coverage is strong where it exists (games: 66 request examples; lists, list_entries, auth flows, rate limiting, catalog caching, cable tickets; a handy `count_queries` helper; backoffice request flows; staleness; snapshot round-trip). Gaps worth closing, roughly in order of the bugs they would have caught:

- No request specs at all for `/profiles` or `/equipment` — where the ETag staleness (S-1) and nil-cost (B-27) issues live.
- No serializer specs pinning payload shapes against the OpenAPI contract — the `ready` drift (B-14) would have been caught.
- No query-count assertion on `games#index` — the N+1 regression (B-34) slipped past the comment claiming it was fixed.
- Nothing pins the render-token scope (B-18 went unnoticed for the same reason).
- No concurrency tests for join/select_gang/confirm (understandable, but the section-2 races are all untested).
- No model specs for `Catalog::Profile` (the `MAGE_ABILITY`/`DISCIPLINE_KEYWORD` regexes are load-bearing for spell validation and only tested indirectly), `Weapon`, `SpecialRule`, `Ability`, `Illustration`; no specs for `export_pdf`/`export_png`, `illustration_editor`/`illustration_position`, or `lib/tasks/cards.rake` (`prune` deletes files).
- The Flutter app has essentially no widget/service tests for the failure paths described in sections 8-9.

---

## 12. Suggested plan of attack

1. **Security criticals** (small, urgent): C-1 seeds/entrypoint guard; C-2 `entry_type` inclusion validation. Also B-18 (render-token scope) and B-19 (API key on auth endpoints) while in the area.
2. **Backend race class**: one shared `with_game_lock` helper + idempotent `draw_initial`, applied per section 2 (fixes C-3, B-1, B-2, B-3, B-4, B-6). Add `rescue_from RecordInvalid`/`ParameterMissing` (B-17) at the same time.
3. **App connection resilience bundle**: Dio timeouts + non-blocking startup (C-6), ping watchdog + lifecycle resync (C-4), apply REST responses to `currentGame` (A-1), `watch()` generation guard (C-5), stop reconnecting on auth failure (A-2). Consider the snapshot sequence number (A-3) here — it hardens everything above.
4. **App error-handling bundle**: shared `guard()` helper across builder/list screens; surface `ApiException.message` in `_run`; fix the remove-animation ordering (A-7), double-submit (A-8), and back-button trap (A-10).
5. **Card sync coherence**: profiles ETag (S-1), JSON cache invalidation on Sync Cards + a catalog version signal (S-3), Wi-Fi/consent gate on the first-launch bulk download (S-5), web manifest retry (S-4), render-drift signal (S-2).
6. **Contract & data integrity**: OpenAPI spec audit (B-14/15/16), equipment validations (B-27), missing indexes/FKs (B-26), catalog-edit validity refresh (B-24).
7. **Backlog**: remaining minors, performance items (B-34/35/36, per-row blur, `cacheWidth`), maintainability refactors, and the test gaps above.
