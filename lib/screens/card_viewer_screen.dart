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

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import '../app_colors.dart';
import '../l10n/app_localizations.dart';
import '../models/profile.dart';
import '../services/ability_service.dart';
import '../services/card_image_service.dart';
import '../services/settings_service.dart';

class CardViewerScreen extends StatefulWidget {
  const CardViewerScreen({
    super.key,
    required this.profiles,
    required this.initialIndex,
    this.onIndexChanged,
    this.selectedReferenceIds,
    this.onIllustrationChanged,
  });

  final List<api.Profile> profiles;
  final int initialIndex;

  /// Fires as the viewer is paged, so the opener can track which card the user ended on.
  /// Reported through a callback rather than a pop result because the viewer is dismissed
  /// several ways (close button, Escape, system/browser back), not all of which we control.
  final ValueChanged<int>? onIndexChanged;

  /// The card reference id to show for each profile initially (parallel to [profiles]); a missing
  /// or unmatched entry falls back to the profile's first card reference. Lets a hired model open
  /// on the illustration it was actually hired as.
  final List<int>? selectedReferenceIds;

  /// Called when the user switches a card to a different illustration, with the profile's index and
  /// the chosen card reference id. When null (e.g. the catalog browser) switching only previews
  /// locally and persists nothing.
  final void Function(int index, int cardReferenceId)? onIllustrationChanged;

  @override
  State<CardViewerScreen> createState() => _CardViewerScreenState();
}

class _CardViewerScreenState extends State<CardViewerScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;
  late final PageController _pageController;
  late int _currentIndex;
  bool _showingFront = true;
  int _flipSign = 1; // 1 = left-swipe rotation, -1 = right-swipe (mirror)
  // Profile index -> chosen card reference id (which illustration to display). Seeded from
  // widget.selectedReferenceIds; updated as the user cycles illustrations.
  final Map<int, int> _selectedRef = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    final ids = widget.selectedReferenceIds;
    if (ids != null) {
      for (var i = 0; i < ids.length && i < widget.profiles.length; i++) {
        _selectedRef[i] = ids[i];
      }
    }
    _pageController = PageController(initialPage: widget.initialIndex);
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _flip() {
    // A tap keeps spinning/sliding in a consistent direction: the outbound (front→back)
    // and return (back→front) trips use opposite signs so successive taps read as
    // continuous motion rather than a rewind.
    _turnCard(velocityX: _showingFront ? -1 : 1);
  }

  void _flipDirectional(double velocityX) => _turnCard(velocityX: velocityX);

  /// Toggles the visible face, driven by the swipe direction in [velocityX] (negative =
  /// leftward). `t` runs 0 (front) → 1 (back) regardless of direction; [_flipSign] is chosen
  /// so the motion always follows the swipe on both the outbound and return trips — so
  /// swiping the same way twice cycles front → back → front continuously.
  void _turnCard({required double velocityX}) {
    if (_flipController.isAnimating) return;
    final swipeLeft = velocityX < 0;
    if (_showingFront) {
      _flipSign = swipeLeft ? 1 : -1;
      _flipController.forward();
      setState(() => _showingFront = false);
    } else {
      _flipSign = swipeLeft ? -1 : 1;
      _flipController.reverse();
      setState(() => _showingFront = true);
    }
  }

  /// The card reference currently shown for [index] — the selected illustration, or the profile's
  /// first when nothing is selected. Null only for a profile with no printed card.
  api.CardReference? _refFor(int index) {
    final refs = widget.profiles[index].cardReferences;
    if (refs.isEmpty) return null;
    final selId = _selectedRef[index];
    return refs.firstWhere((r) => r.id == selId, orElse: () => refs.first);
  }

  String _frontOf(int index) =>
      _refFor(index)?.cardFront ?? widget.profiles[index].frontImage;
  String _backOf(int index) =>
      _refFor(index)?.cardBack ?? widget.profiles[index].backImage;

  /// Advances the current card to its next illustration (wrapping), resets it to the front, and
  /// reports the choice so the opener can persist it. No-op for a card with a single illustration.
  void _cycleIllustration() {
    final index = _currentIndex;
    final refs = widget.profiles[index].cardReferences.toList();
    if (refs.length < 2) return;
    final curId = _refFor(index)?.id;
    final curPos = refs.indexWhere((r) => r.id == curId);
    final next = refs[(curPos + 1) % refs.length];
    setState(() {
      _selectedRef[index] = next.id;
      _flipController.reset();
      _showingFront = true;
    });
    widget.onIllustrationChanged?.call(index, next.id);
  }

  void _goTo(int index) {
    if (index < 0 || index >= widget.profiles.length) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    _flipController.reset();
    widget.onIndexChanged?.call(index);
    setState(() {
      _currentIndex = index;
      _showingFront = true;
    });
  }

  void _showAbilities() {
    final profile = widget.profiles[_currentIndex];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AbilitiesSheet(profile: profile),
    );
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        _flipDirectional(1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowRight:
        _flipDirectional(-1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowUp:
        _goTo(_currentIndex - 1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowDown:
        _goTo(_currentIndex + 1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.escape:
        Navigator.of(context).pop();
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
  }

  /// Builds the current card with its reveal animation. The flip controller drives a value
  /// `t` from 0 (front) to 1 (back); [_flipSign] carries the swipe direction so the motion
  /// follows the gesture. The animation style is a user preference.
  Widget _buildAnimatedCard(int index) {
    final style = SettingsService().cardFlipStyle;
    final front = _CardImage(path: _frontOf(index));
    final back = _CardImage(path: _backOf(index));
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, _) {
        final t = _flipAnimation.value;
        switch (style) {
          case CardFlipStyle.flip:
            final angle = t * math.pi * _flipSign;
            final showFront = angle.abs() < math.pi / 2;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              child: showFront
                  ? front
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(math.pi),
                      child: back,
                    ),
            );
          case CardFlipStyle.swipe:
            // Cross-slide: front exits toward one edge while back enters from the other,
            // travelling a full screen width so each fully clears the viewport.
            final w = MediaQuery.of(context).size.width;
            return Stack(
              alignment: Alignment.center,
              children: [
                Transform.translate(
                  offset: Offset(-t * w * _flipSign, 0),
                  child: front,
                ),
                Transform.translate(
                  offset: Offset((1 - t) * w * _flipSign, 0),
                  child: back,
                ),
              ],
            );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Focus(
        autofocus: true,
        onKeyEvent: _onKey,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: widget.profiles.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                final isCurrent = index == _currentIndex;
                return Center(
                  child: GestureDetector(
                    onTap: isCurrent ? _flip : null,
                    onHorizontalDragEnd: isCurrent
                        ? (details) {
                            final v = details.primaryVelocity ?? 0;
                            if (v.abs() < 200) return;
                            _flipDirectional(v);
                          }
                        : null,
                    child: isCurrent
                        ? _buildAnimatedCard(index)
                        : _CardImage(path: _frontOf(index)),
                  ),
                );
              },
            ),
            // Close button
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ),
            // Switch-illustration button (top-right), only when this card has more than one. Cycles
            // through the profile's illustrations; the opener decides whether the choice persists.
            if (widget.profiles[_currentIndex].cardReferences.length > 1)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      tooltip: AppLocalizations.of(context).cardSwitchIllustration,
                      icon: const Icon(
                        Icons.collections,
                        color: Colors.white,
                        size: 26,
                      ),
                      onPressed: _cycleIllustration,
                    ),
                  ),
                ),
              ),
            // Bottom bar: the navigation hint on the left, the abilities button on the right. The
            // Row gives the button its natural height, so nothing is clipped.
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 8, 16),
                  child: Row(
                    key: const Key('card-viewer-bottom-bar'),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          AppLocalizations.of(context).cardViewerHint(
                            _currentIndex + 1,
                            widget.profiles.length,
                          ),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.35),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _showAbilities,
                        icon: const Icon(Icons.info_outline, size: 20),
                        label: Text(AppLocalizations.of(context).cardAbilities),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet listing the Character and Weapon abilities on a profile, each with its rulebook
/// description resolved from the glossary (rulebook p44-48).
class _AbilitiesSheet extends StatefulWidget {
  const _AbilitiesSheet({required this.profile});

  final api.Profile profile;

  @override
  State<_AbilitiesSheet> createState() => _AbilitiesSheetState();
}

class _AbilitiesSheetState extends State<_AbilitiesSheet> {
  // Resolved once, not per drag frame: the DraggableScrollableSheet's builder re-runs on every
  // drag, so a future created inline in the FutureBuilder would reset it to a spinner each frame —
  // and re-hit the network every frame if the first load failed (A-11b).
  late final Future<void> _abilitiesFuture = AbilityService().load();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: context.cardBgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: FutureBuilder<void>(
            future: _abilitiesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return SizedBox(
                  height: 160,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: context.accentColor,
                    ),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).cardAbilitiesLoadFailed,
                      style: TextStyle(color: context.subtleTextColor),
                    ),
                  ),
                );
              }

              final service = AbilityService();
              final character = service.characterAbilities(widget.profile);
              final weapon = service.weaponAbilities(widget.profile);

              return ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: context.subtleTextColor.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    widget.profile.name,
                    style: GoogleFonts.cinzel(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: context.textColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (character.isEmpty && weapon.isEmpty)
                    Text(
                      AppLocalizations.of(context).cardNoAbilities,
                      style: TextStyle(
                        color: context.subtleTextColor,
                        fontSize: 14,
                      ),
                    ),
                  if (character.isNotEmpty) ...[
                    _SectionTitle(AppLocalizations.of(context).cardCharacterAbilities),
                    ...character.map((a) => _AbilityEntry(ability: a)),
                  ],
                  if (weapon.isNotEmpty) ...[
                    if (character.isNotEmpty) const SizedBox(height: 8),
                    _SectionTitle(AppLocalizations.of(context).cardWeaponAbilities),
                    ...weapon.map((a) => _AbilityEntry(ability: a)),
                  ],
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          color: context.accentColor.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}

class _AbilityEntry extends StatelessWidget {
  const _AbilityEntry({required this.ability});
  final ResolvedAbility ability;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ability.label,
            style: GoogleFonts.cinzel(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: context.accentColor,
            ),
          ),
          if (ability.description != null) ...[
            const SizedBox(height: 4),
            Text(
              ability.description!,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.4,
                color: context.textColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    final filename = path.split('/').last;
    // Faces are fetched from the backend and cached locally (mobile) or by the browser (web),
    // rather than bundled with the app — see CardImageService.
    final provider = filename.isEmpty
        ? null
        : CardImageService().provider(filename);
    if (provider == null) {
      return const Center(
        child: Icon(Icons.broken_image, color: Colors.white38, size: 64),
      );
    }
    return Image(
      image: provider,
      fit: BoxFit.contain,
      height: MediaQuery.of(context).size.height * 0.8,
      errorBuilder: (_, _, _) => const Center(
        child: Icon(Icons.broken_image, color: Colors.white38, size: 64),
      ),
    );
  }
}
