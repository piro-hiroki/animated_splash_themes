# Changelog

## 1.1.4

* Shorten `pubspec.yaml` description to fit pub.dev's recommended 60–180 char range
* Clarify that `iconPath` is optional (not unused) for `SplashStyle.expand`

## 1.1.3

* Update README installation snippet to reference the current version

## 1.1.2

* Shrink README preview GIFs to stay under pub.dev's package size limit

## 1.1.1

* Update README preview GIFs with higher-quality recordings

## 1.1.0

* Add `SplashStyle.expand` — X-style zoom-out of the app name (and optional icon) on launch
* Two-stage expand curve: subtle pre-scale followed by an `easeInExpo` burst for a Twitter-like feel
* `iconPath` is now optional (required only for styles other than `expand`)

## 1.0.2

* Add animated GIF previews for all splash styles to README

## 1.0.1

* Remove center dot from GridStyle icon decoration

## 1.0.0

* Initial release
* 4 built-in animated styles: Particles, Neon, Grid, Bounce
* Random style selection support
* Configurable app name, subtitle, icon path, duration, and navigation
* Custom background gradient colors via `backgroundColors`
* Custom accent color via `accentColor`
