import 'package:flutter/material.dart';

class TopTrainerSlider extends StatelessWidget {
  final List<String> recipes;
  final List<String> images;
  final Function(String) onTrainerSelected;

  const TopTrainerSlider({
    super.key,
    required this.recipes,
    required this.images,
    required this.onTrainerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Adjust height as needed
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return _buildTrainerItem(context, recipes[index], images[index]);
        },
      ),
    );
  }

  Widget _buildTrainerItem(
      BuildContext context, String trainer, String imagePath) {
    return GestureDetector(
        onTap: () => onTrainerSelected(trainer),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.black12,
                backgroundImage: AssetImage(imagePath),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(trainer,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
        ));
  }
}
