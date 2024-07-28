import 'package:flutter/material.dart';

class AssignRecipeScreen extends StatefulWidget {
  const AssignRecipeScreen({super.key});

  @override
  _AssignRecipeScreenState createState() => _AssignRecipeScreenState();
}

class _AssignRecipeScreenState extends State<AssignRecipeScreen> {
  TimeOfDay? _selectedTime;
  String _selectedDuration = 'Month';
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
            children: [
              // Time Picker
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickTime,
                    child: Text(_selectedTime == null
                        ? 'Pick Time'
                        : 'Selected Time: ${_selectedTime!.format(context)}'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Dropdown for Duration
              DropdownButton<String>(
                value: _selectedDuration,
                items: ['Month', '3 Months', '6 Months', 'Year']
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
            ],
          ),
        ),
      ),
    );
  }
}
