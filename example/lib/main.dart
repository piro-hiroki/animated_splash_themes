import 'package:animated_splash_themes/animated_splash_themes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'animated_splash_themes example',
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        appName: 'My App',
        appSubtitle: 'POWERED BY AI',
        iconPath: 'assets/images/icon.png',
        theme: SplashTheme.random,
        nextScreen: const _HomePage(),
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: SplashTheme.values
              .where((t) => t != SplashTheme.random)
              .map((theme) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => AnimatedSplashScreen(
                            appName: 'My App',
                            appSubtitle: theme.name.toUpperCase(),
                            iconPath: 'assets/images/icon.png',
                            theme: theme,
                            nextScreen: const _HomePage(),
                          ),
                        ));
                      },
                      child: Text('Theme: ${theme.name}'),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
