import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:voltican_fitness/widgets/trainer_column_item.dart';

class TrainerProfileScreen extends StatelessWidget {
  TrainerProfileScreen({super.key});

  // Replace with your profile image URL

  final List<String> photos = List.generate(
      6,
      (index) =>
          'https://images.pexels.com/photos/3838633/pexels-photo-3838633.jpeg?auto=compress&cs=tinysrgb&w=800');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back)),
        title: const Text('Trainer Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Profile section
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: CachedNetworkImageProvider(
                            "https://images.pexels.com/photos/428361/pexels-photo-428361.jpeg?auto=compress&cs=tinysrgb&w=800"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Albert Smith", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  TrainerColumnItem(count: "30", title: "Followers"),
                  SizedBox(
                    width: 10,
                  ),
                  TrainerColumnItem(count: "5", title: "Following"),
                  SizedBox(
                    width: 10,
                  ),
                  TrainerColumnItem(count: "10", title: "Recipes"),
                  SizedBox(
                    width: 10,
                  ),
                  TrainerColumnItem(count: "100", title: "Meal Plans"),
                ],
              ),
            ),
            //
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: photos[index],
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                );
              },
            ),

//
          ],
        ),
      ),
    );
  }
}
