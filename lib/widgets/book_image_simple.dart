import 'package:flutter/material.dart';

class BookImageSimple extends StatelessWidget {
  final String imageUrl;
  final String bookTitle;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  const BookImageSimple({
    super.key,
    required this.imageUrl,
    required this.bookTitle,
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: Colors.grey[200],
      ),
      child: imageUrl.isNotEmpty
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
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  // Log l'erreur pour le debug (seulement en mode debug)
                  debugPrint('Image failed for "$bookTitle": ${error.toString().substring(0, 100)}...');
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
          Icon(
            isError ? Icons.broken_image : Icons.book,
            size: _getIconSize(),
            color: Colors.grey[600],
          ),
          const SizedBox(height: 4),
          Text(
            isError ? 'Image\nindisponible' : 'Pas d\'image',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: _getTextSize(),
              color: Colors.grey[600],
            ),
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
