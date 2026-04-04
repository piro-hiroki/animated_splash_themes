import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'splash_theme.dart';
import 'styles/splash_animations.dart';
import 'styles/particles_style.dart';
import 'styles/neon_style.dart';
import 'styles/grid_style.dart';
import 'styles/bounce_style.dart';

/// アニメーション付きスプラッシュ画面
///
/// 使用例:
/// ```dart
/// home: AnimatedSplashScreen(
///   appName: 'My App',
///   appSubtitle: 'POWERED BY AI',
///   iconPath: 'assets/images/icon.png',
///   theme: SplashStyle.random,
///   nextScreen: const HomePage(),
/// ),
/// ```
class AnimatedSplashScreen extends StatefulWidget {
  /// メインのアプリ名（大きく表示される）
  final String appName;

  /// サブタイトル（小さく表示される）。省略時は空文字
  final String? appSubtitle;

  /// アイコン画像のアセットパス（例: 'assets/images/icon.png'）
  final String iconPath;

  /// 使用するスタイル。[SplashStyle.random] でランダム選択
  final SplashStyle theme;

  /// スプラッシュ完了後に表示する画面
  final Widget nextScreen;

  /// スプラッシュ表示時間（デフォルト: 2650ms）
  final Duration duration;

  /// スプラッシュ→次画面のフェードトランジション時間（デフォルト: 1200ms）
  final Duration transitionDuration;

  /// 背景グラデーションカラー。省略時は各スタイルのデフォルト色を使用
  final List<Color>? backgroundColors;

  /// アクセントカラー。省略時は各スタイルのデフォルト色を使用
  final Color? accentColor;

  const AnimatedSplashScreen({
    super.key,
    required this.appName,
    this.appSubtitle,
    required this.iconPath,
    required this.nextScreen,
    this.theme = SplashStyle.random,
    this.duration = const Duration(milliseconds: 2650),
    this.transitionDuration = const Duration(milliseconds: 1200),
    this.backgroundColors,
    this.accentColor,
  });

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with TickerProviderStateMixin {
  late final SplashStyle _resolvedStyle;

  late final AnimationController _iconCtrl;
  late final AnimationController _nameCtrl;
  late final AnimationController _waveCtrl;
  late final AnimationController _dotCtrl;
  late final AnimationController _glowCtrl;
  late final AnimationController _jumpCtrl;

  late final SplashAnimations _anims;

  @override
  void initState() {
    super.initState();

    _resolvedStyle = widget.theme == SplashStyle.random
        ? SplashStyle.values
            .where((t) => t != SplashStyle.random)
            .toList()[Random().nextInt(SplashStyle.values.length - 1)]
        : widget.theme;

    if (_resolvedStyle == SplashStyle.neon) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ));
    }

    _iconCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 750));
    _nameCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 650));
    _waveCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 650));
    _dotCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 650));
    _glowCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000));
    _jumpCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));

    final iconCurve = switch (_resolvedStyle) {
      SplashStyle.bounce => Curves.elasticOut,
      SplashStyle.grid   => Curves.easeOut,
      _                  => const Cubic(0.34, 1.56, 0.64, 1),
    };

    _anims = SplashAnimations(
      iconScale: Tween(begin: _resolvedStyle == SplashStyle.bounce ? 0.0 : 0.25, end: 1.0)
          .animate(CurvedAnimation(parent: _iconCtrl, curve: iconCurve)),
      iconOpacity: Tween(begin: 0.0, end: 1.0)
          .animate(CurvedAnimation(parent: _iconCtrl, curve: const Interval(0.0, 0.6))),
      nameOpacity: Tween(begin: 0.0, end: 1.0)
          .animate(CurvedAnimation(parent: _nameCtrl, curve: Curves.easeOut)),
      nameSlide: Tween(begin: const Offset(0, 0.4), end: Offset.zero)
          .animate(CurvedAnimation(parent: _nameCtrl, curve: Curves.easeOut)),
      waveOpacity: Tween(begin: 0.0, end: 1.0)
          .animate(CurvedAnimation(parent: _waveCtrl, curve: Curves.easeOut)),
      dotOpacity: Tween(begin: 0.0, end: 1.0)
          .animate(CurvedAnimation(parent: _dotCtrl, curve: Curves.easeOut)),
      glowAnim: Tween(begin: 0.0, end: 1.0)
          .animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut)),
      glowCtrl: _glowCtrl,
      jumpCtrl: _jumpCtrl,
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _iconCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 550));
    _nameCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    _waveCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    _dotCtrl.forward();

    _glowCtrl.repeat(reverse: true);
    _jumpCtrl.repeat(reverse: true);

    final remaining = widget.duration - const Duration(milliseconds: 1350);
    if (remaining > Duration.zero) await Future.delayed(remaining);
    if (mounted) _navigate();
  }

  void _navigate() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => widget.nextScreen,
        transitionDuration: widget.transitionDuration,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _iconCtrl.dispose();
    _nameCtrl.dispose();
    _waveCtrl.dispose();
    _dotCtrl.dispose();
    _glowCtrl.dispose();
    _jumpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return switch (_resolvedStyle) {
      SplashStyle.particles => ParticlesStyle(
          appName: widget.appName, appSubtitle: widget.appSubtitle,
          iconPath: widget.iconPath, anims: _anims,
          backgroundColors: widget.backgroundColors, accentColor: widget.accentColor),
      SplashStyle.neon => NeonStyle(
          appName: widget.appName, appSubtitle: widget.appSubtitle,
          iconPath: widget.iconPath, anims: _anims,
          backgroundColors: widget.backgroundColors, accentColor: widget.accentColor),
      SplashStyle.grid => GridStyle(
          appName: widget.appName, appSubtitle: widget.appSubtitle,
          iconPath: widget.iconPath, anims: _anims,
          backgroundColors: widget.backgroundColors, accentColor: widget.accentColor),
      SplashStyle.bounce => BounceStyle(
          appName: widget.appName, appSubtitle: widget.appSubtitle,
          iconPath: widget.iconPath, anims: _anims,
          backgroundColors: widget.backgroundColors),
      SplashStyle.random => const SizedBox.shrink(), // unreachable
    };
  }
}
