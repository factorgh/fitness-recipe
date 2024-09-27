import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaginatedRecipeList extends StatefulWidget {
  final String query;

  const PaginatedRecipeList({super.key, required this.query});

  @override
  _PaginatedRecipeListState createState() => _PaginatedRecipeListState();
}

class _PaginatedRecipeListState extends State<PaginatedRecipeList> {
  List<dynamic> recipes = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'http://your-server.com/api/recipes/search?query=${widget.query}&page=$currentPage&limit=20'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        recipes.addAll(data['recipes']);
        currentPage++;
        hasMore = currentPage <= data['totalPages'];
      });
    } else {
      // Handle the error
      throw Exception('Failed to load recipes');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          fetchRecipes();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: recipes.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == recipes.length) {
            return const Center(child: CircularProgressIndicator());
          }
          final recipe = recipes[index];
          return ListTile(
            title: Text(recipe['name']),
            subtitle: Text(recipe['description']),
          );
        },
      ),
    );
  }
}
