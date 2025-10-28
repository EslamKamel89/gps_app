import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/cache/local_storage.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/update_controller.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/core/widgets/uploads/uploaded_image.dart';
import 'package:gps_app/features/auth/models/catalog_section_model.dart';
import 'package:gps_app/features/auth/models/user_model.dart';
import 'package:gps_app/features/auth/presentation/widgets/state_district_selector.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/custom_stack.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/form_bottom_sheet.dart';
import 'package:gps_app/features/user/restaurant_details/presentation/widgets/restaurant_details_forms.dart';
import 'package:gps_app/features/user/store_details/presentation/widgets/circle_back.dart';
import 'package:gps_app/features/user/store_details/presentation/widgets/contact_card.dart';
import 'package:gps_app/features/user/store_details/presentation/widgets/state_city_card.dart';
import 'package:gps_app/features/user/store_details/presentation/widgets/store_details_skeleton.dart';
import 'package:gps_app/features/user/user_details/cubits/user_cubit.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({
    super.key,
    required this.enableEdit,
    required this.enableCompleteProfile,
  });

  final bool enableEdit;
  final bool enableCompleteProfile;
  @override
  State<UserDetailsScreen> createState() => UserDetailsScreenState();
}

class UserDetailsScreenState extends State<UserDetailsScreen> with SingleTickerProviderStateMixin {
  bool _isFav = false;
  bool _editNameLocation = false;
  String _imageUrl(UserModel? user) {
    final path = user?.image?.path;
    if (path == null) {
      return 'https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=1600&auto=format&fit=crop';
    }
    return "${EndPoint.baseUrl}/$path";
  }

  late UserCubit cubit;
  @override
  void initState() {
    cubit = context.read<UserCubit>()..user();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, ApiResponseModel<UserModel>>(
      listener: (context, state) {},
      builder: (context, state) {
        UserModel? user = state.data;

        List<CatalogSectionModel> sections = user?.sections() ?? [];

        String title = (user?.userName ?? user?.fullName) ?? 'User';
        return SafeArea(
          child: Scaffold(
            backgroundColor: GPSColors.background,
            body:
                state.response == ResponseEnum.loading
                    ? Padding(padding: EdgeInsets.all(10), child: StoreDetailsSkeleton())
                    : NestedScrollView(
                      headerSliverBuilder:
                          (context, innerScrolled) => [
                            SliverAppBar(
                              backgroundColor: GPSColors.background,
                              expandedHeight: 260,
                              pinned: true,
                              elevation: 0,
                              leading: CircleBack(onTap: () => Navigator.of(context).maybePop()),
                              actions: [
                                // IconButton(
                                //   tooltip: 'Share',
                                //   icon: const Icon(Icons.share_rounded, color: Colors.white),
                                //   onPressed: () {
                                //     // pr(widget.user.sections().length);
                                //   },
                                // ),
                              ],
                              flexibleSpace: FlexibleSpaceBar(
                                background: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    CustomStack(
                                      enableEdit: widget.enableEdit,
                                      actionWidget: EditButton(
                                        onPressed: () async {
                                          _updateUserImage(user: user!);
                                        },
                                      ),
                                      child: Image.network(
                                            _imageUrl(user),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          )
                                          .animate()
                                          .fadeIn(duration: 400.ms)
                                          .scale(
                                            begin: const Offset(1.02, 1.02),
                                            end: const Offset(1, 1),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SliverToBoxAdapter(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: GPSColors.background,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomStack(
                                        enableEdit: widget.enableEdit,
                                        actionWidget: EditButton(
                                          onPressed: () {
                                            setState(() {
                                              _editNameLocation = !_editNameLocation;
                                            });
                                          },
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: CustomStack(
                                                enableEdit: widget.enableEdit && _editNameLocation,
                                                actionWidget: EditButton(
                                                  onPressed: () async {
                                                    _updateUserName(user: user);
                                                  },
                                                ),
                                                child: Text(
                                                  title,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.headlineSmall?.copyWith(
                                                    color: GPSColors.text,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                            ),

                                            IconButton(
                                              tooltip:
                                                  _isFav
                                                      ? 'Remove from favorites'
                                                      : 'Add to favorites',
                                              onPressed: () => setState(() => _isFav = !_isFav),
                                              icon: Icon(
                                                _isFav
                                                    ? Icons.favorite_rounded
                                                    : Icons.favorite_outline,
                                                color:
                                                    _isFav ? Colors.redAccent : GPSColors.mutedText,
                                              ),
                                            ),
                                          ],
                                        ).animate().fadeIn(duration: 280.ms).slideY(begin: .1),
                                      ),

                                      if (user?.state != null && user?.district != null)
                                        GPSGaps.h16,
                                      if (user?.state != null && user?.district != null)
                                        CustomStack(
                                          enableEdit: widget.enableEdit,
                                          actionWidget: EditButton(
                                            onPressed: () async {
                                              _updateUserStateDistrict(user);
                                            },
                                          ),
                                          child: StateCityCard(
                                            state: (user?.state)!,
                                            district: (user?.district)!,
                                          ),
                                        ),
                                      GPSGaps.h10,
                                      ContactCard(user: user, enableEdit: widget.enableEdit),
                                      GPSGaps.h10,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                      body: SizedBox(),
                    ),
          ),
        );
      },
    );
  }

  Future _updateUserName({required UserModel? user}) async {
    final storage = serviceLocator<LocalStorage>();
    final String? newVal = await showFormBottomSheet<String>(
      context,
      builder:
          (ctx, ctl) => ProfileTextForm(
            initialValue: user?.userName,
            controller: ctl,
            label: 'Update your name',
          ),
    );
    if (newVal == null) return;
    cubit.state.data?.userName = newVal;
    cubit.update(cubit.state.data!);
    final res = await UpdateController.update(
      path: 'user/${user?.id}',
      data: {'user_name': newVal},
    );
    if (res.response == ResponseEnum.success) {
      storage.cacheUser(cubit.state.data);
    }
  }

  Future _updateUserStateDistrict(UserModel? user) async {
    final storage = serviceLocator<LocalStorage>();
    final SelectedStateAndDistrict? newVal = await showFormBottomSheet<SelectedStateAndDistrict>(
      context,
      builder: (ctx, ctl) => ProfileStateSelectionForm(controller: ctl),
    );
    if (newVal == null || newVal.selectedState == null || newVal.selectedDistrict == null) {
      return;
    }
    user?.state = newVal.selectedState;
    user?.district = newVal.selectedDistrict;
    cubit.update(cubit.state.data!);
    final res = await UpdateController.update(
      path: 'user/${user?.id}',
      data: {'state_id': newVal.selectedState?.id, 'district_id': newVal.selectedDistrict?.id},
    );
    if (res.response == ResponseEnum.success) {
      storage.cacheUser(cubit.state.data);
    }
  }

  Future _updateUserImage({required UserModel user}) async {
    final storage = serviceLocator<LocalStorage>();
    final UploadedImage? newVal = await showFormBottomSheet<UploadedImage>(
      context,
      builder: (ctx, ctl) => ProfileImageForm(controller: ctl, label: 'Update Your Image'),
    );
    if (newVal == null) return;
    user.image?.path = newVal.path;
    cubit.update(cubit.state.data!);
    final res = await UpdateController.update(
      path: 'user/${user.id}',
      data: {'image_id': newVal.id},
    );
    if (res.response == ResponseEnum.success) {
      storage.cacheUser(cubit.state.data);
    }
  }
}
