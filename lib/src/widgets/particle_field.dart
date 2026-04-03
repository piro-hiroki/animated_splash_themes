import 'dart:math';
import 'package:flutter/material.dart';

class ParticleField extends StatefulWidget {
  final int count;
  final Color color;

  const ParticleField({super.key, required this.count, required this.color});

  @override
  State<ParticleField> createState() => _ParticleFieldState();
}

class _ParticleFieldState extends State<ParticleField> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<_ParticleData> _particles;

  @override
  void initState() {
    super.initState();
    final rng = Random(42);
    _particles = List.generate(widget.count, (_) => _ParticleData(
      x: rng.nextDouble(),
      size: rng.nextDouble() * 6 + 2,
      speed: rng.nextDouble() * 0.04 + 0.02,
      phase: rng.nextDouble(),
    ));
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 15))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(
        painter: _ParticlePainter(_particles, _ctrl.value, widget.color),
      ),
    );
  }
}

class _ParticleData {
  final double x;
  final double size;
  final double speed;
  final double phase;

  const _ParticleData({
    required this.x,
    required this.size,
    required this.speed,
    required this.phase,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_ParticleData> particles;
  final double t;
  final Color color;

  const _ParticlePainter(this.particles, this.t, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final p in particles) {
      final progress = ((t * (15 * p.speed) + p.phase) % 1.0);
      final y = size.height * (1.0 - progress);
      final x = p.x * size.width;
      final opacity = progress < 0.08
          ? progress / 0.08 * 0.7
          : progress > 0.92
              ? (1 - progress) / 0.08 * 0.4
              : 0.4;
      paint.color = color.withAlpha((opacity * 255).clamp(0, 255).toInt());
      canvas.drawCircle(Offset(x, y), p.size / 2, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.t != t;
}
