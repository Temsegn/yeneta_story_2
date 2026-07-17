import 'package:flutter/material.dart';

/// Network image used for admin/demo content covers and thumbnails.
/// Matches demo look: rounded cover fill with a soft fallback tile.
class ContentNetworkImage extends StatelessWidget {
  const ContentNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String url;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) {
      return _fallback();
    }

    final image = Image.network(
      trimmed,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: const Color(0xFFE5E7EB),
          alignment: Alignment.center,
          child: const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (_, __, ___) => _fallback(),
    );

    if (borderRadius == null) return image;
    return ClipRRect(borderRadius: borderRadius!, child: image);
  }

  Widget _fallback() {
    return Container(
      color: const Color(0xFFDCFCE7),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_rounded,
        color: Color(0xFF16A34A),
        size: 36,
      ),
    );
  }
}
