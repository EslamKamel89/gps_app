import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/cache/local_storage.dart';
import 'package:gps_app/core/helpers/snackbar.dart';
import 'package:gps_app/core/helpers/user.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/click_dropdown.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/round_icon.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/user_profile_tile.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/restaurant_detail_provider.dart';
import 'package:gps_app/features/user/store_details/presentation/store_details_screen.dart';
import 'package:gps_app/features/user/user_details/presentation/user_details_screen.dart';
import 'package:gps_app/utils/assets/assets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key, this.title = 'GPS'});
  final String title;

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          decoration: const BoxDecoration(
            color: GPSColors.primary,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          child: Row(
            children: [
              RoundIcon(icon: Icons.menu_rounded, onTap: () {}),
              GPSGaps.w12,
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AssetsData.logo3d, width: 30, height: 30),
                    GPSGaps.w4,
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .4,
                      ),
                    ),
                  ],
                ),
              ),
              GPSGaps.w12,

              ClickDropdown(
                child: RoundIcon(icon: Icons.person_outline),
                offset: Offset(-200, 0),
                children: [
                  UserProfileTile(
                    name: userInMemory()?.userName ?? '',
                    email: userInMemory()?.email ?? '',
                    avatarUrl:
                        "${EndPoint.baseUrl}/${userInMemory()?.image?.path}",
                  ),
                  MenuActionItem(
                    icon: MdiIcons.food,
                    label: 'Edit Food Preferences',
                    onTap: () {
                      Future.delayed(100.ms, () {
                        Navigator.of(
                          context,
                        ).pushNamed(AppRoutesNames.categorySelectionScreen);
                      });
                    },
                  ),
                  const Divider(height: 8, thickness: 0.7),
                  MenuActionItem(
                    icon: Icons.person_rounded,
                    label: 'View Profile',
                    onTap: () {
                      String? type = userInMemory()?.userType?.type;
                      if (type == 'restaurant') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (_) => RestaurantDetailProvider(
                                  restaurantId:
                                      userInMemory()?.restaurant?.id ?? 1,
                                  enableEdit: false,
                                  enableCompleteProfile: true,
                                ),
                          ),
                        );
                      } else if (type == 'store' || type == 'farm') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (_) => StoreDetailsScreen(
                                  publicPage: false,
                                  enableEdit: false,
                                  enableCompleteProfile: true,
                                ),
                          ),
                        );
                      } else if (type == 'user') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (_) => UserDetailsScreen(
                                  enableEdit: false,
                                  enableCompleteProfile: true,
                                ),
                          ),
                        );
                      } else {
                        showSnackbar(
                          'Sorry',
                          'the profile feature is not implemented for $type yet',
                          true,
                        );
                      }
                    },
                  ),
                  MenuActionItem(
                    icon: MdiIcons.pen,
                    label: 'Edit Profile',
                    onTap: () {
                      String? type = userInMemory()?.userType?.type;
                      if (type == 'restaurant') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (_) => RestaurantDetailProvider(
                                  restaurantId:
                                      userInMemory()?.restaurant?.id ?? 1,
                                  enableEdit: true,
                                  enableCompleteProfile: true,
                                ),
                          ),
                        );
                      } else if (type == 'farm' || type == 'store') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (_) => StoreDetailsScreen(
                                  publicPage: false,
                                  enableEdit: true,
                                  enableCompleteProfile: true,
                                ),
                          ),
                        );
                      } else if (type == 'user') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (_) => UserDetailsScreen(
                                  enableEdit: true,
                                  enableCompleteProfile: true,
                                ),
                          ),
                        );
                      } else {
                        showSnackbar(
                          'Sorry',
                          'the profile feature is not implemented for $type yet',
                          true,
                        );
                      }
                    },
                  ),

                  const Divider(height: 8, thickness: 0.7),
                  MenuActionItem(
                    icon: Icons.logout_rounded,
                    label: 'Sign Out',
                    danger: true,
                    onTap: () {
                      signout();
                    },
                  ),
                ],
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 280.ms)
        .slideY(begin: -.2, curve: Curves.easeOut);
  }

  Future signout() async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          surfaceTintColor: Colors.green,
          icon: Icon(Icons.warning, color: Colors.red, size: 35),

          backgroundColor: GPSColors.primary.withOpacity(0.8),
          title: Text("Log out? We'll be here when you get back"),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),

          actions: [
            TextButton(
              onPressed: () async {
                await serviceLocator<LocalStorage>().logout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutesNames.loginScreen,
                  (_) => false,
                );
              },
              child: Text(
                '👋 Yes, Logout!',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('❌ Cancel', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
