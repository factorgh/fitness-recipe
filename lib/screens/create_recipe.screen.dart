// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/models/user.dart';

import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/providers/user_recipes.dart';

import 'package:voltican_fitness/services/recipe_service.dart';
import 'package:voltican_fitness/widgets/reusable_button.dart';

class CreateRecipeScreen extends ConsumerStatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  _CreateRecipeScreenState createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends ConsumerState<CreateRecipeScreen> {
  final RecipeService recipeService = RecipeService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  File? _selectedImage;

  String? selectedMealPeriod;
  bool isPrivate = false;
  String? status;
  List<String> ingredientOptions = [];
  List<String> selectedIngredients = [];

  final List<String> mealPeriods = [
    'Breakfast',
    'Lunch',
    'Snack',
    'Dinner',
  ];

  final TextEditingController _mealNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _nutritionalFactsController =
      TextEditingController();
  final TextEditingController _newIngredientController =
      TextEditingController();

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;

    setState(() {
      _selectedImage = File(pickedImage.path);
    });
  }

  @override
  void dispose() {
    _mealNameController.dispose();
    _descriptionController.dispose();
    _instructionsController.dispose();
    _nutritionalFactsController.dispose();
    _newIngredientController.dispose();
    super.dispose();
  }

  Future<void> _createRecipe(User user) async {
    if (!_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please fill in all required fields.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await recipeService.createRecipe(
          context,
          Recipe(
              title: _mealNameController.text,
              ingredients: selectedIngredients,
              instructions: _instructionsController.text,
              description: _descriptionController.text,
              facts: _nutritionalFactsController.text,
              status: status!,
              period: selectedMealPeriod!,
              imageUrl: _selectedImage!.path,
              createdBy: user.id,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now()));
      setState(() {});
      await Future.delayed(Duration.zero, () {
        ref.read(userRecipesProvider.notifier).loadUserRecipes();
      });

      Navigator.pop(context);
    } catch (e) {
      // Handle any errors (e.g., show an error message)
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create A New Recipe',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Add Thumbnail Image'),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _takePicture,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _selectedImage == null
                      ? Center(
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
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Enter Recipe Name'),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _mealNameController,
                hintText: 'Enter recipe name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a recipe name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Description'),
              const SizedBox(height: 10),
              _buildMultilineTextField(
                controller: _descriptionController,
                hintText: 'Enter recipe description',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Ingredients'),
              const SizedBox(height: 10),
              ...selectedIngredients.map((ingredient) {
                return ListTile(
                  title: Text(ingredient),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedIngredients.remove(ingredient);
                        ingredientOptions.remove(ingredient);
                      });
                    },
                  ),
                );
              }),
              _buildTextField(
                controller: _newIngredientController,
                hintText: 'Add new ingredient',
                onEditingComplete: () {
                  final newIngredient = _newIngredientController.text.trim();
                  if (newIngredient.isNotEmpty &&
                      !ingredientOptions.contains(newIngredient)) {
                    setState(() {
                      ingredientOptions.add(newIngredient);
                      selectedIngredients.add(newIngredient);
                      _newIngredientController.clear();
                    });
                  }
                },
                onFieldSubmitted: (value) {
                  final newIngredient = value.trim();
                  if (newIngredient.isNotEmpty &&
                      !ingredientOptions.contains(newIngredient)) {
                    setState(() {
                      ingredientOptions.add(newIngredient);
                      selectedIngredients.add(newIngredient);
                      _newIngredientController.clear();
                    });
                  }
                },
                validator: (String? value) {
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Instructions'),
              const SizedBox(height: 10),
              _buildMultilineTextField(
                controller: _instructionsController,
                hintText: 'Add the instructions involved',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the instructions';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Nutritional Facts'),
              const SizedBox(height: 10),
              _buildMultilineTextField(
                controller: _nutritionalFactsController,
                hintText: 'Add the right nutritional facts',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the nutritional facts';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Choose a recipe category:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedMealPeriod,
                hint: const Text('Select a category'),
                isExpanded: true,
                items: mealPeriods.map((String period) {
                  return DropdownMenuItem<String>(
                    value: period,
                    child: Text(period),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMealPeriod = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a recipe category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (selectedMealPeriod != null)
                Text(
                  'Selected recipe category: $selectedMealPeriod',
                  style: const TextStyle(fontSize: 16),
                ),
              const SizedBox(height: 20),
              // Switch for recipe status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isPrivate ? 'Public' : 'Private',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Switch(
                    value: isPrivate,
                    onChanged: (value) {
                      setState(() {
                        isPrivate = value;
                        status = isPrivate ? 'public' : 'private';
                      });

                      print(status);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Reusablebutton(
                      text: "Create Recipe",
                      onPressed: () {
                        _createRecipe(user!);
                      })
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required FormFieldValidator<String> validator,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
      ),
      validator: validator,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  Widget _buildMultilineTextField({
    required TextEditingController controller,
    required String hintText,
    required FormFieldValidator<String> validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      validator: validator,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
    );
  }
}
