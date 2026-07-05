import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import '../models/profile.dart';

class CardViewerScreen extends StatefulWidget {
  const CardViewerScreen({
    super.key,
    required this.profiles,
    required this.initialIndex,
  });

  final List<api.Profile> profiles;
  final int initialIndex;

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

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
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
    if (_flipController.isAnimating) return;
    if (_showingFront) _flipSign = 1;
    _showingFront ? _flipController.forward() : _flipController.reverse();
    setState(() => _showingFront = !_showingFront);
  }

  void _flipDirectional(double velocityX) {
    if (_flipController.isAnimating) return;
    if (_showingFront) {
      _flipSign = velocityX < 0 ? 1 : -1;
      _flipController.forward();
      setState(() => _showingFront = false);
    } else {
      _flipController.reverse();
      setState(() => _showingFront = true);
    }
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
    setState(() {
      _currentIndex = index;
      _showingFront = true;
    });
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
                final profile = widget.profiles[index];
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
                        ? AnimatedBuilder(
                            animation: _flipAnimation,
                            builder: (_, __) {
                              final angle =
                                  _flipAnimation.value * 3.14159 * _flipSign;
                              final showFront = angle.abs() < 1.5708;
                              return Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateY(angle),
                                child: showFront
                                    ? _CardImage(path: profile.frontImage)
                                    : Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.identity()
                                          ..rotateY(3.14159),
                                        child: _CardImage(
                                          path: profile.backImage,
                                        ),
                                      ),
                              );
                            },
                          )
                        : _CardImage(path: profile.frontImage),
                  ),
                );
              },
            ),
            // Close button
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            // Navigation hint
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '${_currentIndex + 1} / ${widget.profiles.length}  •  tap/←→ flip  •  swipe ↑↓ navigate',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.35),
                    fontSize: 12,
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

class _CardImage extends StatelessWidget {
  const _CardImage({required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    final filename = path.split('/').last;
    if (filename.isEmpty) {
      return const Center(
        child: Icon(Icons.broken_image, color: Colors.white38, size: 64),
      );
    }
    return Image.asset(
      'assets/images/cards/$filename',
      fit: BoxFit.contain,
      height: MediaQuery.of(context).size.height * 0.8,
      errorBuilder: (_, __, ___) => const Center(
        child: Icon(Icons.broken_image, color: Colors.white38, size: 64),
      ),
    );
  }
}
