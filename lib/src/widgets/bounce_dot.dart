import 'package:flutter/material.dart';

class BounceDot extends StatefulWidget {
  final Color color;
  final double delay;

  const BounceDot({super.key, required this.color, required this.delay});

  @override
  State<BounceDot> createState() => _BounceDotState();
}

class _BounceDotState extends State<BounceDot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _anim = Tween(begin: 0.55, end: 1.0).animate(
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
      builder: (_, __) => Opacity(
        opacity: 0.38 + _anim.value * 0.62,
        child: Transform.scale(
          scale: _anim.value,
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color),
          ),
        ),
      ),
    );
  }
}
