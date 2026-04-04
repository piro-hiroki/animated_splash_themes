import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/particle_field.dart';
import '../widgets/shared_widgets.dart';
import 'splash_animations.dart';

class BounceStyle extends StatelessWidget {
  final String appName;
  final String? appSubtitle;
  final String iconPath;
  final List<Color>? backgroundColors;
  final SplashAnimations anims;

  const BounceStyle({
    super.key,
    required this.appName,
    this.appSubtitle,
    required this.iconPath,
    required this.anims,
    this.backgroundColors,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = backgroundColors;

    return Scaffold(
      body: customColors != null
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: customColors,
                ),
              ),
              child: _content(context),
            )
          : AnimatedBuilder(
              animation: anims.glowCtrl,
              builder: (_, child) {
                final t = anims.glowCtrl.value;
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.lerp(const Color(0xFFFF6B9D), const Color(0xFFFF1493), t)!,
                        Color.lerp(const Color(0xFFFFa500), const Color(0xFFFFD700), t)!,
                        Color.lerp(const Color(0xFFFFD700), const Color(0xFFFF6B9D), t)!,
                      ],
                    ),
                  ),
                  child: child,
                );
              },
              child: _content(context),
            ),
    );
  }

  Widget _content(BuildContext context) {
    return Stack(
      children: [
        Positioned(top: -100, left: -100, child: _circle(300)),
        Positioned(bottom: -80, right: -80, child: _circle(250)),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.2,
          right: MediaQuery.of(context).size.width * 0.1,
          child: _circle(150),
        ),
        Positioned.fill(child: ParticleField(count: 25, color: Colors.white.withAlpha(179))),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildIconArea(anims: anims, child: _iconDecor()),
              const SizedBox(height: 24),
              buildAppName(
                anims: anims,
                appName: appName,
                jaColor: Colors.white,
                enColor: Colors.white.withAlpha(230),
                enText: appSubtitle ?? '',
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: anims.waveOpacity,
                child: buildSoundwave(Colors.white, gap: 6, barWidth: 5),
              ),
              const SizedBox(height: 16),
              FadeTransition(opacity: anims.dotOpacity, child: _funText()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _iconDecor() {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: anims.glowCtrl,
          builder: (_, __) => Opacity(
            opacity: (1 - anims.glowCtrl.value).clamp(0, 1),
            child: Transform.scale(
              scale: 1.0 + anims.glowCtrl.value * 0.8,
              child: Container(
                width: 200, height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [Colors.white.withAlpha(102), Colors.transparent]),
                ),
              ),
            ),
          ),
        ),
        AnimatedBuilder(
          animation: anims.jumpCtrl,
          builder: (_, child) => Transform.rotate(
            angle: anims.jumpCtrl.value * 2 * pi,
            child: child,
          ),
          child: Container(
            width: 220, height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withAlpha(77), width: 3),
            ),
          ),
        ),
        AnimatedBuilder(
          animation: anims.jumpCtrl,
          builder: (_, child) {
            final dy = -sin(anims.jumpCtrl.value * pi) * 20;
            final scale = 1.0 + sin(anims.jumpCtrl.value * pi) * 0.05;
            return Transform.translate(
              offset: Offset(0, dy),
              child: Transform.scale(scale: scale, child: child),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(51), blurRadius: 50, offset: const Offset(0, 20)),
                BoxShadow(color: Colors.white.withAlpha(102), blurRadius: 0, spreadRadius: 4),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Image.asset(iconPath, width: 160, height: 160, fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }

  Widget _circle(double size) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [Colors.white.withAlpha(38), Colors.transparent]),
      ),
    );
  }

  Widget _funText() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: anims.jumpCtrl,
          builder: (_, child) => Transform.rotate(
            angle: sin(anims.jumpCtrl.value * 2 * pi) * 0.175,
            child: child,
          ),
          child: const Text('🎵', style: TextStyle(fontSize: 24)),
        ),
        const SizedBox(width: 12),
        const Text('LOADING...', style: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w700,
          color: Colors.white, letterSpacing: 1.5,
          shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 8)],
        )),
        const SizedBox(width: 12),
        AnimatedBuilder(
          animation: anims.jumpCtrl,
          builder: (_, child) => Transform.rotate(
            angle: -sin(anims.jumpCtrl.value * 2 * pi) * 0.175,
            child: child,
          ),
          child: const Text('🎵', style: TextStyle(fontSize: 24)),
        ),
      ],
    );
  }
}
