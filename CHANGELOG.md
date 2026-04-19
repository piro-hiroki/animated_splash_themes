# Changelog

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
