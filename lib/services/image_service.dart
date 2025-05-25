import 'package:flutter/foundation.dart';

class ImageService {
  // Améliorer l'URL d'image pour une meilleure qualité et compatibilité
  static String enhanceImageUrl(String originalUrl) {
    if (originalUrl.isEmpty) return '';

    String enhancedUrl = originalUrl;

    // Convertir HTTP en HTTPS pour éviter les problèmes de sécurité
    if (enhancedUrl.startsWith('http://')) {
      enhancedUrl = enhancedUrl.replaceFirst('http://', 'https://');
    }

    // Pour les images Google Books, essayer d'améliorer la qualité
    if (enhancedUrl.contains('books.google.com')) {
      // Remplacer les paramètres de taille pour une meilleure qualité
      enhancedUrl = enhancedUrl.replaceAll('&zoom=1', '&zoom=0');
      enhancedUrl = enhancedUrl.replaceAll('&edge=curl', '');
      
      // Ajouter des paramètres pour une meilleure qualité si pas déjà présents
      if (!enhancedUrl.contains('zoom=')) {
        enhancedUrl += '&zoom=0';
      }
      if (!enhancedUrl.contains('printsec=')) {
        enhancedUrl += '&printsec=frontcover';
      }
    }

    return enhancedUrl;
  }

  // Obtenir la meilleure URL d'image disponible depuis les imageLinks
  static String getBestImageUrl(Map<String, dynamic> imageLinks) {
    if (imageLinks.isEmpty) return '';

    // Ordre de préférence pour la qualité d'image
    const preferenceOrder = [
      'extraLarge',
      'large', 
      'medium',
      'thumbnail',
      'smallThumbnail',
      'small'
    ];

    for (String size in preferenceOrder) {
      if (imageLinks.containsKey(size) && imageLinks[size] != null) {
        String url = imageLinks[size].toString();
        if (url.isNotEmpty) {
          return enhanceImageUrl(url);
        }
      }
    }

    // Si aucune image trouvée dans l'ordre de préférence, prendre la première disponible
    for (String key in imageLinks.keys) {
      if (imageLinks[key] != null) {
        String url = imageLinks[key].toString();
        if (url.isNotEmpty) {
          return enhanceImageUrl(url);
        }
      }
    }

    return '';
  }

  // Vérifier si une URL d'image est valide
  static bool isValidImageUrl(String url) {
    if (url.isEmpty) return false;
    
    try {
      Uri.parse(url);
      return url.startsWith('http://') || url.startsWith('https://');
    } catch (e) {
      debugPrint('URL d\'image invalide: $url - Erreur: $e');
      return false;
    }
  }

  // Obtenir une URL d'image de fallback si nécessaire
  static String getFallbackImageUrl(String bookTitle) {
    // Pour l'instant, retourner une chaîne vide
    // Dans le futur, on pourrait utiliser un service comme Unsplash ou une image par défaut
    return '';
  }

  // Logger les informations d'image pour le debug
  static void logImageInfo(String bookTitle, Map<String, dynamic> imageLinks, String selectedUrl) {
    if (kDebugMode) {
      debugPrint('=== Image Info pour "$bookTitle" ===');
      debugPrint('ImageLinks disponibles: $imageLinks');
      debugPrint('URL sélectionnée: $selectedUrl');
      debugPrint('URL valide: ${isValidImageUrl(selectedUrl)}');
      debugPrint('=====================================');
    }
  }
}
