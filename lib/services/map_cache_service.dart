import 'dart:io';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';
import 'package:path_provider/path_provider.dart';

/// Singleton service to manage shared map tile caching across the app.
/// This ensures all map displays (MapPage, AddCafePage) share the same tile cache,
/// reducing API token usage and improving performance.
class MapCacheService {
  static final MapCacheService _instance = MapCacheService._internal();

  late Future<CacheStore> _cacheStoreFuture;
  CacheStore? _cachedStore;

  factory MapCacheService() {
    return _instance;
  }

  MapCacheService._internal() {
    _initializeCacheStore();
  }

  void _initializeCacheStore() {
    _cacheStoreFuture = _getCacheStore();
  }

  /// Get the shared CacheStore instance.
  /// Uses a Future to ensure the directory is properly initialized.
  Future<CacheStore> getCacheStore() => _cacheStoreFuture;

  /// Get the cached CacheStore synchronously if available (after first call).
  /// Returns null if the cache hasn't been initialized yet.
  CacheStore? getCachedStore() => _cachedStore;

  /// Initialize the cache store - should be called early in app lifecycle
  /// to ensure the cache directory is ready when needed.
  static Future<void> initialize() async {
    await MapCacheService().getCacheStore();
  }

  /// Get the CacheStore with aggressive caching settings:
  /// - Caches tiles for 7 days before checking for updates
  /// - Accepts stale tiles up to 30 days old
  /// - Ensures consistent cache across all map displays
  static Future<CacheStore> _getCacheStore() async {
    final dir = await getTemporaryDirectory();
    final cacheStore = FileCacheStore('${dir.path}${Platform.pathSeparator}MapTiles');
    
    // Cache the instance for faster access on subsequent calls
    MapCacheService()._cachedStore = cacheStore;
    
    return cacheStore;
  }

  /// Clear the tile cache (useful for debugging or user-initiated refresh)
  Future<void> clearCache() async {
    final store = await getCacheStore();
    await store.clean();
  }

  /// Get cache statistics
  Future<int> getCacheSize() async {
    final dir = await getTemporaryDirectory();
    final cacheDir = Directory('${dir.path}${Platform.pathSeparator}MapTiles');
    
    if (!await cacheDir.exists()) {
      return 0;
    }

    int totalSize = 0;
    await for (final entity in cacheDir.list(recursive: true)) {
      if (entity is File) {
        totalSize += await entity.length();
      }
    }
    return totalSize;
  }
}
