import 'package:fit_cibus/screens/add_meal_screen.dart';
import 'package:fit_cibus/screens/assign_recipe_screen.dart';
import 'package:flutter/material.dart';

class RecipeGridScreen extends StatefulWidget {
  const RecipeGridScreen({super.key});

  @override
  _RecipeGridScreenState createState() => _RecipeGridScreenState();
}

class _RecipeGridScreenState extends State<RecipeGridScreen> {
  int? _selectedRecipeIndex;

  final List<Map<String, String>> recipes = [
    {
      'image':
          'https://images.pexels.com/photos/1640771/pexels-photo-1640771.jpeg?auto=compress&cs=tinysrgb&w=800',
      'name': 'lava',
    },
    {
      'image':
          'https://images.pexels.com/photos/4551832/pexels-photo-4551832.jpeg?auto=compress&cs=tinysrgb&w=800',
      'name': 'Avodao mix',
    },
    {
      'image':
          'https://images.pexels.com/photos/1556688/pexels-photo-1556688.jpeg?auto=compress&cs=tinysrgb&w=800',
      'name': 'Mello chicken',
    },
    {
      'image':
          'https://images.pexels.com/photos/6210876/pexels-photo-6210876.jpeg?auto=compress&cs=tinysrgb&w=800',
      'name': 'Mango and rice',
    },
    {
      'image':
          'https://images.pexels.com/photos/6294359/pexels-photo-6294359.jpeg?auto=compress&cs=tinysrgb&w=800',
      'name': 'Chicken Wings',
    },
    {
      'image':
          'https://images.pexels.com/photos/6210984/pexels-photo-6210984.jpeg?auto=compress&cs=tinysrgb&w=800',
      'name': 'Recipe 6',
    },
    {
      'image':
          'https://images.pexels.com/photos/4946547/pexels-photo-4946547.jpeg?auto=compress&cs=tinysrgb&w=800',
      'name': 'Recipe 7',
    },
    {
      'image':
          'https://images.pexels.com/photos/5002442/pexels-photo-5002442.jpeg?auto=compress&cs=tinysrgb&w=800',
      'name': 'Recipe 8',
    },
    {
      'image':
          'https://images.pexels.com/photos/6210984/pexels-photo-6210984.jpeg?auto=compress&cs=tinysrgb&w=800',
      'name': 'Recipe 9',
    },
    {
      'image':
          'https://images.pexels.com/photos/4210803/pexels-photo-4210803.jpeg?auto=compress&cs=tinysrgb&w=800',
      'name': 'Recipe 9',
    },
    {
      'image':
          'https://images.pexels.com/photos/6210984/pexels-photo-6210984.jpeg?auto=compress&cs=tinysrgb&w=800',
      'name': 'Recipe 10',
    },
    {
      'image':
          'https://images.pexels.com/photos/6210984/pexels-photo-6210984.jpeg?auto=compress&cs=tinysrgb&w=800',
      'name': 'Recipe 11',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RecipeScreen()));
              }),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {})
        ],
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: const Text('Select a recipe'),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedRecipeIndex == index;
          return GestureDetector(
            onTap: () => _onRecipeTap(index),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(recipes[index]['image']!),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: isSelected
                        ? Border.all(color: Colors.red, width: 5)
                        : Border.all(color: Colors.transparent),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    recipes[index]['name']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onRecipeTap(int index) {
    setState(() {
      _selectedRecipeIndex = index;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(recipes[index]['name']!),
        content: const Text('Do you want to assign this recipe?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AssignRecipeScreen()));
              // Assign logic goes here
            },
            child: const Text('Assign'),
          ),
        ],
      ),
    );
  }
}
