import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {
  static const String _baseUrl = 'https://www.googleapis.com/books/v1/volumes';

  // Rechercher des livres par mot-clé
  static Future<List<Book>> searchBooks(String query) async {
    if (query.isEmpty) return [];

    try {
      final url = Uri.parse('$_baseUrl?q=${Uri.encodeComponent(query)}&maxResults=20');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List<dynamic>? ?? [];
        
        return items.map((item) => Book.fromJson(item)).toList();
      } else {
        throw Exception('Erreur lors de la recherche: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Obtenir les détails d'un livre par ID
  static Future<Book?> getBookDetails(String bookId) async {
    try {
      final url = Uri.parse('$_baseUrl/$bookId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Book.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
