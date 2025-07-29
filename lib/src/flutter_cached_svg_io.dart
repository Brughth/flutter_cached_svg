// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../flutter_cached_svg.dart';

State<FlutterCachedSvg> createFlutterCachedSvgState() {
  return _FlutterCachedSvgIOState();
}

Future<void> preCacheImplementation(
  String imageUrl,
  String key,
  BaseCacheManager cacheManager,
) {
  return cacheManager.downloadFile(imageUrl, key: key);
}

Future<void> clearCacheForUrlImplementation(
  String imageUrl,
  String key,
  BaseCacheManager cacheManager,
) {
  return cacheManager.removeFile(key);
}

Future<void> clearCacheImplementation(BaseCacheManager cacheManager) {
  return cacheManager.emptyCache();
}

class _FlutterCachedSvgIOState extends State<FlutterCachedSvg>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  bool _isError = false;
  File? _imageFile;
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

      var file = (await widget.cacheManager.getFileFromMemory(_cacheKey))?.file;

      file ??= await widget.cacheManager.getSingleFile(
        widget.url,
        key: _cacheKey,
        headers: widget.headers ?? {},
      );

      if (mounted) {
        _imageFile = file;
        _isLoading = false;
        _setState();
        _controller.forward();
      }
    } catch (e) {
      log('FlutterCachedSvg IO: $e');
      if (mounted) {
        _isError = true;
        _isLoading = false;
        _setState();
      }
    }
  }

  void _setToLoadingAfter15MsIfNeeded() =>
      Future.delayed(const Duration(milliseconds: 15), () {
        if (mounted && !_isLoading && _imageFile == null && !_isError) {
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
    if (_imageFile == null) return const SizedBox();

    return SvgPicture.file(
      _imageFile!,
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
