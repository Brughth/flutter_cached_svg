import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_svg/flutter_cached_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Cached SVG Example',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ExampleHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({Key? key}) : super(key: key);

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  // URLs d'exemple d'images SVG
  static const List<String> svgUrls = [
    // SVG simples et géométriques
    'https://raw.githubusercontent.com/twitter/twemoji/master/assets/svg/1f60a.svg', // Emoji souriant
    'https://raw.githubusercontent.com/twitter/twemoji/master/assets/svg/2764.svg', // Coeur rouge
    'https://raw.githubusercontent.com/twitter/twemoji/master/assets/svg/1f31f.svg', // Étoile brillante
    'https://raw.githubusercontent.com/twitter/twemoji/master/assets/svg/1f44d.svg', // Pouce en l'air
    'https://raw.githubusercontent.com/twitter/twemoji/master/assets/svg/1f389.svg', // Confettis
    'https://raw.githubusercontent.com/twitter/twemoji/master/assets/svg/1f3c6.svg', // Trophée
    'https://raw.githubusercontent.com/twitter/twemoji/master/assets/svg/1f680.svg', // Fusée
    'https://raw.githubusercontent.com/twitter/twemoji/master/assets/svg/1f4a1.svg', // Ampoule

    // Icônes de logos via CDN (sans CORS)
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/github.svg',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/google.svg',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/microsoft.svg',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/apple.svg',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/amazon.svg',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/netflix.svg',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/spotify.svg',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/youtube.svg',

    // SVG techniques via JSDelivr
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/javascript.svg',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/python.svg',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/react.svg',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/flutter.svg',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/nodejs.svg',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/typescript.svg',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/docker.svg',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/kubernetes.svg',
    'https://heroicons.com/24/outline/heart.svg',
    'https://heroicons.com/24/outline/star.svg',
    'https://heroicons.com/24/outline/home.svg',
    'https://heroicons.com/24/outline/user.svg',
    'https://heroicons.com/24/outline/bell.svg',
    'https://heroicons.com/24/outline/gift.svg',
    'https://heroicons.com/24/outline/sun.svg',
    'https://heroicons.com/24/outline/moon.svg',
    'https://cdn.jsdelivr.net/npm/feather-icons@4.29.0/dist/icons/activity.svg',
    'https://cdn.jsdelivr.net/npm/feather-icons@4.29.0/dist/icons/calendar.svg',
    'https://cdn.jsdelivr.net/npm/feather-icons@4.29.0/dist/icons/camera.svg',
    'https://cdn.jsdelivr.net/npm/feather-icons@4.29.0/dist/icons/coffee.svg',
    'https://cdn.jsdelivr.net/npm/feather-icons@4.29.0/dist/icons/compass.svg',
    'https://cdn.jsdelivr.net/npm/feather-icons@4.29.0/dist/icons/download.svg',
    'https://cdn.jsdelivr.net/npm/feather-icons@4.29.0/dist/icons/globe.svg',
    'https://cdn.jsdelivr.net/npm/feather-icons@4.29.0/dist/icons/mail.svg',
    'https://raw.githubusercontent.com/twitter/twemoji/master/assets/svg/1f60a.svg', // 😊
    'https://raw.githubusercontent.com/twitter/twemoji/master/assets/svg/1f389.svg', // 🎉
    'https://raw.githubusercontent.com/twitter/twemoji/master/assets/svg/1f680.svg', // 🚀
    'https://raw.githubusercontent.com/twitter/twemoji/master/assets/svg/1f4a1.svg', // 💡

    // Simple Icons via JSDelivr (logos tech)
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/react.svg',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/flutter.svg',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/github.svg',
    'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/google.svg',
  ];

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Cached SVG Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _clearAllCache,
            tooltip: 'Clear All Cache',
          ),
        ],
      ),
      body: Column(
        children: [
          // Buttons section
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _preCacheImages,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.download),
                        label: Text(
                          _isLoading ? 'Caching...' : 'Pre-cache All',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _clearAllCache,
                        icon: const Icon(Icons.clear_all),
                        label: const Text('Clear Cache'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tip: Images are cached automatically when loaded. '
                  'Try scrolling, then clearing cache and scrolling again to see the difference!',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Grid section
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width < 800 ? 2 : 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: svgUrls.length,
              itemBuilder: (context, index) {
                return _buildSvgCard(svgUrls[index], index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AdvancedExamplesPage(),
            ),
          );
        },
        tooltip: 'Advanced Examples',
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget _buildSvgCard(String url, int index) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showImageDialog(url, index),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FlutterCachedSvg(
                  url,
                  placeholder:
                      const Center(child: CupertinoActivityIndicator()),
                  errorWidget: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 32),
                        SizedBox(height: 8),
                        Text(
                          'Failed to load',
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  width: 80,
                  height: 80,
                  fadeDuration: const Duration(milliseconds: 300),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'SVG ${index + 1}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageDialog(String url, int index) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 300, maxHeight: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SVG ${index + 1}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FlutterCachedSvg(
                  url,
                  placeholder: const Center(child: CircularProgressIndicator()),
                  errorWidget: const Center(
                    child: Icon(Icons.error, color: Colors.red, size: 48),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      await FlutterCachedSvg.clearCacheForUrl(url);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cache cleared for this image'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear Cache'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _preCacheImages() async {
    setState(() => _isLoading = true);

    try {
      for (String url in svgUrls) {
        await FlutterCachedSvg.preCache(url);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All images pre-cached successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error pre-caching: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _clearAllCache() async {
    try {
      await FlutterCachedSvg.clearCache();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All cache cleared!'),
            backgroundColor: Colors.orange,
          ),
        );
        // Force rebuild to reload images
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error clearing cache: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

// Advanced Examples Page
class AdvancedExamplesPage extends StatelessWidget {
  const AdvancedExamplesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExampleCard(
            'With Color Filter',
            FlutterCachedSvg(
              'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/flutter.svg',
              width: 60,
              height: 60,
              colorFilter:
                  const ColorFilter.mode(Colors.purple, BlendMode.srcIn),
              placeholder: const CircularProgressIndicator(),
            ),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            'Different Fit Modes',
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: FlutterCachedSvg(
                        'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/flutter.svg',
                        fit: BoxFit.contain,
                        placeholder: const CircularProgressIndicator(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Contain', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: FlutterCachedSvg(
                        'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/flutter.svg',
                        fit: BoxFit.cover,
                        placeholder: const CircularProgressIndicator(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Cover', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: FlutterCachedSvg(
                        'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/flutter.svg',
                        fit: BoxFit.fill,
                        placeholder: const CircularProgressIndicator(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Fill', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            'Custom Placeholder',
            FlutterCachedSvg(
              'https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/flutter.svg',
              width: 60,
              height: 60,
              placeholder: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            'Custom Error Widget',
            FlutterCachedSvg(
              'https://invalid-url.svg', // URL invalide pour démontrer l'erreur
              width: 60,
              height: 60,
              errorWidget: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, color: Colors.red),
                    Text(
                      'Failed',
                      style: TextStyle(fontSize: 10, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildExampleCard(
            'Slow Fade Animation',
            FlutterCachedSvg(
              'hhttps://cdn.jsdelivr.net/npm/simple-icons@v9/icons/flutter.svg',
              width: 60,
              height: 60,
              fadeDuration: const Duration(
                milliseconds: 1000,
              ), // Animation lente
              placeholder: const CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(String title, Widget child) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Center(child: child),
          ],
        ),
      ),
    );
  }
}
