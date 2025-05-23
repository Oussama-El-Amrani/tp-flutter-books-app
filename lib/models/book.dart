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
    final volumeInfo = json['volumeInfo'] ?? {};
    final imageLinks = volumeInfo['imageLinks'] ?? {};
    
    return Book(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? 'Titre non disponible',
      author: (volumeInfo['authors'] as List<dynamic>?)?.join(', ') ?? 'Auteur inconnu',
      imageUrl: imageLinks['thumbnail'] ?? imageLinks['smallThumbnail'] ?? '',
    );
  }

  // Pour stocker dans SQLite (Map)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'imageUrl': imageUrl,
    };
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
