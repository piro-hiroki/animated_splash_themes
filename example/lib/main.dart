import 'package:animated_splash_themes/animated_splash_themes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'animated_splash_themes example',
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        appName: 'My App',
        appSubtitle: 'POWERED BY AI',
        iconPath: 'assets/images/icon.png',
        theme: SplashStyle.random,
        nextScreen: _HomePage(),
      ),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  double _durationSeconds = 2.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('animated_splash_themes')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DurationSlider(
              value: _durationSeconds,
              onChanged: (v) => setState(() => _durationSeconds = v),
            ),
            const SizedBox(height: 16),
            ...SplashStyle.values
                .where((s) => s != SplashStyle.random)
                .map((style) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: ElevatedButton(
                        onPressed: () => _launch(context, style),
                        child: Text('Style: ${style.name}'),
                      ),
                    )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: OutlinedButton(
                onPressed: () => _launch(context, SplashStyle.random),
                child: const Text('Style: random'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launch(BuildContext context, SplashStyle style) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AnimatedSplashScreen(
        appName: 'My App',
        appSubtitle: style.name.toUpperCase(),
        iconPath: 'assets/images/icon.png',
        theme: style,
        duration: Duration(milliseconds: (_durationSeconds * 1000).round()),
        nextScreen: const _HomePage(),
      ),
    ));
  }
}

class _DurationSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _DurationSlider({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            '表示時間: ${value.toStringAsFixed(1)}s',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Slider(
            value: value,
            min: 1.0,
            max: 6.0,
            divisions: 10,
            label: '${value.toStringAsFixed(1)}s',
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
