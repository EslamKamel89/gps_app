// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/widgets/inputs.dart';
import 'package:gps_app/features/wishlist/cubits/meal_items_cubit.dart';
import 'package:gps_app/features/wishlist/models/meal_item_model.dart';

class MealItemSelectorProvider extends StatelessWidget {
  const MealItemSelectorProvider({super.key, required this.onSelect, this.isRequired = true});
  final Function(MealItemModel) onSelect;
  final bool isRequired;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MealItemsCubit()..getMealItems(),
      child: MealItemSelectorWidget(onSelect, isRequired: isRequired),
    );
  }
}

class MealItemSelectorWidget extends StatefulWidget {
  const MealItemSelectorWidget(this.onSelect, {super.key, this.isRequired = true});
  final Function(MealItemModel) onSelect;
  final bool isRequired;

  @override
  State<MealItemSelectorWidget> createState() => _MealItemSelectorWidgetState();
}

class _MealItemSelectorWidgetState extends State<MealItemSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealItemsCubit, ApiResponseModel<List<MealItemModel>>>(
      builder: (context, state) {
        final cubit = context.read<MealItemsCubit>();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            state.response == ResponseEnum.loading
                ? Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat())
                    .shimmer(
                      duration: 1200.ms,
                      colors: [Colors.grey.shade300, Colors.grey.shade100, Colors.grey.shade300],
                    )
                : SearchableDropdownWidget(
                  label: 'Items',
                  hintText: 'Select Item',
                  isRequired: widget.isRequired,
                  options: state.data?.map((item) => item.name ?? '').toList() ?? [],
                  handleSelectOption: (String option) {
                    final item = cubit.selectItem(option);
                    widget.onSelect(item!);
                  },
                ),
          ],
        );
      },
    );
  }
}
