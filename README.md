# flutter_cached_svg

A high-performance Flutter package for loading and caching SVG images from network URLs with full cross-platform support, including **Flutter Web**.

[![pub package](https://img.shields.io/pub/v/flutter_cached_svg.svg)](https://pub.dev/packages/flutter_cached_svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.3.0+-blue.svg)](https://flutter.dev)

## ✨ Features

- 🚀 **Cross-platform support**: Works on Mobile, Desktop, and **Web**
- 📦 **Smart caching**: Automatic caching with customizable cache management
- 🎨 **Customizable**: Full control over placeholders, error widgets, and styling
- ⚡ **Performance**: Optimized loading with fade animations
- 🌐 **Web-first**: Built with Flutter Web compatibility in mind
- 🔧 **Easy to use**: Drop-in replacement for network SVG loading

## 🏗️ Platform Support

| Platform | Support | Implementation |
|----------|---------|----------------|
| Android  | ✅      | File-based caching via flutter_cache_manager |
| iOS      | ✅      | File-based caching via flutter_cache_manager |
| Web      | ✅      | localStorage caching with HTTP requests |
| Desktop  | ✅      | File-based caching via flutter_cache_manager |

## 📱 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_cached_svg: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

### Basic Usage

```dart
import 'package:flutter_cached_svg/flutter_cached_svg.dart';

FlutterCachedSvg(
  'https://example.com/image.svg',
  width: 100,
  height: 100,
)
```

### With Customization

```dart
FlutterCachedSvg(
  'https://example.com/image.svg',
  width: 200,
  height: 200,
  placeholder: const CircularProgressIndicator(),
  errorWidget: const Icon(Icons.error, color: Colors.red),
  colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
  fadeDuration: const Duration(milliseconds: 500),
)
```

### Cache Management

```dart
// Pre-cache an image
await FlutterCachedSvg.preCache('https://example.com/image.svg');

// Clear cache for specific URL
await FlutterCachedSvg.clearCacheForUrl('https://example.com/image.svg');

// Clear all cache
await FlutterCachedSvg.clearCache();
```

## 📖 API Reference

### FlutterCachedSvg

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `url` | `String` | The SVG image URL | Required |
| `width` | `double?` | Image width | `null` |
| `height` | `double?` | Image height | `null` |
| `placeholder` | `Widget?` | Widget shown while loading | `null` |
| `errorWidget` | `Widget?` | Widget shown on error | `null` |
| `colorFilter` | `ColorFilter?` | Color filter to apply | `null` |
| `fit` | `BoxFit` | How the image should fit | `BoxFit.contain` |
| `alignment` | `AlignmentGeometry` | Image alignment | `Alignment.center` |
| `fadeDuration` | `Duration` | Fade-in animation duration | `300ms` |
| `cacheKey` | `String?` | Custom cache key | Auto-generated |
| `headers` | `Map<String, String>?` | HTTP headers | `null` |
| `cacheManager` | `BaseCacheManager?` | Custom cache manager | `DefaultCacheManager()` |

### Static Methods

```dart
// Pre-cache an image
static Future<void> preCache(String imageUrl, {
  String? cacheKey,
  BaseCacheManager? cacheManager,
})

// Clear cache for specific URL
static Future<void> clearCacheForUrl(String imageUrl, {
  String? cacheKey, 
  BaseCacheManager? cacheManager,
})

// Clear all cache
static Future<void> clearCache({BaseCacheManager? cacheManager})
```

## 💡 Examples

### Loading with Custom Placeholder

```dart
FlutterCachedSvg(
  'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/flutter.svg',
  width: 80,
  height: 80,
  placeholder: Container(
    width: 80,
    height: 80,
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(Icons.image, color: Colors.grey),
  ),
)
```

### Applying Color Filters

```dart
FlutterCachedSvg(
  'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/github.svg',
  width: 50,
  height: 50,
  colorFilter: const ColorFilter.mode(
    Colors.blueAccent, 
    BlendMode.srcIn,
  ),
)
```

### Grid of Cached SVGs

```dart
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
  ),
  itemCount: svgUrls.length,
  itemBuilder: (context, index) {
    return FlutterCachedSvg(
      svgUrls[index],
      placeholder: const CircularProgressIndicator(),
      errorWidget: const Icon(Icons.broken_image),
    );
  },
)
```

### Pre-caching Multiple Images

```dart
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<String> svgUrls = [
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/react.svg',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/flutter.svg',
    // ... more URLs
  ];

  @override
  void initState() {
    super.initState();
    _preCacheImages();
  }

  Future<void> _preCacheImages() async {
    for (String url in svgUrls) {
      await FlutterCachedSvg.preCache(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Your app content
  }
}
```

## 🌐 Web-Specific Considerations

### CORS-Free SVG Sources

For Flutter Web, use CORS-enabled SVG sources:

```dart
// ✅ CORS-free sources
static const List<String> webFriendlySvgs = [
  'https://raw.githubusercontent.com/twitter/twemoji/master/assets/svg/1f60a.svg',
  'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/flutter.svg',
  'https://cdn.jsdelivr.net/npm/feather-icons@4.29.0/dist/icons/heart.svg',
];
```

### Web Caching

On web platforms, the package uses `localStorage` for caching instead of file system:

- Cache is persistent across browser sessions
- Automatically manages storage space
- Falls back gracefully if localStorage is unavailable

## 🔧 Advanced Configuration

### Custom Cache Manager

```dart
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

final customCacheManager = CacheManager(
  Config(
    'customSvgCache',
    stalePeriod: const Duration(days: 7),
    maxNrOfCacheObjects: 100,
  ),
);

FlutterCachedSvg(
  'https://example.com/image.svg',
  cacheManager: customCacheManager,
)
```

### Custom Headers

```dart
FlutterCachedSvg(
  'https://api.example.com/protected-svg',
  headers: {
    'Authorization': 'Bearer your-token',
    'User-Agent': 'MyApp/1.0',
  },
)
```

## 🎨 Styling Options

### Different Fit Modes

```dart
// Contain (default)
FlutterCachedSvg(url, fit: BoxFit.contain)

// Cover
FlutterCachedSvg(url, fit: BoxFit.cover)

// Fill
FlutterCachedSvg(url, fit: BoxFit.fill)

// Scale down
FlutterCachedSvg(url, fit: BoxFit.scaleDown)
```

### Alignment Options

```dart
FlutterCachedSvg(
  url,
  alignment: Alignment.topLeft,    // Top-left
  alignment: Alignment.center,     // Center (default)
  alignment: Alignment.bottomRight, // Bottom-right
)
```

## 🚨 Error Handling

```dart
FlutterCachedSvg(
  'https://invalid-url.svg',
  errorWidget: Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.red[100],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.red),
    ),
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.broken_image, color: Colors.red, size: 32),
        SizedBox(height: 8),
        Text('Failed to load SVG', style: TextStyle(color: Colors.red)),
      ],
    ),
  ),
)
```

## 🔍 Migration Guide

### From cached_network_svg_image

```dart


// After
FlutterCachedSvg(
  'https://example.com/image.svg',
  colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn), // ✅ New way
)
```

## 📊 Performance Tips

1. **Pre-cache important images** during app initialization
2. **Use appropriate image sizes** to reduce bandwidth
3. **Implement custom cache managers** for fine-tuned control
4. **Clear cache periodically** to manage storage space
5. **Use placeholders** to improve perceived performance

## 🐛 Troubleshooting

### Common Issues

**CORS errors on web:**
- Use CORS-enabled SVG sources (see Web-Specific Considerations)
- Consider hosting SVGs on your own CDN

**Images not caching:**
- Check if URLs are accessible
- Verify cache manager configuration
- Clear cache and retry

**Performance issues:**
- Reduce image sizes
- Implement lazy loading
- Use appropriate cache strategies

### Debug Mode

Enable logging to debug caching issues:

```dart
import 'dart:developer';

// The package automatically logs errors in debug mode
// Check your console for detailed error messages
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests for your changes
5. Ensure all tests pass (`flutter test`)
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built on top of [flutter_svg](https://pub.dev/packages/flutter_svg)
- Uses [flutter_cache_manager](https://pub.dev/packages/flutter_cache_manager) for mobile/desktop caching
- Inspired by the need for better SVG caching on Flutter Web

## 📞 Support

- 📧 Email: [your-email@example.com]
- 🐛 Issues: [GitHub Issues](https://github.com/yourusername/flutter_cached_svg/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/yourusername/flutter_cached_svg/discussions)

---

Made with ❤️ by [Your Name](https://github.com/yourusername)