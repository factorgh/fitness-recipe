import 'package:flutter/material.dart';

class RoleItemWidget extends StatelessWidget {
  final String labelText;
  final bool isSelected;
  final String imagePath;

  const RoleItemWidget({
    super.key,
    required this.labelText,
    required this.imagePath,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            width: isSelected ? 5 : 3,
            color: isSelected
                ? Colors.red
                : const Color.fromARGB(255, 250, 233, 233),
          ),
        ),
        child: Stack(
          children: [
            // Image as background
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(imagePath),
                ),
              ),
            ),
            // Text on top of the image
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                color: Colors.black
                    .withOpacity(0.5), // Semi-transparent background for text
                child: Text(
                  labelText,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
