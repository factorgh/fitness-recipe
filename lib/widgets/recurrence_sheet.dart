// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

void showRecurrenceBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: true,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return const RecurrenceSelectionWidget();
    },
  );
}

class RecurrenceSelectionWidget extends StatefulWidget {
  const RecurrenceSelectionWidget({super.key});

  @override
  _RecurrenceSelectionWidgetState createState() =>
      _RecurrenceSelectionWidgetState();
}

class _RecurrenceSelectionWidgetState extends State<RecurrenceSelectionWidget> {
  String _selectedRecurrence = 'None';
  int _customDays = 1;
  final List<bool> _daysSelected =
      List.generate(7, (_) => false); // For specific days
  final List<String> _selectedMultipleWeekDays = [];

  final List<String> weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];
  final List<String> _weeks = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
  final List<String> recurrenceOptions = [
    'None',
    'Daily',
    'Weekly',
    'Bi-Weekly',
    'Monthly',
    'Custom',
    'Specific Days in Multiple Weeks',
    'Combined Recurrence',
    'Advanced Options'
  ];

  @override
  Widget build(BuildContext context) {
    print('Selected Recurrence: $_selectedRecurrence');
    print('Dropdown Items: $recurrenceOptions');

    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Select Meal Recurrence",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              // Recurrence Dropdown
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedRecurrence,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedRecurrence = newValue;
                        print('Dropdown new value: $_selectedRecurrence');
                      });
                    }
                  },
                  items: recurrenceOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Recurrence Type',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Recurrence Type Options
              if (_selectedRecurrence == 'Daily') _buildDailyOptions(),
              if (_selectedRecurrence == 'Weekly') _buildWeeklyOptions(),
              if (_selectedRecurrence == 'Bi-Weekly') _buildBiWeeklyOptions(),
              if (_selectedRecurrence == 'Monthly') _buildMonthlyOptions(),
              if (_selectedRecurrence == 'Custom') _buildCustomOptions(),
              if (_selectedRecurrence == 'Specific Days in Multiple Weeks')
                _buildSpecificDaysInMultipleWeeksOptions(),
              if (_selectedRecurrence == 'Advanced Options')
                _buildAdvancedOptions(),
              if (_selectedRecurrence == 'Combined Recurrence')
                _buildCombinedRecurrenceOptions(),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle recurrence logic based on the selected options.
                    Navigator.pop(context); // Close bottom sheet.
                  },
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyOptions() {
    return Column(
      children: [
        CheckboxListTile(
          title: const Text('Every Day'),
          value: _selectedRecurrence == 'Daily',
          onChanged: (bool? value) {
            setState(() {
              _selectedRecurrence = value == true ? 'Daily' : 'None';
              print('Checkbox new value: $_selectedRecurrence');
            });
          },
        ),
      ],
    );
  }

  Widget _buildWeeklyOptions() {
    return Column(
      children: [
        CheckboxListTile(
          title: const Text('Specific Days of the Week'),
          value: _selectedRecurrence == 'Weekly',
          onChanged: (bool? value) {
            setState(() {
              _selectedRecurrence = value == true ? 'Weekly' : 'None';
              print('Checkbox new value: $_selectedRecurrence');
            });
          },
        ),
        Wrap(
          spacing: 10.0,
          children: List.generate(7, (index) {
            return FilterChip(
              label: Text(weekdays[index]),
              selected: _daysSelected[index],
              onSelected: (bool selected) {
                setState(() {
                  _daysSelected[index] = selected;
                });
              },
            );
          }),
        ),
        CheckboxListTile(
          title: const Text('Every Weekday (Mon-Fri)'),
          value: _selectedRecurrence == 'Weekdays',
          onChanged: (bool? value) {
            setState(() {
              _selectedRecurrence = value == true ? 'Weekdays' : 'None';
              print('Checkbox new value: $_selectedRecurrence');
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Every Weekend (Sat-Sun)'),
          value: _selectedRecurrence == 'Weekend',
          onChanged: (bool? value) {
            setState(() {
              _selectedRecurrence = value == true ? 'Weekend' : 'None';
              print('Checkbox new value: $_selectedRecurrence');
            });
          },
        ),
      ],
    );
  }

  Widget _buildBiWeeklyOptions() {
    return CheckboxListTile(
      title: const Text('Every Two Weeks'),
      value: _selectedRecurrence == 'Bi-Weekly',
      onChanged: (bool? value) {
        setState(() {
          _selectedRecurrence = value == true ? 'Bi-Weekly' : 'None';
          print('Checkbox new value: $_selectedRecurrence');
        });
      },
    );
  }

  Widget _buildMonthlyOptions() {
    return Column(
      children: [
        CheckboxListTile(
          title: const Text('Specific Date(s) of the Month'),
          value: _selectedRecurrence == 'Monthly Specific Date(s)',
          onChanged: (bool? value) {
            setState(() {
              _selectedRecurrence =
                  value == true ? 'Monthly Specific Date(s)' : 'None';
              print('Checkbox new value: $_selectedRecurrence');
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Day of the Month (e.g., First Monday)'),
          value: _selectedRecurrence == 'Monthly Day of Month',
          onChanged: (bool? value) {
            setState(() {
              _selectedRecurrence =
                  value == true ? 'Monthly Day of Month' : 'None';
              print('Checkbox new value: $_selectedRecurrence');
            });
          },
        ),
      ],
    );
  }

  Widget _buildCustomOptions() {
    return Column(
      children: [
        ListTile(
          title: const Text('Every X Days'),
          subtitle: TextFormField(
            initialValue: '$_customDays',
            keyboardType: TextInputType.number,
            onChanged: (String value) {
              setState(() {
                _customDays = int.tryParse(value) ?? 1;
                print('Custom Days: $_customDays');
              });
            },
            decoration: const InputDecoration(
              labelText: 'Days Interval',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecificDaysInMultipleWeeksOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Specific Days in Multiple Weeks'),
        ),
        for (var week in _weeks)
          ExpansionTile(
            title: Text(week),
            children: weekdays.map((day) {
              final isSelected =
                  _selectedMultipleWeekDays.contains('$week $day');
              return CheckboxListTile(
                title: Text(day),
                value: isSelected,
                onChanged: (bool? selected) {
                  setState(() {
                    if (selected == true) {
                      _selectedMultipleWeekDays.add('$week $day');
                    } else {
                      _selectedMultipleWeekDays.remove('$week $day');
                    }
                    print(
                        'Selected Multiple Week Days: $_selectedMultipleWeekDays');
                  });
                },
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildAdvancedOptions() {
    return Column(
      children: [
        ListTile(
          title: const Text('Skip Occurrences'),
          subtitle:
              const Text('Specify dates or conditions to skip occurrences'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Navigate to another screen or show a dialog for skipping occurrences
          },
        ),
        ListTile(
          title: const Text('End Recurrence After X Occurrences'),
          subtitle: TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Number of Occurrences',
            ),
            onChanged: (String value) {
              // Update state or handle end recurrence logic
              print('End Recurrence After: $value occurrences');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCombinedRecurrenceOptions() {
    return Column(
      children: [
        ListTile(
          title: const Text('Combination of Rules'),
          subtitle: const Text('Combine different recurrence rules'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Navigate to another screen or show a dialog for combining rules
          },
        ),
      ],
    );
  }
}
