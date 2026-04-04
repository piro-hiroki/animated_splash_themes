import 'package:flutter/material.dart';
import '../widgets/particle_field.dart';
import '../widgets/shared_widgets.dart';
import 'splash_animations.dart';

class ParticlesStyle extends StatelessWidget {
  final String appName;
  final String? appSubtitle;
  final String iconPath;
  final List<Color>? backgroundColors;
  final Color? accentColor;
  final SplashAnimations anims;

  const ParticlesStyle({
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
        const [Color(0xFF7EE8D8), Color(0xFF4EC9B8), Color(0xFF3AB5A8), Color(0xFF2DA09A)];
    final accent = accentColor ?? const Color(0xFF6DD5C0);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: bgColors,
          ),
        ),
        child: Stack(
          children: [
            Positioned(top: -120, right: -100, child: _bgCircle(500)),
            Positioned(bottom: -80, left: -80, child: _bgCircle(350)),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.4,
              left: MediaQuery.of(context).size.width * 0.1,
              child: _bgCircle(200),
            ),
            Positioned.fill(child: ParticleField(count: 20, color: Colors.white.withAlpha(128))),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildIconArea(anims: anims, child: _iconDecor(accent)),
                  const SizedBox(height: 28),
                  buildAppName(
                    anims: anims,
                    appName: appName,
                    jaColor: Colors.white,
                    enColor: Colors.white.withAlpha(204),
                    enText: appSubtitle ?? '',
                  ),
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: anims.waveOpacity,
                    child: buildSoundwave(Colors.white.withAlpha(209)),
                  ),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: anims.dotOpacity,
                    child: buildBounceDots(Colors.white.withAlpha(184)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconDecor(Color accent) {
    return AnimatedBuilder(
      animation: anims.glowAnim,
      builder: (_, child) {
        final glowOpacity = 0.35 + anims.glowAnim.value * 0.3;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(71), blurRadius: 64, offset: const Offset(0, 24)),
              BoxShadow(color: Colors.black.withAlpha(46), blurRadius: 24, offset: const Offset(0, 8)),
              BoxShadow(color: Colors.white.withAlpha((glowOpacity * 255).toInt()), blurRadius: 0, spreadRadius: 3),
              BoxShadow(
                color: accent.withAlpha((anims.glowAnim.value * 0.65 * 255).toInt()),
                blurRadius: 50,
              ),
            ],
          ),
          child: child,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Image.asset(iconPath, width: 160, height: 160, fit: BoxFit.cover),
      ),
    );
  }

  Widget _bgCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [Colors.white.withAlpha(31), Colors.transparent]),
      ),
    );
  }
}
