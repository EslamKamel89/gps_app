import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/helpers/snackbar.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/wishlist/models/acceptor_model/acceptor_model.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/acceptor_row.dart';

class AcceptorsList extends StatelessWidget {
  const AcceptorsList({super.key, required this.acceptors});

  final List<AcceptorModel> acceptors;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: acceptors.length,
      separatorBuilder: (_, __) => GPSGaps.h8,
      itemBuilder: (context, i) {
        final a = acceptors[i];
        return AcceptorRow(
              acceptor: a,
              onTap: () {
                pr(a, 'acceptor');
                if ([a.userId, a.item?.id].contains(null)) {
                  showSnackbar(
                    'Error',
                    'Acceptor id or item id equals null',
                    true,
                  );
                  return;
                }
                Navigator.pushNamed(
                  context,
                  AppRoutesNames.itemInfoScreen,
                  arguments: {'acceptorId': a.userId, 'itemId': a.item?.id},
                );
              },
            )
            .animate(delay: (60 * i).ms)
            .fadeIn(duration: 240.ms, curve: Curves.easeOutCubic)
            .slideY(begin: .06, curve: Curves.easeOutCubic)
            .scale(begin: const Offset(.98, .98));
      },
    );
  }
}
