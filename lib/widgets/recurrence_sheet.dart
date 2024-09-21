import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> showRecurrenceBottomSheet(
    BuildContext context, DateTime startDate, DateTime endDate) async {
  return await showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    enableDrag: true,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return RecurrenceSelectionWidget(
        startDate: startDate,
        endDate: endDate,
      );
    },
  );
}

class RecurrenceSelectionWidget extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  const RecurrenceSelectionWidget(
      {super.key, required this.startDate, required this.endDate});

  @override
  _RecurrenceSelectionWidgetState createState() =>
      _RecurrenceSelectionWidgetState();
}

class _RecurrenceSelectionWidgetState extends State<RecurrenceSelectionWidget> {
  String _selectedRecurrence = 'Daily'; // Default recurrence selection

  final List<DateTime> _exceptions = []; // List of exception dates
  final List<DateTime> _selectedMonthlyDates = [];

  final List<bool> _daysOfWeekSelected = List<bool>.filled(7, false);

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

  bool _hasSelectedDays =
      false; // To track if days of the week have been selected
  bool _hasSelectedDates =
      false; // To track if specific dates have been selected

  // Function to show confirmation dialog
  Future<void> _showOverrideConfirmationDialog(String type) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Override Selection'),
          content: Text(
              'Switching to $type will override your previous selection. Do you want to proceed?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Proceed'),
              onPressed: () {
                setState(() {
                  // Clear both lists when switching
                  _hasSelectedDays = (type == 'Days of the Week');
                  _hasSelectedDates = (type == 'Specific Dates');
                  _daysOfWeekSelected.fillRange(
                      0, _daysOfWeekSelected.length, false);
                  _selectedMonthlyDates.clear();
                });
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

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
                onSelected: (bool selected) async {
                  if (_hasSelectedDates) {
                    await _showOverrideConfirmationDialog('Days of the Week');
                  } else {
                    setState(() {
                      _daysOfWeekSelected[index] = selected;
                      _hasSelectedDays = true;
                    });
                  }
                },
              );
            }),
          ),
        ),
        const Divider(),
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
                  if (_hasSelectedDays) {
                    await _showOverrideConfirmationDialog('Specific Dates');
                  } else {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: widget.startDate,
                      firstDate: widget.startDate,
                      lastDate: widget.endDate,
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedMonthlyDates.add(pickedDate);
                        _hasSelectedDates = true;
                      });
                    }
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
                        _selectedMonthlyDates.remove(date);
                        if (_selectedMonthlyDates.isEmpty) {
                          _hasSelectedDates = false;
                        }
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

  void _saveRecurrence() {
    final Map<String, dynamic> recurrenceData = {};

    switch (_selectedRecurrence) {
      case 'Daily':
        recurrenceData['option'] = 'every_day';
        break;
      case 'Weekly':
        recurrenceData['option'] = 'weekly';
        recurrenceData['customDays'] = _daysOfWeekSelected
            .asMap()
            .entries
            .where((entry) => entry.value)
            .map((entry) => entry.key + 1)
            .toList();
        recurrenceData['customDates'] = _selectedMonthlyDates
            .map((d) => d.toUtc().toIso8601String()) // Convert to UTC with "Z"
            .toList();
        break;
      case 'Bi-Weekly':
        recurrenceData['option'] = 'bi_weekly';
        recurrenceData['customDays'] = _daysOfWeekSelected
            .asMap()
            .entries
            .where((entry) => entry.value)
            .map((entry) => entry.key + 1)
            .toList();
        recurrenceData['customDates'] = _selectedMonthlyDates
            .map((d) => d.toUtc().toIso8601String()) // Convert to UTC with "Z"
            .toList();
        break;
      case 'Monthly':
        recurrenceData['option'] = 'monthly';
        recurrenceData['customDates'] = _selectedMonthlyDates
            .map((d) => d.toUtc().toIso8601String()) // Convert to UTC with "Z"
            .toList();
        recurrenceData['customDays'] = _daysOfWeekSelected
            .asMap()
            .entries
            .where((entry) => entry.value)
            .map((entry) => entry.key + 1)
            .toList();
        break;
      case 'Custom':
        recurrenceData['option'] = 'custom_weekly';
        recurrenceData['customDays'] = _daysOfWeekSelected
            .asMap()
            .entries
            .where((entry) => entry.value)
            .map((entry) => entry.key + 1)
            .toList();
        recurrenceData['customDates'] = _selectedMonthlyDates
            .map((d) => d.toUtc().toIso8601String()) // Convert to UTC with "Z"
            .toList();
        break;
    }

    // Add exceptions if present
    if (_exceptions.isNotEmpty) {
      recurrenceData['exceptions'] = _exceptions
          .map((date) =>
              date.toUtc().toIso8601String()) // Ensure exceptions also have "Z"
          .toList();
    }

    // Save and return recurrence data
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
              if (_selectedRecurrence == 'Daily') const SizedBox(),
              if (_selectedRecurrence == 'Weekly') _buildWeeklyOptions(),
              if (_selectedRecurrence == 'Monthly') _buildWeeklyOptions(),
              if (_selectedRecurrence == 'Custom') _buildWeeklyOptions(),
              if (_selectedRecurrence == 'Bi-Weekly') _buildWeeklyOptions(),

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
