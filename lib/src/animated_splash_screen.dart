import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'splash_theme.dart';
import 'widgets/wave_bar.dart';
import 'widgets/bounce_dot.dart';
import 'widgets/particle_field.dart';

/// アニメーション付きスプラッシュ画面
///
/// 使用例:
/// ```dart
/// home: AnimatedSplashScreen(
///   appName: 'My App',
///   appSubtitle: 'POWERED BY AI',
///   iconPath: 'assets/images/icon.png',
///   theme: SplashTheme.random,
///   nextScreen: const HomePage(),
/// ),
/// ```
class AnimatedSplashScreen extends StatefulWidget {
  /// メインのアプリ名（大きく表示される）
  final String appName;

  /// サブタイトル（小さく表示される）。省略時はテーマのデフォルトを使用
  final String? appSubtitle;

  /// アイコン画像のアセットパス（例: 'assets/images/icon.png'）
  final String iconPath;

  /// 使用するテーマ。[SplashTheme.random] でランダム選択
  final SplashTheme theme;

  /// スプラッシュ完了後に表示する画面
  final Widget nextScreen;

  /// スプラッシュ表示時間（デフォルト: 2650ms）
  final Duration duration;

  /// スプラッシュ→次画面のフェードトランジション時間（デフォルト: 1200ms）
  final Duration transitionDuration;

  const AnimatedSplashScreen({
    super.key,
    required this.appName,
    this.appSubtitle,
    required this.iconPath,
    required this.nextScreen,
    this.theme = SplashTheme.random,
    this.duration = const Duration(milliseconds: 2650),
    this.transitionDuration = const Duration(milliseconds: 1200),
  });

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with TickerProviderStateMixin {
  late final SplashTheme _resolvedTheme;

  late final AnimationController _iconCtrl;
  late final AnimationController _nameCtrl;
  late final AnimationController _waveCtrl;
  late final AnimationController _dotCtrl;
  late final AnimationController _glowCtrl;
  late final AnimationController _jumpCtrl;

  late final Animation<double> _iconScale;
  late final Animation<double> _iconOpacity;
  late final Animation<double> _nameOpacity;
  late final Animation<Offset> _nameSlide;
  late final Animation<double> _waveOpacity;
  late final Animation<double> _dotOpacity;
  late final Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();

    _resolvedTheme = widget.theme == SplashTheme.random
        ? SplashTheme.values
            .where((t) => t != SplashTheme.random)
            .toList()[Random().nextInt(SplashTheme.values.length - 1)]
        : widget.theme;

    if (_resolvedTheme == SplashTheme.midnight) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ));
    }

    _iconCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 750));
    _nameCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 650));
    _waveCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 650));
    _dotCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 650));
    _glowCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000));
    _jumpCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));

    final iconCurve = _resolvedTheme == SplashTheme.pop
        ? Curves.elasticOut
        : _resolvedTheme == SplashTheme.minimalist
            ? Curves.easeOut
            : const Cubic(0.34, 1.56, 0.64, 1);

    _iconScale = Tween(begin: _resolvedTheme == SplashTheme.pop ? 0.0 : 0.25, end: 1.0)
        .animate(CurvedAnimation(parent: _iconCtrl, curve: iconCurve));
    _iconOpacity = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _iconCtrl, curve: const Interval(0.0, 0.6)));

    _nameOpacity = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _nameCtrl, curve: Curves.easeOut));
    _nameSlide = Tween(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(CurvedAnimation(parent: _nameCtrl, curve: Curves.easeOut));

    _waveOpacity = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _waveCtrl, curve: Curves.easeOut));
    _dotOpacity = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _dotCtrl, curve: Curves.easeOut));

    _glowAnim = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));

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
    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }
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
    return switch (_resolvedTheme) {
      SplashTheme.teal => _buildTeal(context),
      SplashTheme.midnight => _buildMidnight(context),
      SplashTheme.minimalist => _buildMinimalist(context),
      SplashTheme.pop => _buildPop(context),
      SplashTheme.random => _buildTeal(context), // unreachable
    };
  }

  // ============================================================
  // テーマ1: Teal
  // ============================================================
  Widget _buildTeal(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF7EE8D8), Color(0xFF4EC9B8), Color(0xFF3AB5A8), Color(0xFF2DA09A)],
            stops: [0.0, 0.35, 0.70, 1.0],
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
                  _buildIconArea(child: _tealIconDecor()),
                  const SizedBox(height: 28),
                  _buildAppName(
                    jaColor: Colors.white,
                    enColor: Colors.white.withAlpha(204),
                    enText: widget.appSubtitle ?? 'POWERED BY AI',
                  ),
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: _waveOpacity,
                    child: _buildSoundwave(Colors.white.withAlpha(209)),
                  ),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: _dotOpacity,
                    child: _buildBounceDots(Colors.white.withAlpha(184)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tealIconDecor() {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (_, child) {
        final glowOpacity = 0.35 + _glowAnim.value * 0.3;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(71), blurRadius: 64, offset: const Offset(0, 24)),
              BoxShadow(color: Colors.black.withAlpha(46), blurRadius: 24, offset: const Offset(0, 8)),
              BoxShadow(color: Colors.white.withAlpha((glowOpacity * 255).toInt()), blurRadius: 0, spreadRadius: 3),
              BoxShadow(
                color: const Color(0xFF6DD5C0).withAlpha((_glowAnim.value * 0.65 * 255).toInt()),
                blurRadius: 50,
              ),
            ],
          ),
          child: child,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Image.asset(widget.iconPath, width: 160, height: 160, fit: BoxFit.cover),
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

  // ============================================================
  // テーマ2: Midnight
  // ============================================================
  Widget _buildMidnight(BuildContext context) {
    const neon = Color(0xFF00FFC8);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A), Color(0xFF0F1428)],
            stops: [0.0, 0.40, 1.0],
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
                  _buildIconArea(child: _midnightIconDecor(neon)),
                  const SizedBox(height: 32),
                  _buildAppName(
                    jaColor: neon,
                    enColor: neon.withAlpha(153),
                    enText: widget.appSubtitle ?? 'POWERED BY AI',
                    isMono: true,
                  ),
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: _waveOpacity,
                    child: _buildSoundwave(neon, glowColor: neon),
                  ),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: _dotOpacity,
                    child: _midnightStatus(neon),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _midnightIconDecor(Color neon) {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (_, child) {
        final intensity = 0.6 + _glowAnim.value * 0.3;
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
        child: Image.asset(widget.iconPath, width: 160, height: 160, fit: BoxFit.cover),
      ),
    );
  }

  List<Widget> _corners(Color color) {
    const size = 20.0;
    const off = -8.0;
    final s = BorderSide(color: color.withAlpha(153), width: 2);
    const n = BorderSide.none;
    Widget corner(double? t, double? b, double? l, double? r, BorderSide top, BorderSide bottom, BorderSide left, BorderSide right) =>
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

  Widget _midnightStatus(Color neon) {
    return AnimatedBuilder(
      animation: _glowCtrl,
      builder: (_, __) {
        final opacity = 0.3 + _glowCtrl.value * 0.7;
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

  // ============================================================
  // テーマ3: Minimalist
  // ============================================================
  Widget _buildMinimalist(BuildContext context) {
    const blue = Color(0xFF4A90E2);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F5F5), Color(0xFFE8E8E8)],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _GridPainter())),
            Positioned(
              bottom: 60, left: 0, right: 0,
              child: AnimatedBuilder(
                animation: _glowCtrl,
                builder: (_, __) {
                  final w = 40.0 + _glowCtrl.value * 80.0;
                  final opacity = 0.3 + _glowCtrl.value * 0.7;
                  return Center(
                    child: Container(
                      width: w, height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.transparent,
                          blue.withAlpha((opacity * 255).toInt()),
                          Colors.transparent,
                        ]),
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildIconArea(child: _minimalistIconDecor(blue)),
                  const SizedBox(height: 40),
                  _buildAppName(
                    jaColor: const Color(0xFF1A1A1A),
                    enColor: const Color(0xFF666666),
                    enText: widget.appSubtitle ?? 'POWERED BY AI',
                    fontSize: 26,
                  ),
                  const SizedBox(height: 20),
                  FadeTransition(opacity: _waveOpacity, child: _buildSoundwave(blue)),
                  const SizedBox(height: 16),
                  FadeTransition(opacity: _dotOpacity, child: _minimalistStatus(blue)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _minimalistIconDecor(Color blue) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _glowCtrl,
          builder: (_, __) => Transform.rotate(
            angle: _glowCtrl.value * 2 * pi,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: blue.withAlpha(51), width: 1),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.translate(
                    offset: const Offset(0, -100),
                    child: Container(
                      width: 4, height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, color: blue,
                        boxShadow: [BoxShadow(color: blue.withAlpha(153), blurRadius: 6)],
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
            child: Image.asset(widget.iconPath, width: 140, height: 140, fit: BoxFit.cover),
          ),
        ),
        AnimatedBuilder(
          animation: _glowCtrl,
          builder: (_, __) {
            final scale = 1.0 + _glowCtrl.value * 0.3;
            return Transform.scale(
              scale: scale,
              child: Container(
                width: 8, height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, color: blue,
                  boxShadow: [BoxShadow(color: blue.withAlpha(128), blurRadius: 12)],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _minimalistStatus(Color blue) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _glowCtrl,
          builder: (_, __) => Container(
            width: 5, height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: blue.withAlpha(((0.3 + _glowCtrl.value * 0.7) * 255).toInt()),
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

  // ============================================================
  // テーマ4: Pop
  // ============================================================
  Widget _buildPop(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _glowCtrl,
        builder: (_, child) {
          final t = _glowCtrl.value;
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
        child: Stack(
          children: [
            Positioned(top: -100, left: -100, child: _popShape(300)),
            Positioned(bottom: -80, right: -80, child: _popShape(250)),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              right: MediaQuery.of(context).size.width * 0.1,
              child: _popShape(150),
            ),
            Positioned.fill(child: ParticleField(count: 25, color: Colors.white.withAlpha(179))),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildIconArea(child: _popIconDecor()),
                  const SizedBox(height: 24),
                  _buildAppName(
                    jaColor: Colors.white,
                    enColor: Colors.white.withAlpha(230),
                    enText: widget.appSubtitle ?? 'POWERED BY AI',
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: _waveOpacity,
                    child: _buildSoundwave(Colors.white, gap: 6, barWidth: 5),
                  ),
                  const SizedBox(height: 16),
                  FadeTransition(opacity: _dotOpacity, child: _popFunText()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _popIconDecor() {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _glowCtrl,
          builder: (_, __) => Opacity(
            opacity: (1 - _glowCtrl.value).clamp(0, 1),
            child: Transform.scale(
              scale: 1.0 + _glowCtrl.value * 0.8,
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
          animation: _jumpCtrl,
          builder: (_, child) => Transform.rotate(
            angle: _jumpCtrl.value * 2 * pi,
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
          animation: _jumpCtrl,
          builder: (_, child) {
            final dy = -sin(_jumpCtrl.value * pi) * 20;
            final scale = 1.0 + sin(_jumpCtrl.value * pi) * 0.05;
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
              child: Image.asset(widget.iconPath, width: 160, height: 160, fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }

  Widget _popShape(double size) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [Colors.white.withAlpha(38), Colors.transparent]),
      ),
    );
  }

  Widget _popFunText() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _jumpCtrl,
          builder: (_, child) => Transform.rotate(
            angle: sin(_jumpCtrl.value * 2 * pi) * 0.175,
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
          animation: _jumpCtrl,
          builder: (_, child) => Transform.rotate(
            angle: -sin(_jumpCtrl.value * 2 * pi) * 0.175,
            child: child,
          ),
          child: const Text('🎵', style: TextStyle(fontSize: 24)),
        ),
      ],
    );
  }

  // ============================================================
  // 共通ウィジェット
  // ============================================================

  Widget _buildIconArea({required Widget child}) {
    return AnimatedBuilder(
      animation: _iconCtrl,
      builder: (_, __) => Opacity(
        opacity: _iconOpacity.value,
        child: Transform.scale(scale: _iconScale.value, child: child),
      ),
    );
  }

  Widget _buildAppName({
    required Color jaColor,
    required Color enColor,
    required String enText,
    double fontSize = 30,
    FontWeight fontWeight = FontWeight.w800,
    bool isMono = false,
  }) {
    return FadeTransition(
      opacity: _nameOpacity,
      child: SlideTransition(
        position: _nameSlide,
        child: Column(
          children: [
            Text(
              widget.appName,
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

  Widget _buildSoundwave(Color color, {Color? glowColor, double gap = 4, double barWidth = 4}) {
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

  Widget _buildBounceDots(Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.5),
        child: BounceDot(color: color, delay: i * 0.22),
      )),
    );
  }
}

// ============================================================
// グリッド背景（Minimalist用）
// ============================================================
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
