import 'package:flutter/material.dart';

class TrainerSearchScreen extends StatefulWidget {
  const TrainerSearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<TrainerSearchScreen> {
  final images = [
    "assets/images/pf.jpg",
    "assets/images/pf2.jpg",
    "assets/images/pf3.jpg",
    "assets/images/pf4.jpg",
    "assets/images/pf5.jpg",
  ];

  final trainers = [
    'Albert M.',
    'Ernest A.',
    'Lucis M.',
    'Mills A.',
    'William A.',
  ];
  final emails = [
    'albert.m@example.com',
    'ernest.m@example.com.',
    'lucy.m@example.com',
    'mills.m@example.com',
    'william.m@example.com',
  ];

  void _showSnackBarAndSendRequest(BuildContext context) {
    const snackBar = SnackBar(
      content: Text(
        'Request sent successfully!',
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.brown,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Navigator.of(context).pop();
  }

  void _showTrainerDetails(
      BuildContext context, String name, String email, String image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(image),
                      ),
                      const Positioned(
                        top: 50,
                        left: 60,
                        child: Icon(Icons.lock),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(email),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _showSnackBarAndSendRequest(context);
                      // Add your request logic here
                    },
                    child: const Text("Send Request"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text('Search Trainers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search trainers...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.sort),
                  onPressed: () {
                    // Add your sorting logic here
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _showTrainerDetails(context, trainers[index],
                          emails[index], images[index]);
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 2.0,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(images[index]),
                        ),
                        title: Text(
                          trainers[index],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(emails[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
