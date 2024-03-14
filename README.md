## How to run

To run this locally, run:

```
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

We pass the `--disable-web-security` flag to Chrome as we're not able to
configure the `flutter run` web server to pass CORS headers for
`AssetManifest.json`, `FontManifest.json`, and other resources.
