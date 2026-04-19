import 'package:flutter/material.dart';
import 'splash_animations.dart';

/// アプリ名が拡大してホーム画面に遷移する X 風スタイル
class ExpandStyle extends StatelessWidget {
  final String appName;
  final String? appSubtitle;
  final String? iconPath;
  final List<Color>? backgroundColors;
  final Color? accentColor;
  final SplashAnimations anims;

  const ExpandStyle({
    super.key,
    required this.appName,
    this.appSubtitle,
    this.iconPath,
    required this.anims,
    this.backgroundColors,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColors = backgroundColors ??
        const [Color(0xFF0F172A), Color(0xFF1E293B)];
    final accent = accentColor ?? Colors.white;

    return Scaffold(
      backgroundColor: bgColors.first,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: bgColors,
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([
              anims.nameOpacity,
              anims.expandScale,
              anims.expandFade,
            ]),
            builder: (context, _) {
              return Opacity(
                opacity: anims.nameOpacity.value * anims.expandFade.value,
                child: Transform.scale(
                  scale: anims.expandScale.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (iconPath != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            iconPath!,
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      Text(
                        appName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: accent,
                          letterSpacing: -1.0,
                          height: 1.0,
                        ),
                      ),
                      if (appSubtitle != null && appSubtitle!.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          appSubtitle!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: accent.withAlpha(179),
                            letterSpacing: 3.0,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
