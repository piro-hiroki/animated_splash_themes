import 'package:flutter/material.dart';

class WaveBar extends StatefulWidget {
  final double height;
  final double width;
  final Color color;
  final Color? glowColor;
  final double delay;

  const WaveBar({
    super.key,
    required this.height,
    required this.width,
    required this.color,
    this.glowColor,
    required this.delay,
  });

  @override
  State<WaveBar> createState() => _WaveBarState();
}

class _WaveBarState extends State<WaveBar> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300));
    _anim = Tween(begin: 0.28, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height * _anim.value,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.width / 2),
          boxShadow: widget.glowColor != null
              ? [BoxShadow(color: widget.glowColor!.withAlpha(204), blurRadius: 6)]
              : null,
        ),
      ),
    );
  }
}
