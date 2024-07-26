import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voltican_fitness/widgets/trainee.dart';

class TraineesScreen extends StatefulWidget {
  const TraineesScreen({Key? key}) : super(key: key);

  @override
  _TraineesScreenState createState() => _TraineesScreenState();
}

class _TraineesScreenState extends State<TraineesScreen> {
  String activeTab = 'button1';
  bool loading = true;
  dynamic user; // This will hold the user data
  List<dynamic> trainees = []; // This will hold the trainees data

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchMeals();
    getTrainees();
  }

  Future<void> fetchUserData() async {
    // Fetch the user data here
    setState(() {
      user = {
        'role': 0,
        'img_url': null, // Replace with actual image URL
      };
    });
  }

  Future<void> fetchMeals() async {
    try {
      // Fetch your meals here
    } catch (error) {
      // Handle error
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> getTrainees() async {
    try {
      // Fetch your trainees here
      setState(() {
        trainees = [
          // Replace with actual data
        ];
      });
    } catch (error) {
      // Handle error
    }
  }

  void handlePress(String tab) {
    setState(() {
      activeTab = tab;
    });
  }

  Widget renderTraineeItem(BuildContext context, dynamic item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      child: activeTab == 'button1'
          ? Trainee(trainee: item) // Replace with your Trainee widget
          : AssignedTrainee(
              trainee: item), // Replace with your AssignedTrainee widget
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE5ECF9), Color(0xFFF6F7F9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 30, 16, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trainees',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.grey[300],
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Trainer',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => handlePress('button1'),
                        child: Column(
                          children: [
                            Text('My Trainees'),
                            Container(
                              height: 3,
                              color: activeTab == 'button1'
                                  ? Colors.red
                                  : Colors.red[200],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => handlePress('button2'),
                        child: Column(
                          children: [
                            Text('Assigned Trainees'),
                            Container(
                              height: 3,
                              color: activeTab == 'button2'
                                  ? Colors.red
                                  : Colors.red[200],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.search),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search by username',
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: loading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount:
                            trainees.length, // Replace with your data length
                        itemBuilder: (context, index) {
                          return renderTraineeItem(context,
                              trainees[index]); // Replace with your data item
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AssignedTrainee extends StatelessWidget {
  final dynamic trainee;

  const AssignedTrainee({Key? key, required this.trainee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Build your AssignedTrainee widget
    return Container();
  }
}
