import 'package:flutter/material.dart';
import 'package:voltican_fitness/screens/calendar_screen.dart';
import 'package:voltican_fitness/widgets/button.dart';
import 'package:intl/intl.dart';

class AssignRecipeScreen extends StatefulWidget {
  const AssignRecipeScreen({super.key});

  @override
  _AssignRecipeScreenState createState() => _AssignRecipeScreenState();
}

class _AssignRecipeScreenState extends State<AssignRecipeScreen> {
  TimeOfDay? _selectedTime;
  String _selectedDuration = 'Does Not Repeat';
  final List<String> _allTrainees = [
    'John Doe',
    'Jane Smith',
    'Alice Johnson',
    'Bob Brown'
  ];
  List<String> _searchResults = [];
  final List<String> _selectedTrainees = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _searchTrainees(String query) {
    setState(() {
      _searchResults = _allTrainees
          .where(
              (trainee) => trainee.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _addTrainee(String trainee) {
    if (_selectedTrainees.contains(trainee)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Duplicate Entry'),
          content: const Text('This trainee has already been added.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        _selectedTrainees.add(trainee);
        _searchController.clear();
        _searchResults.clear();
      });
    }
  }

  void _removeTrainee(String trainee) {
    setState(() {
      _selectedTrainees.remove(trainee);
    });
  }

// Date picker implemetation
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        centerTitle: true,
        title: const Text('Assign Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Time Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _pickTime,
                    child: Text(_selectedTime == null
                        ? 'Pick Time'
                        : 'Selected Time: ${_selectedTime!.format(context)}'),
                  ),
                  GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _selectedDate == null
                              ? 'Select Date'
                              : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ))
                ],
              ),
              const SizedBox(height: 20),

              // Dropdown for Duration
              DropdownButton<String>(
                value: _selectedDuration,
                items: [
                  'Does Not Repeat',
                  'Daily',
                  'Weekly',
                  'Monthly',
                  'Yearly',
                  'Custom'
                ]
                    .map((duration) => DropdownMenuItem<String>(
                          value: duration,
                          child: Text(duration),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDuration = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Search Field for Trainees
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Trainees',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _searchTrainees(_searchController.text);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Search Results
              if (_searchResults.isNotEmpty)
                ..._searchResults.map((trainee) => ListTile(
                      title: Text(trainee),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          _addTrainee(trainee);
                        },
                      ),
                    )),

              const SizedBox(height: 20),

              // Selected Trainees
              if (_selectedTrainees.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selected Trainees:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ..._selectedTrainees.map((trainee) => Chip(
                          label: Text(trainee),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () {
                            _removeTrainee(trainee);
                          },
                        )),
                  ],
                ),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CalendarScreen()));
                },
                child: const ButtonWidget(
                    backColor: Colors.red,
                    text: "Complete Plan",
                    textColor: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
