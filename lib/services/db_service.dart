import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/book.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DbService {
  static const String _storageKey = 'books_favorites';
  static SharedPreferences? _prefs;

  // Initialiser SharedPreferences
  static Future<SharedPreferences> get _preferences async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Ajouter un livre aux favoris
  static Future<void> insertItem(Book book) async {
    try {
      final prefs = await _preferences;
      final favorites = await getItems();
      
      // Vérifier si le livre n'est pas déjà présent
      if (!favorites.any((b) => b.id == book.id)) {
        favorites.add(book);
        final jsonString = json.encode(favorites.map((book) => book.toMap()).toList());
        await prefs.setString(_storageKey, jsonString);
      }
    } catch (e) {
      debugPrint('Erreur lors de l\'ajout du favori: $e');
    }
  }

  // Récupérer tous les livres favoris
  static Future<List<Book>> getItems() async {
    try {
      final prefs = await _preferences;
      final jsonString = prefs.getString(_storageKey);
      
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => Book.fromMap(json)).toList();
      }
    } catch (e) {
      debugPrint('Erreur lors de la lecture des favoris: $e');
    }
    return [];
  }

  // Supprimer un livre des favoris
  static Future<void> deleteItem(String id) async {
    try {
      final prefs = await _preferences;
      final favorites = await getItems();
      
      favorites.removeWhere((book) => book.id == id);
      final jsonString = json.encode(favorites.map((book) => book.toMap()).toList());
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      debugPrint('Erreur lors de la suppression du favori: $e');
    }
  }

  // Vérifier si un livre est dans les favoris
  static Future<bool> isFavorite(String id) async {
    final items = await getItems();
    return items.any((book) => book.id == id);
  }

  // Obtenir le nombre de favoris
  static Future<int> getFavoritesCount() async {
    final items = await getItems();
    return items.length;
  }

  // Vider tous les favoris (utile pour les tests)
  static Future<void> clearAll() async {
    try {
      final prefs = await _preferences;
      await prefs.remove(_storageKey);
    } catch (e) {
      debugPrint('Erreur lors du vidage des favoris: $e');
    }
  }

  // Fermer/nettoyer les ressources (pour compatibilité)
  static Future<void> closeDatabase() async {
    // Rien à faire avec SharedPreferences
  }
}
