# animated_splash_themes

A Flutter package providing richly animated splash screens with 4 built-in themes.

## Themes

| Theme | Description |
|-------|-------------|
| `teal` | Teal gradient with floating particles and glow effects |
| `midnight` | Dark neon with cyan glow, corner brackets, and scan lines |
| `minimalist` | Light gray with grid background and orbital animation |
| `pop` | Colorful gradient with jumping icon and rotating ring |
| `random` | Randomly picks one of the above at runtime |

## Installation

```yaml
dependencies:
  animated_splash_themes: ^1.0.0
```

## Usage

```dart
import 'package:animated_splash_themes/animated_splash_themes.dart';

MaterialApp(
  home: AnimatedSplashScreen(
    appName: 'My App',
    appSubtitle: 'POWERED BY AI',        // optional
    iconPath: 'assets/images/icon.png',
    theme: SplashTheme.random,
    nextScreen: const HomePage(),
  ),
)
```

### Specific theme

```dart
AnimatedSplashScreen(
  appName: 'My App',
  iconPath: 'assets/images/icon.png',
  theme: SplashTheme.midnight,
  nextScreen: const HomePage(),
)
```

### Custom duration

```dart
AnimatedSplashScreen(
  appName: 'My App',
  iconPath: 'assets/images/icon.png',
  theme: SplashTheme.teal,
  duration: const Duration(milliseconds: 3000),
  transitionDuration: const Duration(milliseconds: 800),
  nextScreen: const HomePage(),
)
```

## Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `appName` | `String` | ✓ | — | Main app name displayed on splash |
| `appSubtitle` | `String?` | | `'POWERED BY AI'` | Subtitle text below app name |
| `iconPath` | `String` | ✓ | — | Asset path to the app icon |
| `nextScreen` | `Widget` | ✓ | — | Screen to navigate to after splash |
| `theme` | `SplashTheme` | | `SplashTheme.random` | Which theme to display |
| `duration` | `Duration` | | `2650ms` | How long to show the splash |
| `transitionDuration` | `Duration` | | `1200ms` | Fade transition to next screen |

## Notes

- The icon image should be square (recommended: 160×160 or larger)
- Status bar style is automatically managed per theme (Midnight uses light icons)
- All animations are pure Flutter — no native dependencies required
