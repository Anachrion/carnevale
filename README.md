# Carnevale

A fan-made companion app for [Carnevale](https://ttcombat.com/pages/carnevale), the skirmish wargame by TT Combat set in a dystopian 18th-century Venice.

> This is an unofficial, community-driven project and is not affiliated with TT Combat.

## What is Carnevale?

Carnevale is a two-player skirmish tabletop game where warbands clash across the rooftops and canals of a dark, supernatural Venice. Factions range from the city's noble families to monsters lurking beneath the lagoon.

## What does this app do?

This app is a gaming tool designed to be used before and during a game. The planned MVP features are:

- **Cards browser** — browse all in-game cards and references
- **Crew builder** — build and save your warband list before a game
- **Live game session** — connect with your opponent to share lists, pick the scenario, and choose secondary objectives (the Agenda)
- **Settings & options** — utility options for a smoother game experience

## Platforms

Available on iOS, Android, and Web.

## Getting Started

```bash
flutter pub get
flutter run
```

## Testing

### Two-player login helper

Manually testing the two-player game flow normally means logging into two separate browsers by hand each time. `scripts/two_player_login.py` automates that: it drives the real login form in two isolated Chrome windows (no auth bypass, no app changes) and leaves both logged in and open for you to test with.

Requirements:
- The backend seeded with the dev test accounts (`player1@dev.local` / `player2@dev.local`, password `password123`) — from `carnevale-backend`, run `rails db:seed`.
- The Flutter web dev server running: `./dev.sh` (serves on `http://localhost:56569`).
- Python 3 with Selenium: `pip install selenium`.

Run it:

```bash
python3 scripts/two_player_login.py
```

Pass `--url` if your dev server runs on a different port.
