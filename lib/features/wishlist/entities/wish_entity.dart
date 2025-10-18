import 'package:gps_app/features/wishlist/entities/acceptor_entity.dart';
import 'package:gps_app/features/wishlist/presentation/wishlist_screen.dart';

class WishEntity {
  final String id;
  final String text;
  final WishStatus status;
  final DateTime createdAt;
  final List<AcceptorEntity> acceptors;

  WishEntity({
    required this.id,
    required this.text,
    required this.status,
    required this.createdAt,
    required this.acceptors,
  });

  bool get hasMatches => acceptors.isNotEmpty;
}
