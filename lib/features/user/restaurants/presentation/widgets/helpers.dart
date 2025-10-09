import 'package:gps_app/core/api_service/end_points.dart';

// TEMP adapter target for MenuItemCard (kept)
class MenuItem {
  final String name;
  final String description;
  final double price;
  final bool isSpicy;
  final List<String> tags;

  const MenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.isSpicy,
    required this.tags,
  });
}

const String kMediaBaseUrl = EndPoint.baseUrl;

String resolveMediaUrl(String? path) {
  if (path == null || path.isEmpty) {
    return 'https://images.unsplash.com/photo-1550547660-d9450f859349?q=80&w=1600&auto=format&fit=crop';
  }
  if (path.startsWith('http')) return path;
  return kMediaBaseUrl.endsWith('/') ? '$kMediaBaseUrl$path' : '$kMediaBaseUrl/$path';
}

double parsePrice(String? s) {
  if (s == null) return 0.0;
  final v = double.tryParse(s.trim());
  return v ?? 0.0;
}
