import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/profile.dart';

class CardViewerScreen extends StatefulWidget {
  const CardViewerScreen({
    super.key,
    required this.profiles,
    required this.initialIndex,
  });

  final List<Profile> profiles;
  final int initialIndex;

  @override
  State<CardViewerScreen> createState() => _CardViewerScreenState();
}

class _CardViewerScreenState extends State<CardViewerScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late int _currentIndex;
  bool _showingFront = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Profile get _current => widget.profiles[_currentIndex];

  void _flip() {
    if (_controller.isAnimating) return;
    _showingFront ? _controller.forward() : _controller.reverse();
    setState(() => _showingFront = !_showingFront);
  }

  void _goTo(int index) {
    if (index < 0 || index >= widget.profiles.length) return;
    _controller.reset();
    setState(() {
      _currentIndex = index;
      _showingFront = true;
    });
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
      case LogicalKeyboardKey.arrowRight:
        _flip();
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
            // Card image
            Center(
              child: GestureDetector(
                onTap: _flip,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (_, __) {
                    final angle = _animation.value * 3.14159;
                    final showFront = angle < 1.5708;
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle),
                      child: showFront
                          ? _CardImage(path: _current.frontImage)
                          : Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..rotateY(3.14159),
                              child: _CardImage(path: _current.backImage),
                            ),
                    );
                  },
                ),
              ),
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
                  '${_currentIndex + 1} / ${widget.profiles.length}  •  ←→ flip  •  ↑↓ navigate',
                  style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 12),
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
    return Image.asset(
      path.startsWith('assets/') ? path : 'assets/$path',
      fit: BoxFit.contain,
      height: MediaQuery.of(context).size.height * 0.8,
      errorBuilder: (_, __, ___) => const Center(
        child: Icon(Icons.broken_image, color: Colors.white38, size: 64),
      ),
    );
  }
}
