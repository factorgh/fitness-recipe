import 'package:fit_cibus/screens/trainer_profile_screen.dart';
import 'package:flutter/material.dart';


class SliderTrainerLanding extends StatelessWidget {
  final List<String> recipes;
  final List<String> emails;
  final List<String> images;
  final List<String> ids;
  final Function(String) onTrainerSelected;

  const SliderTrainerLanding({
    super.key,
    required this.recipes,
    required this.emails,
    required this.images,
    required this.ids,
    required this.onTrainerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Adjust height as needed
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recipes.isEmpty
            ? 5
            : recipes.length, // Show 5 placeholders if recipes are empty
        itemBuilder: (context, index) {
          if (recipes.isEmpty) {
            // Display placeholder avatars if no recipes are available
            return _buildPlaceholderItem();
          } else {
            // Display actual items if recipes are available
            return _buildTrainerItem(
              context,
              recipes[index],
              images[index],
              emails[index],
              ids[index],
            );
          }
        },
      ),
    );
  }

  Widget _buildPlaceholderItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[300], // Placeholder background color
            child:
                Icon(Icons.person, color: Colors.grey[600]), // Placeholder icon
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Loading...',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainerItem(BuildContext context, String trainer,
      String imagePath, String email, String id) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrainerProfileScreen(
              userId: id,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(imagePath),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              trainer,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBarAndSendRequest(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('Request sent!'),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.blue,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // Implement your request logic here
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
                      Navigator.of(context).pop();
                      _showSnackBarAndSendRequest(context);
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
}
