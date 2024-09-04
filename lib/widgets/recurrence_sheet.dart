// ignore_for_file: avoid_print, unused_element

import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> showRecurrenceBottomSheet(
    BuildContext context) async {
  return await showModalBottomSheet<Map<String, dynamic>>(
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
  String _selectedRecurrence = 'Daily'; // Default recurrence selection
  final int _customDays = 1; // Custom interval days
  final List<bool> _daysSelected =
      List.generate(7, (_) => false); // Selected days for weekly options
// Date for custom rule
  final List<DateTime> _exceptions = []; // List of exception dates
  final List<DateTime> _selectedMonthlyDates = [];

  final List<bool> _daysOfWeekSelected = List<bool>.filled(7, false);
  final List<bool> _daysOfMonthSelected = List<bool>.filled(31, false);
  // Selected custom days for recurrence

  final List<String> weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  final List<String> recurrenceOptions = [
    'Daily',
    'Weekly',
    'Bi-Weekly',
    'Monthly',
    'Custom',
  ];

  // Helper: Build daily recurrence widget
  Widget _buildDailyOptions() {
    return const Column(
      children: [],
    );
  }

  // Helper: Build weekly recurrence widget
  Widget _buildWeeklyOptions() {
    return Column(
      children: [
        const Text(
          'Create custom recurrence ',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        ListTile(
          title: const Text('Select Days of the Week'),
          subtitle: Wrap(
            spacing: 10.0,
            children: List.generate(7, (index) {
              return FilterChip(
                label: Text(weekdays[index]),
                selected: _daysOfWeekSelected[index],
                onSelected: (bool selected) {
                  setState(() {
                    _daysOfWeekSelected[index] = selected;
                  });
                },
              );
            }),
          ),
        ),
      ],
    );
  }

// Add a state variable to track whether the checkbox is selected

  Widget _buildBiWeeklyOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
            child: Text(
          'Create custom recurrence ',
          style: TextStyle(fontWeight: FontWeight.w800),
        )),
        ListTile(
          title: const Text('Select Days of the Week'),
          subtitle: Wrap(
            spacing: 10.0,
            children: List.generate(7, (index) {
              return FilterChip(
                label: Text(weekdays[index]),
                selected: _daysOfWeekSelected[index],
                onSelected: (bool selected) {
                  setState(() {
                    _daysOfWeekSelected[index] = selected;
                  });
                },
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomOptions() {
    String _getOrdinal(int number) {
      if (number >= 11 && number <= 13) {
        return '${number}th';
      }
      switch (number % 10) {
        case 1:
          return '${number}st';
        case 2:
          return '${number}nd';
        case 3:
          return '${number}rd';
        default:
          return '${number}th';
      }
    }

    return Column(
      children: [
        const Text(
          'Create custom recurrence',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        const SizedBox(
          width: 50,
        ),
        const SizedBox(height: 10),

        const SizedBox(height: 10),
        // Horizontally scrollable list of days of the month
        ListTile(
          title: const Text(
            'Select Days of the Month',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          subtitle: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Enables horizontal scrolling
            child: Wrap(
              spacing: 10.0,
              children: List.generate(31, (index) {
                int day = index + 1;
                String ordinalDay =
                    _getOrdinal(day); // Get the ordinal version of the day
                return FilterChip(
                  label: Text(ordinalDay),
                  selected: _daysOfMonthSelected[index],
                  onSelected: (bool selected) {
                    setState(() {
                      _daysOfMonthSelected[index] = selected;
                    });
                  },
                );
              }),
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Divider(
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const SizedBox(width: 10),
              const Text(
                'Select specific dates ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedMonthlyDates.add(pickedDate);
                    });
                  }
                },
                child: const Text('Add Date'),
              ),
            ],
          ),
        ),

        if (_selectedMonthlyDates.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Selected Dates:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ..._selectedMonthlyDates.map((date) {
                return ListTile(
                  title: Text(date.toLocal().toString().split(' ')[0]),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      setState(() {
                        // Remove the date from the list
                        _selectedMonthlyDates.remove(date);
                      });
                    },
                  ),
                );
              }),
            ],
          ),
      ],
    );
  }

  Widget _buildMonthlyOptions() {
    return Column(
      children: [
        const Text(
          'Create custom recurrence ',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        ListTile(
          title: const Text('Select Days of the Week'),
          subtitle: Wrap(
            spacing: 10.0,
            children: List.generate(7, (index) {
              return FilterChip(
                label: Text(weekdays[index]),
                selected: _daysOfWeekSelected[index],
                onSelected: (bool selected) {
                  setState(() {
                    _daysOfWeekSelected[index] = selected;
                  });
                },
              );
            }),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildExceptionDates() {
    return Column(
      children: [
        const Text('Add Exception Dates (Optional)'),
        ElevatedButton(
          onPressed: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (pickedDate != null) {
              setState(() {
                _exceptions.add(pickedDate);
              });
            }
          },
          child: const Text('Add Exception Date'),
        ),
        Wrap(
          children: _exceptions
              .map((date) => Chip(
                    label: Text(date.toLocal().toString().split(' ')[0]),
                    onDeleted: () {
                      setState(() {
                        _exceptions.remove(date);
                      });
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }

  void _saveRecurrence() {
    final Map<String, dynamic> recurrenceData = {};

    switch (_selectedRecurrence) {
      case 'Daily':
        recurrenceData['option'] = 'every_day';
        break;
      case 'Weekly':
        recurrenceData['option'] = 'weekly';
        recurrenceData['customDays'] = _daysSelected
            .asMap()
            .entries
            .where((entry) => entry.value)
            .map((entry) => entry.key + 1)
            .toList(); // Selected days (1 = Mon, 7 = Sun)
        break;
      case 'Bi-Weekly':
        recurrenceData['option'] = 'bi_weekly';
        break;
      case 'Monthly':
        recurrenceData['option'] = 'monthly';
        recurrenceData['selectedDates'] =
            _selectedMonthlyDates.map((d) => d.toIso8601String()).toList();
        break;
      case 'Custom':
        recurrenceData['option'] = 'custom_weekly';
        recurrenceData['customDays'] = _customDays;
        break;
    }

    if (_exceptions.isNotEmpty) {
      recurrenceData['exceptions'] =
          _exceptions.map((e) => e.toIso8601String()).toList();
    }

    print('Recurrence Data: $recurrenceData');

    Navigator.pop(context, recurrenceData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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

              // Render specific options for selected recurrence type
              if (_selectedRecurrence == 'Daily') _buildDailyOptions(),
              if (_selectedRecurrence == 'Weekly') _buildWeeklyOptions(),
              if (_selectedRecurrence == 'Monthly') _buildMonthlyOptions(),
              if (_selectedRecurrence == 'Custom') _buildCustomOptions(),
              if (_selectedRecurrence == 'Bi-Weekly') _buildBiWeeklyOptions(),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _saveRecurrence,
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
