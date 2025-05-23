# 📚 Books App - Application Flutter de Recherche de Livres

Une application Flutter moderne qui permet de rechercher des livres via l'API Google Books et de gérer une liste de favoris localement.

## ✨ Fonctionnalités

### 🔍 Recherche de Livres
- Recherche de livres en temps réel via l'API Google Books
- Affichage des résultats en grille avec images, titres et auteurs
- Gestion des états de chargement et d'erreur

### ❤️ Gestion des Favoris
- Ajout/suppression de livres en favoris avec un simple clic
- Stockage local persistant avec SQLite
- Synchronisation en temps réel des statuts favoris
- Page dédiée pour consulter et gérer les favoris

### 📱 Interface Utilisateur
- Design Material 3 moderne et responsive
- Navigation fluide entre les pages
- Grilles adaptatives pour différentes tailles d'écran
- Gestion intelligente des images avec fallback
- Messages de confirmation et notifications

## 🏗️ Architecture

```
lib/
├── models/
│   └── book.dart              # Modèle de données Book
├── services/
│   ├── api_service.dart       # Service API Google Books
│   └── db_service.dart        # Service base de données SQLite
├── pages/
│   ├── home_page.dart         # Page de recherche principale
│   ├── detail_page.dart       # Page de détails d'un livre
│   └── favorites_page.dart    # Page des livres favoris
└── main.dart                  # Point d'entrée de l'application
```

## 🛠️ Technologies Utilisées

- **Flutter** - Framework de développement mobile
- **Dart** - Langage de programmation
- **Google Books API** - API de recherche de livres
- **SQLite** - Base de données locale pour les favoris
- **Material 3** - Design system moderne

## 📦 Dépendances

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.2          # Appels API
  sqflite: ^2.4.1       # Base de données locale
  path: ^1.9.1          # Gestion des chemins
  cupertino_icons: ^1.0.8
```

## 🚀 Installation et Lancement

### Prérequis
- Flutter SDK (version 3.7.2 ou supérieure)
- Dart SDK
- Un émulateur Android/iOS ou un navigateur web

### Installation
1. Clonez le repository :
```bash
git clone <repository-url>
cd books
```

2. Installez les dépendances :
```bash
flutter pub get
```

3. Lancez l'application :
```bash
# Sur émulateur mobile
flutter run

# Sur navigateur web
flutter run -d chrome

# Sur serveur web local
flutter run -d web-server --web-port=8080
```

## 🧪 Tests

Exécutez les tests avec :
```bash
flutter test
```

## 📖 Utilisation

### Recherche de Livres
1. Ouvrez l'application
2. Tapez votre recherche dans la barre de recherche
3. Appuyez sur "Rechercher" ou Entrée
4. Parcourez les résultats en grille

### Gestion des Favoris
1. Cliquez sur l'icône ❤️ sur un livre pour l'ajouter aux favoris
2. L'icône devient rouge ❤️ quand le livre est en favori
3. Accédez à vos favoris via l'icône ❤️ dans la barre d'application
4. Supprimez un favori en cliquant sur l'icône 🗑️

### Navigation
- **Page d'accueil** : Recherche et découverte de livres
- **Page de détails** : Informations complètes sur un livre
- **Page favoris** : Gestion de votre collection personnelle

## 🔧 Configuration API

L'application utilise l'API Google Books publique :
- **URL de base** : `https://www.googleapis.com/books/v1/volumes`
- **Paramètres** : `?q={query}&maxResults=20`
- **Aucune clé API requise** pour l'utilisation basique

## 🎨 Captures d'écran

*[Ajoutez ici des captures d'écran de votre application]*

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :
1. Fork le projet
2. Créer une branche pour votre fonctionnalité
3. Commiter vos changements
4. Pousser vers la branche
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 🆘 Support

Si vous rencontrez des problèmes :
1. Vérifiez que Flutter est correctement installé : `flutter doctor`
2. Assurez-vous que les dépendances sont installées : `flutter pub get`
3. Consultez les logs pour les erreurs spécifiques

---

Développé avec ❤️ en Flutter
