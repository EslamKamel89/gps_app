import 'package:gps_app/features/wishlist/entities/meal_entity.dart';

class AcceptorEntity {
  final String restaurantId;
  final String restaurantName;
  final double rating;
  final double distanceKm;
  final MealEntity meal;

  AcceptorEntity({
    required this.restaurantId,
    required this.restaurantName,
    required this.rating,
    required this.distanceKm,
    required this.meal,
  });
}
