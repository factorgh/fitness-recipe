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
  String _selectedRecurrence = 'Daily'; // Default recurrence selection
  int _customDays = 1; // Custom interval days
  final List<bool> _daysSelected =
      List.generate(7, (_) => false); // Selected days for weekly options
// Date for custom rule
  final List<DateTime> _exceptions = []; // List of exception dates
  final List<DateTime> _selectedMonthlyDates = [];

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
    return Column(
      children: [
        CheckboxListTile(
          title: const Text('Every Day'),
          value: _selectedRecurrence == 'Daily',
          onChanged: (bool? value) {
            setState(() {
              _selectedRecurrence = value == true ? 'Daily' : 'None';
            });
          },
        ),
        _buildExceptionDates(),
      ],
    );
  }

  // Helper: Build weekly recurrence widget
  Widget _buildWeeklyOptions() {
    return Column(
      children: [
        const Text('Select Days of the Week'),
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
        _buildExceptionDates(),
      ],
    );
  }

// Add a state variable to track whether the checkbox is selected
  bool _showBiWeeklyInfo = false;

  Widget _buildBiWeeklyOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          title: const Text('Bi-Weekly'),
          value: _selectedRecurrence == 'Bi-Weekly',
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                _selectedRecurrence = 'Bi-Weekly';
              } else {
                _selectedRecurrence = '';
              }
              _showBiWeeklyInfo = value ?? false;
            });
          },
        ),

        // Conditionally show bi-weekly info if the checkbox is selected
        if (_showBiWeeklyInfo)
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              'Bi-Weekly runs every two weeks.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
      ],
    );
  }

  // Helper: Build custom options
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
              });
            },
            decoration: const InputDecoration(
              labelText: 'Days Interval',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildExceptionDates(),
      ],
    );
  }

  Widget _buildMonthlyOptions() {
    return Column(
      children: [
        const Text('Select Specific Date(s) of the Month'),
        const SizedBox(height: 10),

        // Button to trigger date picker
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
                // Add selected date to the list
                _selectedMonthlyDates.add(pickedDate);
              });
            }
          },
          child: const Text('Add Date'),
        ),

        const SizedBox(height: 10),

        // Display selected dates
        if (_selectedMonthlyDates.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selected Dates:',
                style: TextStyle(fontWeight: FontWeight.bold),
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

        const SizedBox(height: 20),
      ],
    );
  }

  // Helper: Build exceptions UI
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

  // Logic for saving the recurrence
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
            .map((entry) => entry.key)
            .toList(); // Selected days (0 = Mon, 6 = Sun)
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

    // Add exceptions if any
    if (_exceptions.isNotEmpty) {
      recurrenceData['exceptions'] =
          _exceptions.map((e) => e.toIso8601String()).toList();
    }

    print('Recurrence Data: $recurrenceData');

    Navigator.pop(context);
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
