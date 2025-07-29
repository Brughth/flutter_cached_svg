library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'src/flutter_cached_svg_stub.dart'
    if (dart.library.io) 'src/flutter_cached_svg_io.dart'
    if (dart.library.html) 'src/flutter_cached_svg_web.dart';

class FlutterCachedSvg extends StatefulWidget {
  FlutterCachedSvg(
    String url, {
    Key? key,
    String? cacheKey,
    Widget? placeholder,
    Widget? errorWidget,
    double? width,
    double? height,
    Map<String, String>? headers,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool matchTextDirection = false,
    bool allowDrawingOutsideViewBox = false,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme theme = const SvgTheme(),
    Duration fadeDuration = const Duration(milliseconds: 300),
    ColorFilter? colorFilter,
    WidgetBuilder? placeholderBuilder,
    BaseCacheManager? cacheManager,
  }) : url = url,
       cacheKey = cacheKey,
       placeholder = placeholder,
       errorWidget = errorWidget,
       width = width,
       height = height,
       headers = headers,
       fit = fit,
       alignment = alignment,
       matchTextDirection = matchTextDirection,
       allowDrawingOutsideViewBox = allowDrawingOutsideViewBox,
       semanticsLabel = semanticsLabel,
       excludeFromSemantics = excludeFromSemantics,
       theme = theme,
       fadeDuration = fadeDuration,
       colorFilter = colorFilter,
       placeholderBuilder = placeholderBuilder,
       cacheManager = cacheManager ?? DefaultCacheManager(),
       super(key: key ?? ValueKey(url));

  final String url;
  final String? cacheKey;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double? width;
  final double? height;
  final Map<String, String>? headers;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final bool matchTextDirection;
  final bool allowDrawingOutsideViewBox;
  final String? semanticsLabel;
  final bool excludeFromSemantics;
  final SvgTheme theme;
  final Duration fadeDuration;
  final ColorFilter? colorFilter;
  final WidgetBuilder? placeholderBuilder;
  final BaseCacheManager cacheManager;

  @override
  // ignore: no_logic_in_create_state
  State<FlutterCachedSvg> createState() => createFlutterCachedSvgState();

  static Future<void> preCache(
    String imageUrl, {
    String? cacheKey,
    BaseCacheManager? cacheManager,
  }) {
    final key = cacheKey ?? generateKeyFromUrl(imageUrl);
    cacheManager ??= DefaultCacheManager();
    return preCacheImplementation(imageUrl, key, cacheManager);
  }

  static Future<void> clearCacheForUrl(
    String imageUrl, {
    String? cacheKey,
    BaseCacheManager? cacheManager,
  }) {
    final key = cacheKey ?? generateKeyFromUrl(imageUrl);
    cacheManager ??= DefaultCacheManager();
    return clearCacheForUrlImplementation(imageUrl, key, cacheManager);
  }

  static Future<void> clearCache({BaseCacheManager? cacheManager}) {
    cacheManager ??= DefaultCacheManager();
    return clearCacheImplementation(cacheManager);
  }

  static String generateKeyFromUrl(String url) => url.split('?').first;
}
