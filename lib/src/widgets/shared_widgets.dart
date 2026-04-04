import 'package:flutter/material.dart';
import '../styles/splash_animations.dart';
import 'wave_bar.dart';
import 'bounce_dot.dart';

/// アイコンのスケール + フェードアニメーション
Widget buildIconArea({
  required SplashAnimations anims,
  required Widget child,
}) {
  return AnimatedBuilder(
    animation: anims.iconOpacity,
    builder: (_, __) => Opacity(
      opacity: anims.iconOpacity.value,
      child: Transform.scale(scale: anims.iconScale.value, child: child),
    ),
  );
}

/// アプリ名 + サブタイトルのフェード + スライドアニメーション
Widget buildAppName({
  required SplashAnimations anims,
  required String appName,
  required Color jaColor,
  required Color enColor,
  required String enText,
  double fontSize = 30,
  FontWeight fontWeight = FontWeight.w800,
  bool isMono = false,
}) {
  return FadeTransition(
    opacity: anims.nameOpacity,
    child: SlideTransition(
      position: anims.nameSlide,
      child: Column(
        children: [
          Text(
            appName,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: jaColor,
              letterSpacing: 0.05,
              fontFamily: isMono ? 'Courier' : null,
              shadows: [Shadow(color: Colors.black.withAlpha(56), blurRadius: 16, offset: const Offset(0, 2))],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            enText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: enColor,
              letterSpacing: 3.0,
              fontFamily: isMono ? 'Courier' : null,
            ),
          ),
        ],
      ),
    ),
  );
}

/// サウンドウェーブ
Widget buildSoundwave(Color color, {Color? glowColor, double gap = 4, double barWidth = 4}) {
  const heights = [10.0, 18.0, 26.0, 36.0, 44.0, 36.0, 44.0, 36.0, 26.0, 18.0, 10.0];
  const delays = [0.00, 0.10, 0.20, 0.30, 0.15, 0.05, 0.25, 0.35, 0.20, 0.10, 0.00];
  return SizedBox(
    height: 52,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(heights.length, (i) => Padding(
        padding: EdgeInsets.symmetric(horizontal: gap / 2),
        child: WaveBar(
          height: heights[i],
          width: barWidth,
          color: color,
          glowColor: glowColor,
          delay: delays[i],
        ),
      )),
    ),
  );
}

/// バウンスドット × 3
Widget buildBounceDots(Color color) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(3, (i) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.5),
      child: BounceDot(color: color, delay: i * 0.22),
    )),
  );
}
