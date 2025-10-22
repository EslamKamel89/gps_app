import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/models/user_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/design/widgets/gps_bottom_nav.dart';
import 'package:gps_app/features/wishlist/models/acceptor_model.dart';
import 'package:gps_app/features/wishlist/models/item_model.dart';
import 'package:gps_app/features/wishlist/models/wish_model.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/wish_card.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> with TickerProviderStateMixin {
  final String _userName = 'Eslam';
  final String _userRank = 'Eco Explorer • Lv 3';

  late final List<WishModel> _wishes = [
    WishModel(
      id: 1,
      description: 'I love vegan pizza',
      status: 1,
      acceptors: [
        AcceptorModel(
          id: 1,
          user: UserModel(userName: 'True Acre'),
          // rating: 4.6,
          // distanceKm: 1.2,
          item: ItemModel(
            name: 'Margherita Verde',
            description: 'Cashew mozzarella, fresh basil, heirloom tomatoes',
            price: "9.50",
          ),
        ),
        AcceptorModel(
          id: 3,
          user: UserModel(userName: 'Green Bites'),
          // rating: 4.2,
          // distanceKm: 2.4,
          item: ItemModel(
            name: 'Forest Pesto Pizza',
            description: 'Kale pesto, artichoke hearts, olives',
            price: "10.90",
          ),
        ),
        AcceptorModel(
          id: 4,
          user: UserModel(userName: 'Vegano+'),
          // rating: 4.8,
          // distanceKm: 3.1,
          item: ItemModel(
            name: 'Truffle Funghi Flatbread',
            description: 'Roasted mushrooms, rocket, truffle drizzle',
            price: "12.40",
          ),
        ),
      ],
    ),
    WishModel(
      id: 5,
      description: 'Looking for gluten-free falafel wrap',
      status: 0,
      acceptors: const [],
    ),
    WishModel(
      id: 6,
      description: 'Cold-pressed green juice nearby',
      status: 1,
      acceptors: [
        AcceptorModel(
          id: 7,
          user: UserModel(userName: 'Leaf & Loom'),
          // rating: 4.4,
          // distanceKm: 0.8,
          item: ItemModel(
            name: 'Morning Greens',
            description: 'Kale, spinach, cucumber, apple, ginger',
            price: "5.90",
          ),
        ),
      ],
    ),
  ];

  final Set<int> _expanded = {};
  int _currentTab = 3;
  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: GPSColors.background,
      appBar: AppBar(
        backgroundColor: GPSColors.background,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 12,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: GPSColors.primary.withOpacity(.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: GPSColors.cardBorder),
              ),
              child: const Icon(Icons.local_florist_rounded, color: GPSColors.primary, size: 22),
            ).animate().fadeIn(duration: 280.ms).scale(begin: const Offset(.9, .9)),
            GPSGaps.w12,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userName,
                  style: txt.titleMedium?.copyWith(
                    color: GPSColors.text,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  _userRank,
                  style: txt.labelMedium?.copyWith(color: GPSColors.mutedText, height: 1.2),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, color: GPSColors.text),
          ).animate().fadeIn(),
          GPSGaps.w8,
        ],
      ),

      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: _wishes.length,
          separatorBuilder: (_, __) => GPSGaps.h12,
          itemBuilder: (context, index) {
            final wish = _wishes[index];
            final isExpanded = _expanded.contains(wish.id);
            return WishCard(
                  wish: wish,
                  expanded: isExpanded,
                  onToggleExpanded: () {
                    if (wish.id == null) return;
                    setState(() {
                      if (isExpanded) {
                        _expanded.remove(wish.id);
                      } else {
                        _expanded.add(wish.id!);
                      }
                    });
                  },
                  onViewRestaurant: (acceptor) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Open ${acceptor.user?.userName} details'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                )
                .animate(delay: (60 * index).ms)
                .fadeIn(duration: 280.ms, curve: Curves.easeOutCubic)
                .slideY(begin: .08, curve: Curves.easeOutCubic)
                .scale(begin: const Offset(.98, .98));
          },
        ),
      ),
      bottomNavigationBar: GPSBottomNav(
        currentIndex: _currentTab,
        onChanged: (i) {
          setState(() => _currentTab = i);
        },
      ),
    );
  }
}
