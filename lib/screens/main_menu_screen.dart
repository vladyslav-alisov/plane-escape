import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'game_screen.dart';
import '../services/high_score_service.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> with SingleTickerProviderStateMixin {
  final HighScoreService _scoreService = HighScoreService();
  double _highScore = 0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _loadHighScore();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadHighScore() async {
    final score = await _scoreService.getHighScore();
    if (mounted) {
      setState(() {
        _highScore = score;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Stack(
        children: [
          // Animated Background Simulation
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                top: -_controller.value * 200,
                left: 0,
                right: 0,
                bottom: 0,
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    'assets/images/game_background.png',
                    repeat: ImageRepeat.repeat,
                    alignment: Alignment.topCenter,
                  ),
                ),
              );
            },
          ),
          
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    'PLANE',
                    style: GoogleFonts.pressStart2p(
                      fontSize: 48,
                      color: Colors.white,
                      shadows: [
                        const Shadow(color: Colors.blue, offset: Offset(4, 4)),
                      ],
                    ),
                  ),
                  Text(
                    'ESCAPE',
                    style: GoogleFonts.pressStart2p(
                      fontSize: 48,
                      color: Colors.white,
                      shadows: [
                        const Shadow(color: Colors.redAccent, offset: Offset(4, 4)),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Plane Showcase
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeInOutSine,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 10 * value),
                        child: child,
                      );
                    },
                    child: Image.asset(
                      'assets/images/player_plane.png',
                      height: 120,
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // High Score
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Text(
                      'Best Flight: ${_highScore.toInt()}s',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 14,
                        color: Colors.amberAccent,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Play Button
                  _ArcadeButton(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const GameScreen()),
                      );
                    },
                    label: 'START MISSION',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArcadeButton extends StatefulWidget {
  final VoidCallback onTap;
  final String label;

  const _ArcadeButton({required this.onTap, required this.label});

  @override
  State<_ArcadeButton> createState() => _ArcadeButtonState();
}

class _ArcadeButtonState extends State<_ArcadeButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.blue, Colors.blueAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.5),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: Colors.white24, width: 2),
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.pressStart2p(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
