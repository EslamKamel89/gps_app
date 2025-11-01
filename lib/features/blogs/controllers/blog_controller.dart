import 'package:gps_app/core/api_service/api_consumer.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';

class BlogController {
  final _api = serviceLocator<ApiConsumer>();
}
