import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/wishlist/entities/acceptor_entity.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/acceptor_row.dart';

class AcceptorsList extends StatelessWidget {
  const AcceptorsList({super.key, required this.acceptors, required this.onViewRestaurant});

  final List<AcceptorEntity> acceptors;
  final void Function(AcceptorEntity acceptor) onViewRestaurant;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: acceptors.length,
      separatorBuilder: (_, __) => GPSGaps.h8,
      itemBuilder: (context, i) {
        final a = acceptors[i];
        return AcceptorRow(acceptor: a, onTap: () => onViewRestaurant(a))
            .animate(delay: (60 * i).ms)
            .fadeIn(duration: 240.ms, curve: Curves.easeOutCubic)
            .slideY(begin: .06, curve: Curves.easeOutCubic)
            .scale(begin: const Offset(.98, .98));
      },
    );
  }
}
