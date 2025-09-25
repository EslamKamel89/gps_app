import 'package:flutter/material.dart';
import 'package:gps_app/features/auth/models/holiday_model.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

class HolidayMultiSelect extends StatefulWidget {
  const HolidayMultiSelect({
    super.key,
    required this.options,
    required this.onChanged,
    this.initialSelected = const [],
    this.hintText,
    this.emptyPlaceholder,
  });

  final List<HolidayModel> options;

  final ValueChanged<List<HolidayModel>> onChanged;

  final List<HolidayModel> initialSelected;

  final String? hintText;

  final Widget? emptyPlaceholder;

  @override
  State<HolidayMultiSelect> createState() => _HolidayMultiSelectState();
}

class _HolidayMultiSelectState extends State<HolidayMultiSelect> {
  final GlobalKey<FormFieldState<HolidayModel?>> _fieldKey = GlobalKey();
  List<HolidayModel> _selected = [];
  HolidayModel? _currentChoice;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant HolidayMultiSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    final availableKeys = widget.options.map(_identityKey).toSet();
    _selected =
        _selected
            .where((h) => availableKeys.contains(_identityKey(h)))
            .toList();
  }

  String _identityKey(HolidayModel h) =>
      (h.id != null)
          ? 'id:${h.id}'
          : 'composite:${h.name ?? ''}|${h.date?.toIso8601String() ?? ''}';

  void _add(HolidayModel? h) {
    if (h == null) return;
    if (_selected.where((holiday) => holiday.id == h.id).isNotEmpty) return;
    _selected.add(h);
    _currentChoice = null;
    widget.onChanged(_selected);
    setState(() {});
  }

  void _removeAt(int index) {
    setState(() {
      _selected.removeAt(index);
    });
    widget.onChanged(_selected);
  }

  List<String> _displayLabel(HolidayModel h) {
    final name = h.name ?? 'Unnamed';
    final dateStr =
        (h.date != null)
            ? _formatDate(h.date!)
            : (h.year != null ? h.year.toString() : '');
    return [name, dateStr].where((s) => s.isNotEmpty).toList();
  }

  String _formatDate(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(borderRadius: BorderRadius.circular(12));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: DropdownButton<HolidayModel?>(
            key: _fieldKey,
            value: _currentChoice,
            isDense: true,
            isExpanded: true,
            itemHeight: 80,
            onChanged: _add,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            // borderRadius: BorderRadius.circular(20),
            hint: Container(child: Text('Select a holiday to add')),

            // decoration: InputDecoration(
            //   hintText: 'Select a holiday to add',
            //   // helper: Container(
            //   //   padding: EdgeInsets.only(top: 15, left: 10),
            //   //   child: Text('Select a holiday to add'),
            //   // ),
            //   border: border,
            //   enabledBorder: border,
            //   focusedBorder: border.copyWith(
            //     borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            //   ),

            //   // contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            //   isDense: false,
            //   maintainHintHeight: true,
            // ),
            items:
                // available.map((h) {
                widget.options.map((h) {
                  return DropdownMenuItem<HolidayModel?>(
                    value: h,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 5),
                      margin: EdgeInsets.only(bottom: 5),
                      width: double.infinity,
                      // alignment: Alignment.center,
                      decoration: BoxDecoration(
                        // border: Border(bottom: BorderSide(color: Colors.grey)),
                        // color: Colors.red,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _displayLabel(h)[0],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _displayLabel(h)[1],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: GPSColors.mutedText),
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        if (_selected.isEmpty)
          widget.emptyPlaceholder ??
              Text(
                'No holidays selected yet.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (int i = 0; i < _selected.length; i++)
                InputChip(
                  label: Text(_displayLabel(_selected[i])[0]),
                  onDeleted: () => _removeAt(i),
                ),
            ],
          ),
      ],
    );
  }
}
