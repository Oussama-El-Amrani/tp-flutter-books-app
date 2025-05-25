class Book {
  final String id;
  final String title;
  final String author;
  final String imageUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
  });

  // Convertir un JSON (API) vers un objet Book
  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? <String, dynamic>{};
    final imageLinks = volumeInfo['imageLinks'] ?? <String, dynamic>{};
    final title = volumeInfo['title'] ?? 'Titre non disponible';

    // Convertir imageLinks en Map<String, dynamic> si nécessaire
    Map<String, dynamic> imageLinksMap;
    if (imageLinks is Map<String, dynamic>) {
      imageLinksMap = imageLinks;
    } else if (imageLinks is Map) {
      imageLinksMap = Map<String, dynamic>.from(imageLinks);
    } else {
      imageLinksMap = <String, dynamic>{};
    }

    // Utiliser le service d'images pour obtenir la meilleure URL
    final imageUrl = _getBestImageUrl(imageLinksMap);

    // Logger les informations pour le debug
    _logImageInfo(title, imageLinksMap, imageUrl);

    return Book(
      id: json['id'] ?? '',
      title: title,
      author:
          (volumeInfo['authors'] as List<dynamic>?)?.join(', ') ??
          'Auteur inconnu',
      imageUrl: imageUrl,
    );
  }

  // Méthode privée pour obtenir la meilleure URL d'image
  static String _getBestImageUrl(Map<String, dynamic> imageLinks) {
    if (imageLinks.isEmpty) return '';

    // Ordre de préférence pour la qualité d'image
    const preferenceOrder = [
      'extraLarge',
      'large',
      'medium',
      'thumbnail',
      'smallThumbnail',
      'small',
    ];

    for (String size in preferenceOrder) {
      if (imageLinks.containsKey(size) && imageLinks[size] != null) {
        String url = imageLinks[size].toString();
        if (url.isNotEmpty) {
          return _enhanceImageUrl(url);
        }
      }
    }

    return '';
  }

  // Méthode privée pour améliorer l'URL d'image
  static String _enhanceImageUrl(String originalUrl) {
    if (originalUrl.isEmpty) return '';

    String enhancedUrl = originalUrl;

    // Convertir HTTP en HTTPS
    if (enhancedUrl.startsWith('http://')) {
      enhancedUrl = enhancedUrl.replaceFirst('http://', 'https://');
    }

    // Améliorer la qualité pour les images Google Books
    if (enhancedUrl.contains('books.google.com')) {
      // Utiliser une approche différente pour éviter les problèmes CORS
      enhancedUrl = enhancedUrl.replaceAll('&zoom=1', '&zoom=1');
      enhancedUrl = enhancedUrl.replaceAll('&edge=curl', '');

      // Essayer d'utiliser l'URL directe des images
      if (enhancedUrl.contains('/books/content?')) {
        // Remplacer par l'URL publique des couvertures
        final idMatch = RegExp(r'id=([^&]+)').firstMatch(enhancedUrl);
        if (idMatch != null) {
          final bookId = idMatch.group(1);
          // Utiliser l'URL publique des couvertures Google Books
          enhancedUrl =
              'https://books.google.com/books/publisher/content/images/frontcover/$bookId?fife=w400-h600&source=gbs_api';
        }
      }

      // Fallback: garder l'URL originale avec des paramètres optimisés
      if (!enhancedUrl.contains('zoom=')) {
        enhancedUrl += '&zoom=1';
      }
      if (!enhancedUrl.contains('fife=')) {
        enhancedUrl += '&fife=w400-h600';
      }
    }

    return enhancedUrl;
  }

  // Méthode privée pour logger les informations d'image
  static void _logImageInfo(
    String title,
    Map<String, dynamic> imageLinks,
    String selectedUrl,
  ) {
    print('=== Image Info pour "$title" ===');
    if (imageLinks.isNotEmpty) {
      print('ImageLinks disponibles: ${imageLinks.keys.join(', ')}');
      print('URL sélectionnée: $selectedUrl');
    } else {
      print('Aucune image disponible');
    }
    print('=====================================');
  }

  // Pour stocker dans SQLite (Map)
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'author': author, 'imageUrl': imageUrl};
  }

  // Pour créer un Book à partir d'un Map SQLite
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Book && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Book{id: $id, title: $title, author: $author, imageUrl: $imageUrl}';
  }
}
