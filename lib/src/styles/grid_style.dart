import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/shared_widgets.dart';
import 'splash_animations.dart';

class GridStyle extends StatelessWidget {
  final String appName;
  final String? appSubtitle;
  final String iconPath;
  final List<Color>? backgroundColors;
  final Color? accentColor;
  final SplashAnimations anims;

  const GridStyle({
    super.key,
    required this.appName,
    this.appSubtitle,
    required this.iconPath,
    required this.anims,
    this.backgroundColors,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColors = backgroundColors ??
        const [Color(0xFFF5F5F5), Color(0xFFE8E8E8)];
    final accent = accentColor ?? const Color(0xFF4A90E2);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: bgColors,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _GridPainter())),
            Positioned(
              bottom: 60, left: 0, right: 0,
              child: _pulseLine(accent),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildIconArea(anims: anims, child: _iconDecor(accent)),
                  const SizedBox(height: 40),
                  buildAppName(
                    anims: anims,
                    appName: appName,
                    jaColor: const Color(0xFF1A1A1A),
                    enColor: const Color(0xFF666666),
                    enText: appSubtitle ?? '',
                    fontSize: 26,
                  ),
                  const SizedBox(height: 20),
                  FadeTransition(opacity: anims.waveOpacity, child: buildSoundwave(accent)),
                  const SizedBox(height: 16),
                  FadeTransition(opacity: anims.dotOpacity, child: _statusRow(accent)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pulseLine(Color accent) {
    return AnimatedBuilder(
      animation: anims.glowCtrl,
      builder: (_, __) {
        final w = 40.0 + anims.glowCtrl.value * 80.0;
        final opacity = 0.3 + anims.glowCtrl.value * 0.7;
        return Center(
          child: Container(
            width: w, height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.transparent,
                accent.withAlpha((opacity * 255).toInt()),
                Colors.transparent,
              ]),
            ),
          ),
        );
      },
    );
  }

  Widget _iconDecor(Color accent) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: anims.glowCtrl,
          builder: (_, __) => Transform.rotate(
            angle: anims.glowCtrl.value * 2 * pi,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: accent.withAlpha(51), width: 1),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.translate(
                    offset: const Offset(0, -100),
                    child: Container(
                      width: 4, height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, color: accent,
                        boxShadow: [BoxShadow(color: accent.withAlpha(153), blurRadius: 6)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 40, offset: const Offset(0, 12))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset(iconPath, width: 140, height: 140, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }

  Widget _statusRow(Color accent) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: anims.glowCtrl,
          builder: (_, __) => Container(
            width: 5, height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withAlpha(((0.3 + anims.glowCtrl.value * 0.7) * 255).toInt()),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text('INITIALIZING', style: TextStyle(
          fontSize: 11, color: Color(0xFF999999), letterSpacing: 1.0,
        )),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withAlpha(8)
      ..strokeWidth = 1;
    const step = 40.0;
    for (var x = 0.0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
