import 'package:flutter_test/flutter_test.dart';
import 'package:books/services/api_service.dart';
import 'package:books/models/book.dart';

void main() {
  group('ApiService Tests', () {
    test('searchBooks should return list of books for valid query', () async {
      // Test avec une recherche simple
      final books = await ApiService.searchBooks('flutter');

      expect(books, isA<List<Book>>());
      expect(books.isNotEmpty, true);

      // Vérifier que les livres ont les propriétés requises
      for (final book in books.take(3)) {
        expect(book.id, isNotEmpty);
        expect(book.title, isNotEmpty);
        expect(book.author, isNotEmpty);
        // imageUrl peut être vide pour certains livres
      }
    });

    test('searchBooks should return empty list for empty query', () async {
      final books = await ApiService.searchBooks('');
      expect(books, isEmpty);
    });

    test('getBookDetails should return book for valid ID', () async {
      // D'abord, obtenir un livre via la recherche
      final searchResults = await ApiService.searchBooks('flutter');
      expect(searchResults.isNotEmpty, true);

      final firstBook = searchResults.first;

      // Ensuite, obtenir les détails de ce livre
      final bookDetails = await ApiService.getBookDetails(firstBook.id);

      expect(bookDetails, isNotNull);
      expect(bookDetails!.id, equals(firstBook.id));
      expect(bookDetails.title, isNotEmpty);
    });

    test('getBookDetails should return null for invalid ID', () async {
      final bookDetails = await ApiService.getBookDetails('invalid_id_123');
      expect(bookDetails, isNull);
    });
  });

  group('Book Model Tests', () {
    test('Book.fromJson should parse Google Books API response correctly', () {
      final jsonData = {
        'id': 'test_id_123',
        'volumeInfo': {
          'title': 'Test Book Title',
          'authors': ['Author One', 'Author Two'],
          'imageLinks': {
            'thumbnail': 'https://example.com/thumbnail.jpg',
            'smallThumbnail': 'https://example.com/small.jpg',
          },
        },
      };

      final book = Book.fromJson(jsonData);

      expect(book.id, equals('test_id_123'));
      expect(book.title, equals('Test Book Title'));
      expect(book.author, equals('Author One, Author Two'));
      expect(book.imageUrl, equals('https://example.com/thumbnail.jpg'));
    });

    test('Book.fromJson should handle missing fields gracefully', () {
      final jsonData = <String, dynamic>{
        'id': 'test_id_456',
        'volumeInfo': <String, dynamic>{},
      };

      final book = Book.fromJson(jsonData);

      expect(book.id, equals('test_id_456'));
      expect(book.title, equals('Titre non disponible'));
      expect(book.author, equals('Auteur inconnu'));
      expect(book.imageUrl, equals(''));
    });

    test('Book toMap and fromMap should work correctly', () {
      final originalBook = Book(
        id: 'test_123',
        title: 'Test Title',
        author: 'Test Author',
        imageUrl: 'https://example.com/image.jpg',
      );

      final map = originalBook.toMap();
      final reconstructedBook = Book.fromMap(map);

      expect(reconstructedBook.id, equals(originalBook.id));
      expect(reconstructedBook.title, equals(originalBook.title));
      expect(reconstructedBook.author, equals(originalBook.author));
      expect(reconstructedBook.imageUrl, equals(originalBook.imageUrl));
    });

    test('Book equality should work correctly', () {
      final book1 = Book(
        id: 'same_id',
        title: 'Title 1',
        author: 'Author 1',
        imageUrl: 'url1',
      );

      final book2 = Book(
        id: 'same_id',
        title: 'Title 2',
        author: 'Author 2',
        imageUrl: 'url2',
      );

      final book3 = Book(
        id: 'different_id',
        title: 'Title 1',
        author: 'Author 1',
        imageUrl: 'url1',
      );

      expect(book1, equals(book2)); // Même ID
      expect(book1, isNot(equals(book3))); // ID différent
    });
  });
}
