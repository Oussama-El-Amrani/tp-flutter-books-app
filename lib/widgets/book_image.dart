import 'package:flutter/material.dart';

class BookImage extends StatefulWidget {
  final String imageUrl;
  final String bookTitle;
  final String? bookId;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  const BookImage({
    super.key,
    required this.imageUrl,
    required this.bookTitle,
    this.bookId,
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  @override
  State<BookImage> createState() => _BookImageState();
}

class _BookImageState extends State<BookImage> {
  int _currentUrlIndex = 0;
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    _generateImageUrls();
  }

  void _generateImageUrls() {
    _imageUrls = [];

    // URL principale
    if (widget.imageUrl.isNotEmpty) {
      _imageUrls.add(widget.imageUrl);
    }

    // URLs alternatives si on a l'ID du livre
    if (widget.bookId != null && widget.bookId!.isNotEmpty) {
      // Format direct Google Books
      _imageUrls.add(
        'https://books.google.com/books/publisher/content/images/frontcover/${widget.bookId}?fife=w400-h600&source=gbs_api',
      );

      // Format alternatif
      _imageUrls.add(
        'https://books.google.com/books/content?id=${widget.bookId}&printsec=frontcover&img=1&zoom=1&source=gbs_api',
      );

      // Format avec paramètres différents
      _imageUrls.add(
        'https://books.google.com/books/content?id=${widget.bookId}&printsec=frontcover&img=1&zoom=0&source=gbs_api',
      );
    }

    // Supprimer les doublons
    _imageUrls = _imageUrls.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: Colors.grey[200],
      ),
      child:
          imageUrl.isNotEmpty
              ? ClipRRect(
                borderRadius: borderRadius ?? BorderRadius.zero,
                child: Image.network(
                  imageUrl,
                  fit: fit,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    // Log l'erreur pour le debug
                    debugPrint(
                      'Erreur de chargement image pour "$bookTitle": $error',
                    );
                    return _buildPlaceholder(isError: true);
                  },
                ),
              )
              : _buildPlaceholder(isError: false),
    );
  }

  Widget _buildPlaceholder({required bool isError}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: Colors.grey[300],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book, size: _getIconSize(), color: Colors.grey[600]),
          const SizedBox(height: 4),
          Text(
            isError ? 'Image\nindisponible' : 'Pas d\'image',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: _getTextSize(), color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  double _getIconSize() {
    if (width != null && width! < 100) return 30;
    if (height != null && height! < 100) return 30;
    return 40;
  }

  double _getTextSize() {
    if (width != null && width! < 100) return 8;
    if (height != null && height! < 100) return 8;
    return 10;
  }
}
