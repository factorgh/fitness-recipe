import 'package:flutter/material.dart';

class WeekRangeSelector extends StatefulWidget {
  final void Function(List<String> selectedDays) onSelectionChanged;
  final List<String>? initialSelectedDays;

  const WeekRangeSelector({
    required this.onSelectionChanged,
    this.initialSelectedDays,
    super.key,
  });

  @override
  _WeekRangeSelectorState createState() => _WeekRangeSelectorState();
}

class _WeekRangeSelectorState extends State<WeekRangeSelector> {
  final List<String> _daysOfWeek = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];
  late List<String> _selectedDays;

  @override
  void initState() {
    super.initState();
    _selectedDays = widget.initialSelectedDays ?? [];
  }

  @override
  void didUpdateWidget(covariant WeekRangeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelectedDays != oldWidget.initialSelectedDays) {
      _selectedDays = widget.initialSelectedDays ?? [];
    }
  }

  void _onDayTap(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
      widget.onSelectionChanged(_selectedDays);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _daysOfWeek.map((day) {
          bool isSelected = _selectedDays.contains(day);
          return GestureDetector(
            onTap: () => _onDayTap(day),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: isSelected ? null : Border.all(color: Colors.grey),
              ),
              child: Text(
                day,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
