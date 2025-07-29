// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:html' as html;
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import '../flutter_cached_svg.dart';

State<FlutterCachedSvg> createFlutterCachedSvgState() {
  return _FlutterCachedSvgWebState();
}

Future<void> preCacheImplementation(
  String imageUrl,
  String key,
  BaseCacheManager cacheManager,
) async {
  try {
    final svgData = await _fetchSvgData(imageUrl);
    html.window.localStorage[key] = svgData;
  } catch (e) {
    log('PreCache failed: $e');
  }
}

Future<void> clearCacheForUrlImplementation(
  String imageUrl,
  String key,
  BaseCacheManager cacheManager,
) async {
  html.window.localStorage.remove(key);
}

Future<void> clearCacheImplementation(BaseCacheManager cacheManager) async {
  final keys = html.window.localStorage.keys.toList();
  for (final key in keys) {
    if (key.startsWith('http') &&
        (key.contains('.svg') || key.contains('svg'))) {
      html.window.localStorage.remove(key);
    }
  }
}

Future<String> _fetchSvgData(String url, {Map<String, String>? headers}) async {
  try {
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body;
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  } catch (e) {
    throw Exception('Failed to fetch SVG: $e');
  }
}

class _FlutterCachedSvgWebState extends State<FlutterCachedSvg>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  bool _isError = false;
  String? _svgData;
  late String _cacheKey;

  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _cacheKey =
        widget.cacheKey ?? FlutterCachedSvg.generateKeyFromUrl(widget.url);
    _controller = AnimationController(
      vsync: this,
      duration: widget.fadeDuration,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      _setToLoadingAfter15MsIfNeeded();

      // Check first the localStorage cache
      String? cachedData = html.window.localStorage[_cacheKey];

      if (cachedData != null && cachedData.isNotEmpty) {
        _svgData = cachedData;
      } else {
        // Download from the network
        _svgData = await _fetchSvgData(widget.url, headers: widget.headers);
        // Cache
        if (_svgData != null && _svgData!.isNotEmpty) {
          html.window.localStorage[_cacheKey] = _svgData!;
        }
      }

      if (mounted) {
        _isLoading = false;
        _setState();
        _controller.forward();
      }
    } catch (e) {
      log('FlutterCachedSvg Web: $e');
      if (mounted) {
        _isError = true;
        _isLoading = false;
        _setState();
      }
    }
  }

  void _setToLoadingAfter15MsIfNeeded() =>
      Future.delayed(const Duration(milliseconds: 15), () {
        if (mounted && !_isLoading && _svgData == null && !_isError) {
          _isLoading = true;
          _setState();
        }
      });

  void _setState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (_isLoading) return _buildPlaceholderWidget();
    if (_isError) return _buildErrorWidget();
    return FadeTransition(opacity: _animation, child: _buildSVGImage());
  }

  Widget _buildPlaceholderWidget() =>
      Center(child: widget.placeholder ?? const SizedBox());

  Widget _buildErrorWidget() =>
      Center(child: widget.errorWidget ?? const SizedBox());

  Widget _buildSVGImage() {
    if (_svgData == null || _svgData!.isEmpty) return const SizedBox();

    return SvgPicture.string(
      _svgData!,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      alignment: widget.alignment,
      matchTextDirection: widget.matchTextDirection,
      allowDrawingOutsideViewBox: widget.allowDrawingOutsideViewBox,
      semanticsLabel: widget.semanticsLabel,
      excludeFromSemantics: widget.excludeFromSemantics,
      colorFilter: widget.colorFilter,
      placeholderBuilder: widget.placeholderBuilder,
      theme: widget.theme,
    );
  }
}
