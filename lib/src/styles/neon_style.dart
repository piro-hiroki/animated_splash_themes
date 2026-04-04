import 'package:flutter/material.dart';
import '../widgets/particle_field.dart';
import '../widgets/shared_widgets.dart';
import 'splash_animations.dart';

class NeonStyle extends StatelessWidget {
  final String appName;
  final String? appSubtitle;
  final String iconPath;
  final List<Color>? backgroundColors;
  final Color? accentColor;
  final SplashAnimations anims;

  const NeonStyle({
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
        const [Color(0xFF0A0E27), Color(0xFF1A1F3A), Color(0xFF0F1428)];
    final neon = accentColor ?? const Color(0xFF00FFC8);

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
            Center(child: _glowBlob(400, neon.withAlpha(38))),
            Positioned(bottom: -100, right: -100, child: _glowBlob(300, const Color(0xFF64C8FF).withAlpha(25))),
            Positioned.fill(child: ParticleField(count: 15, color: neon.withAlpha(153))),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildIconArea(anims: anims, child: _iconDecor(neon)),
                  const SizedBox(height: 32),
                  buildAppName(
                    anims: anims,
                    appName: appName,
                    jaColor: neon,
                    enColor: neon.withAlpha(153),
                    enText: appSubtitle ?? '',
                    isMono: true,
                  ),
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: anims.waveOpacity,
                    child: buildSoundwave(neon, glowColor: neon),
                  ),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: anims.dotOpacity,
                    child: _statusRow(neon),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconDecor(Color neon) {
    return AnimatedBuilder(
      animation: anims.glowAnim,
      builder: (_, child) {
        final intensity = 0.6 + anims.glowAnim.value * 0.3;
        return Stack(
          children: [
            ..._corners(neon),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: neon.withAlpha((0.5 * intensity * 255).toInt()), blurRadius: 0, spreadRadius: 2),
                  BoxShadow(color: neon.withAlpha((0.6 * intensity * 255).toInt()), blurRadius: 20),
                  BoxShadow(color: neon.withAlpha((0.3 * intensity * 255).toInt()), blurRadius: 40),
                ],
              ),
              child: child,
            ),
          ],
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(iconPath, width: 160, height: 160, fit: BoxFit.cover),
      ),
    );
  }

  List<Widget> _corners(Color color) {
    const size = 20.0;
    const off = -8.0;
    final s = BorderSide(color: color.withAlpha(153), width: 2);
    const n = BorderSide.none;
    Widget corner(double? t, double? b, double? l, double? r,
        BorderSide top, BorderSide bottom, BorderSide left, BorderSide right) =>
        Positioned(
          top: t, bottom: b, left: l, right: r,
          child: Container(
            width: size, height: size,
            decoration: BoxDecoration(border: Border(top: top, bottom: bottom, left: left, right: right)),
          ),
        );
    return [
      corner(off, null, off, null, s, n, s, n),
      corner(off, null, null, off, s, n, n, s),
      corner(null, off, off, null, n, s, s, n),
      corner(null, off, null, off, n, s, n, s),
    ];
  }

  Widget _glowBlob(double size, Color color) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 80, spreadRadius: 40)],
      ),
    );
  }

  Widget _statusRow(Color neon) {
    return AnimatedBuilder(
      animation: anims.glowCtrl,
      builder: (_, __) {
        final opacity = 0.3 + anims.glowCtrl.value * 0.7;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('LOADING...', style: TextStyle(
              fontSize: 11, color: neon.withAlpha(153),
              letterSpacing: 1.5, fontFamily: 'Courier',
              shadows: [Shadow(color: neon.withAlpha(77), blurRadius: 6)],
            )),
            const SizedBox(width: 8),
            Container(
              width: 6, height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle, color: neon,
                boxShadow: [BoxShadow(color: neon.withAlpha((opacity * 255).toInt()), blurRadius: 8)],
              ),
            ),
          ],
        );
      },
    );
  }
}
