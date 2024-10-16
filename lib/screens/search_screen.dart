import 'package:fit_cibus/models/recipe.dart';
import 'package:fit_cibus/screens/trainer_meal_details_trainee.dart';
import 'package:fit_cibus/services/recipe_service.dart';
import 'package:fit_cibus/utils/conversions/capitalize_first.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final String category;

  const SearchScreen({
    super.key,
    required this.category,
  });

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<List<Recipe>> _recipesFuture;
  List<Recipe> _allRecipes = [];
  List<Recipe> _filteredRecipes = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Recipe>>(
                future: _recipesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No recipes found'));
                  } else {
                    return ListView.builder(
                      itemCount: _filteredRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = _filteredRecipes[index];
                        return GestureDetector(
                          onTap: () => handleRecipeSelected(recipe),
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      recipe.imageUrl,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CapitalizeFirstLetter(text: recipe.title),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 12,
                                          ),
                                          Text(
                                              ' ${recipe.averageRating.toStringAsFixed(1)}'),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void handleRecipeSelected(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainerMealDetailScreen(
          meal: recipe,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _recipesFuture = RecipeService().fetchRecipesByMealPeriod(widget.category);
    _fetchRecipes();
    _searchController.addListener(_filterRecipes);
  }

  Future<void> _fetchRecipes() async {
    try {
      final recipes = await _recipesFuture;
      setState(() {
        _allRecipes = recipes;
        _filteredRecipes = recipes; // Initially display all recipes
      });
    } catch (e) {
      // Handle error
    }
  }

  void _filterRecipes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRecipes = _allRecipes.where((recipe) {
        final titleLower = recipe.title.toLowerCase();
        return titleLower.contains(query);
      }).toList();
    });
  }
}
