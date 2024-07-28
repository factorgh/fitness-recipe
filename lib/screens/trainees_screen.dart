import 'package:flutter/material.dart';

class TraineesScreen extends StatefulWidget {
  const TraineesScreen({super.key});

  @override
  _TraineesScreenState createState() => _TraineesScreenState();
}

class _TraineesScreenState extends State<TraineesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildListView(List<Map<String, String>> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildListView(trainees),
                buildListView(trainers),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final List<Map<String, String>> trainees = [
    {
      'image': 'https://via.placeholder.com/150',
      'name': 'John Doe',
      'telephone': '123-456-7890',
    },
    {
      'image': 'https://via.placeholder.com/150',
      'name': 'Jane Smith',
      'telephone': '098-765-4321',
    },
  ];

  final List<Map<String, String>> trainers = [
    {
      'image': 'https://via.placeholder.com/150',
      'name': 'Alice Johnson',
      'telephone': '555-123-4567',
    },
    {
      'image': 'https://via.placeholder.com/150',
      'name': 'Bob Brown',
      'telephone': '555-987-6543',
    },
  ];
}
