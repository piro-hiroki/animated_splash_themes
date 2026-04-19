import 'package:flutter/material.dart';

/// 各スタイルウィジェットに渡すアニメーション一式
class SplashAnimations {
  final Animation<double> iconScale;
  final Animation<double> iconOpacity;
  final Animation<double> nameOpacity;
  final Animation<Offset> nameSlide;
  final Animation<double> waveOpacity;
  final Animation<double> dotOpacity;
  final Animation<double> glowAnim;
  final AnimationController glowCtrl;
  final AnimationController jumpCtrl;

  /// expand スタイル用: アプリ名の拡大スケール (1.0 → 巨大)
  final Animation<double> expandScale;

  /// expand スタイル用: 拡大終盤のフェードアウト (1.0 → 0.0)
  final Animation<double> expandFade;

  const SplashAnimations({
    required this.iconScale,
    required this.iconOpacity,
    required this.nameOpacity,
    required this.nameSlide,
    required this.waveOpacity,
    required this.dotOpacity,
    required this.glowAnim,
    required this.glowCtrl,
    required this.jumpCtrl,
    required this.expandScale,
    required this.expandFade,
  });
}
