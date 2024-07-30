import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecipeSlider extends StatefulWidget {
  const RecipeSlider({super.key});

  @override
  _RecipeSliderState createState() => _RecipeSliderState();
}

class _RecipeSliderState extends State<RecipeSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<Map<String, String>> _recipes = [
    {
      'title': 'Recipe 1',
      'description': 'This is a description of Recipe 1.',
      'imageUrl':
          'https://images.pexels.com/photos/1556688/pexels-photo-1556688.jpeg?auto=compress&cs=tinysrgb&w=800'
    },
    {
      'title': 'Recipe 2',
      'description': 'This is a description of Recipe 2.',
      'imageUrl':
          'https://images.pexels.com/photos/5966431/pexels-photo-5966431.jpeg?auto=compress&cs=tinysrgb&w=800'
    },
    {
      'title': 'Recipe 3',
      'description': 'This is a description of Recipe 3.',
      'imageUrl':
          'https://images.pexels.com/photos/6287493/pexels-photo-6287493.jpeg?auto=compress&cs=tinysrgb&w=800'
    },
    {
      'title': 'Recipe 4',
      'description': 'This is a description of Recipe 3.',
      'imageUrl':
          'https://images.pexels.com/photos/6210876/pexels-photo-6210876.jpeg?auto=compress&cs=tinysrgb&w=800'
    },
    {
      'title': 'Recipe 5',
      'description': 'This is a description of Recipe 3.',
      'imageUrl':
          'https://images.pexels.com/photos/5946643/pexels-photo-5946643.jpeg?auto=compress&cs=tinysrgb&w=800'
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < _recipes.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _recipes.length,
        itemBuilder: (context, index) {
          return _buildRecipeCard(_recipes[index]);
        },
      ),
    );
  }

  Widget _buildRecipeCard(Map<String, String> recipe) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: recipe['imageUrl']!,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recipe['title']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                recipe['description']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
