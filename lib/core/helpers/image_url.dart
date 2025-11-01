import 'package:gps_app/core/api_service/end_points.dart';

String getImageUrl(String? path) {
  if (path == null) {
    return 'https://as1.ftcdn.net/v2/jpg/10/22/24/80/1000_F_1022248039_7LDxHRi3Mlt9BK3wzLBUGZp9XAO1gt2s.jpg';
  }
  if (path.contains('http')) return path;
  return "${EndPoint.baseUrl}/$path";
}
