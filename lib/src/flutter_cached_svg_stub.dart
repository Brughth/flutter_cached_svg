import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../flutter_cached_svg.dart';

State<FlutterCachedSvg> createFlutterCachedSvgState() {
  throw UnsupportedError(
    'Cannot create FlutterCachedSvg state without dart specific libraries',
  );
}

Future<void> preCacheImplementation(
  String imageUrl,
  String key,
  BaseCacheManager cacheManager,
) {
  throw UnsupportedError('Cannot preCache without dart specific libraries');
}

Future<void> clearCacheForUrlImplementation(
  String imageUrl,
  String key,
  BaseCacheManager cacheManager,
) {
  throw UnsupportedError(
    'Cannot clearCacheForUrl without dart specific libraries',
  );
}

Future<void> clearCacheImplementation(BaseCacheManager cacheManager) {
  throw UnsupportedError('Cannot clearCache without dart specific libraries');
}
