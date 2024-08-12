// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/providers/recipe_provider.dart';
import 'package:voltican_fitness/providers/user_provider.dart';

import 'package:voltican_fitness/widgets/custom_button.dart';

class EditRecipeScreen extends ConsumerStatefulWidget {
  const EditRecipeScreen({super.key, required this.recipe});
  final Recipe recipe;

  @override
  ConsumerState<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends ConsumerState<EditRecipeScreen> {
  File? _selectedImage;
  String? selectedMealPeriod;
  bool _isLoading = false; // Track the loading state

  final List<String> mealPeriods = [
    'Breakfast',
    'Lunch',
    'Snack',
    'Dinner',
  ];

  final TextEditingController _mealNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _nutritionalFactsController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _mealNameController.text = widget.recipe.title;
    _descriptionController.text = widget.recipe.description;
    _ingredientsController.text =
        widget.recipe.ingredients.join(","); // Convert list to string
    _instructionsController.text = widget.recipe.instructions;
    _nutritionalFactsController.text = widget.recipe.facts;
    // Initialize the image if URL exists
    if (widget.recipe.imageUrl.isNotEmpty) {
      _selectedImage = null; // We don't need to use File for network images
    }
    selectedMealPeriod = widget.recipe.period;
  }

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });
  }

  void _saveRecipe() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    try {
      final user = ref.watch(userProvider);
      final updatedRecipe = Recipe(
        id: widget.recipe.id,
        title: _mealNameController.text,
        description: _descriptionController.text,
        ingredients: _ingredientsController.text.split(","),
        instructions: _instructionsController.text,
        facts: _nutritionalFactsController.text,
        imageUrl: _selectedImage != null
            ? await _uploadImage()
            : widget.recipe.imageUrl,
        updatedAt: DateTime.now(),
        createdAt: widget.recipe.createdAt, // Use the existing creation date
        createdBy: user!.id,
        period: selectedMealPeriod!,
      );

      await ref
          .read(savedRecipesProvider.notifier)
          .updateRecipe(widget.recipe.id as String, updatedRecipe);

      Navigator.of(context).pop();
    } catch (e) {
      // Handle errors if needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save recipe: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Set loading state to false
      });
    }
  }

  Future<String> _uploadImage() async {
    // Implement image upload logic here
    return 'uploaded_image_url';
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_selectedImage != null) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 200,
        ),
      );
    } else if (widget.recipe.imageUrl.isNotEmpty) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          widget.recipe.imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 200,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(
                Icons.error,
                color: Colors.red,
                size: 50,
              ),
            );
          },
        ),
      );
    } else {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 40,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              'Upload Image',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Recipe',
            style: TextStyle(fontWeight: FontWeight.w500)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Thumbnail Image',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _takePicture,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: content,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Enter Recipe Name',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black38),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  controller: _mealNameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter recipe name',
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black38),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: _descriptionController,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter recipe description',
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black38),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: _ingredientsController,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Which ingredients were used in this recipe?',
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Instructions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black38),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: _instructionsController,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter the instructions for the recipe',
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Nutritional Facts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black38),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: _nutritionalFactsController,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter nutritional facts',
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Meal Period',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black38),
              ),
              child: DropdownButton<String>(
                value: selectedMealPeriod,
                items: mealPeriods.map((period) {
                  return DropdownMenuItem(
                    value: period,
                    child: Text(period),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMealPeriod = value;
                  });
                },
                underline: Container(),
                isExpanded: true,
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
                    width: double.infinity,
                    size: 15,
                    backColor: Colors.red,
                    textColor: Colors.white,
                    text: 'Save Recipe',
                    onPressed: _saveRecipe,
                  ),
          ],
        ),
      ),
    );
  }
}
