import 'package:flutter/material.dart';

class Trainee extends StatelessWidget {
  final Map<String, dynamic> trainee;

  const Trainee({super.key, required this.trainee});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TraineeDetailScreen(traineeDetail: trainee),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                trainee['img_url'] != null
                    ? ClipOval(
                        child: Image.network(
                          trainee['img_url'],
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFFE5ECF9),
                        backgroundImage: AssetImage('assets/images/blank-profile.png'),
                      ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trainee['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      trainee['email'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Active',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),
            Divider(color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }}





class TraineeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> traineeDetail;

  const TraineeDetailScreen({super.key, required this.traineeDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainee Detail'),
      ),
      body: Center(
        child: Text('Details for ${traineeDetail['name']}'),
      ),
    );
  }
}