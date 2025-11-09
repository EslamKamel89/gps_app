import 'package:flutter/material.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/favorites/controller/favorites_controller.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    super.key,
    required this.showFav,
    required this.id,
    required this.type,
  });
  final bool showFav;
  final int? id;
  final String type;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    if (!widget.showFav) return SizedBox();
    return IconButton(
      onPressed: () {
        if (_isPressed || widget.id == null) return;
        setState(() {
          _isPressed = true;
        });
        serviceLocator<FavoritesController>().addToFavorite(
          id: widget.id!,
          type: widget.type,
        );
      },
      icon: Icon(
        _isPressed ? Icons.favorite_rounded : Icons.favorite_outline,
        color: _isPressed ? Colors.redAccent : GPSColors.mutedText,
      ),
    );
  }
}
