# Flutter Cached SVG Example

Cette application démontre l'utilisation du package `flutter_cached_svg` avec des exemples pratiques.

## Fonctionnalités démontrées

### Page principale :
- ✅ Chargement d'images SVG depuis des URLs
- ✅ Cache automatique des images
- ✅ Pré-cache manuel de toutes les images
- ✅ Nettoyage du cache
- ✅ Placeholder personnalisé avec CircularProgressIndicator
- ✅ Widget d'erreur personnalisé
- ✅ Animation de fade-in

### Page d'exemples avancés :
- ✅ Filtres de couleur (ColorFilter)
- ✅ Différents modes de fit (contain, cover, fill)
- ✅ Placeholder personnalisé avec design
- ✅ Widget d'erreur avec design personnalisé
- ✅ Animation de fade lente

## Comment tester

1. **Cache automatique** : Faites défiler la grille, les images se chargent et sont mises en cache
2. **Pré-cache** : Appuyez sur "Pre-cache All" pour télécharger toutes les images
3. **Nettoyage** : Appuyez sur "Clear Cache" puis refaites défiler pour voir la différence
4. **Exemples avancés** : Utilisez le bouton flottant pour voir plus d'options

## URLs d'exemple utilisées

Les URLs SVG proviennent de svgrepo.com et incluent des logos de technologies populaires comme React, Flutter, Node.js, etc.

## Compatibilité

- ✅ Android
- ✅ iOS  
- ✅ Web
- ✅ Desktop (Windows, macOS, Linux)

## API utilisée

```dart
// Usage basique
FlutterCachedSvg(
  'https://example.com/image.svg',
  width: 100,
  height: 100,
)

// Méthodes statiques
await FlutterCachedSvg.preCache(url);
await FlutterCachedSvg.clearCacheForUrl(url);
await FlutterCachedSvg.clearCache();