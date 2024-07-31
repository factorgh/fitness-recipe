import 'package:flutter/material.dart';

import 'package:voltican_fitness/screens/trainer_profile_screen.dart';

class TraineesScreen extends StatefulWidget {
  const TraineesScreen({super.key});

  @override
  _TraineesScreenState createState() => _TraineesScreenState();
}

class _TraineesScreenState extends State<TraineesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedDropdown = 'Following';
  String selectedTrainee = 'Followers';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild the widget tree when the tab changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildListView(List<Map<String, String>> items, bool isTrainer) {
    Future<void> showDeleteConfirmationDialog(BuildContext context) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // User must tap button to dismiss
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Confirm Delete',
              style: TextStyle(color: Colors.black87),
            ),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Are you sure you want to peform a delete?',
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  // Perform the delete action
                  Navigator.of(context).pop(); // Close the dialog
                  // You can call a function here to delete the item
                  // For example: _deleteItem();
                },
              ),
            ],
          );
        },
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TrainerProfileScreen()));
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(items[index]['image']!),
                ),
                title: Text(items[index]['name']!),
                subtitle: Text(items[index]['telephone']!),
                trailing: Column(
                  children: [
                    const Text(
                      "Following",
                      style: TextStyle(color: Colors.blue),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          showDeleteConfirmationDialog(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            child: Text(
                              "Remove",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ),
                        ))
                  ],
                )),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.person),
        title: const Text('Trainers'),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.red,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.black,
            tabs: const [
              Tab(text: 'Trainees'),
              Tab(text: 'Trainers'),
            ],
          ),
          if (_tabController.index ==
              0) // Display dropdown only on Trainers tab
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: selectedTrainee,
                  items: ['Followers', 'All'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedTrainee = newValue!;
                    });
                  },
                ),
              ],
            ),
          if (_tabController.index ==
              1) // Display dropdown only on Trainers tab
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: selectedDropdown,
                  items: ['Following', 'Followers'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedDropdown = newValue!;
                    });
                  },
                ),
              ],
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildListView(trainees, true), // Pass false for trainees
                buildListView(trainers, true), // Pass true for trainers
              ],
            ),
          ),
        ],
      ),
    );
  }

  final List<Map<String, String>> trainees = [
    {
      'image':
          'https://images.pexels.com/photos/1674752/pexels-photo-1674752.jpeg?auto=compress&cs=tinysrgb&w=800',
      'name': 'John Doe',
      'telephone': '123-456-7890',
      'isFollowing': 'false',
    },
    {
      'image':
          'https://images.pexels.com/photos/1542085/pexels-photo-1542085.jpeg?auto=compress&cs=tinysrgb&w=800',
      'name': 'Jane Smith',
      'telephone': '098-765-4321',
      'isFollowing': 'false',
    },
  ];

  final List<Map<String, String>> trainers = [
    {
      'image':
          'https://images.pexels.com/photos/428364/pexels-photo-428364.jpeg?auto=compress&cs=tinysrgb&w=800',
      'name': 'Alice Johnson',
      'telephone': '555-123-4567',
      'isFollowing': 'false',
    },
    {
      'image':
          'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=800',
      'name': 'Bob Brown',
      'telephone': '555-987-6543',
      'isFollowing': 'false',
    },
  ];
}
