// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voltican_fitness/models/user.dart';
import 'package:voltican_fitness/providers/user_provider.dart';

import 'package:voltican_fitness/screens/meal_creation.dart';
import 'package:voltican_fitness/services/recipe_service.dart';
import 'package:voltican_fitness/widgets/custom_button.dart';

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
    _ingredientsController.dispose();
    _instructionsController.dispose();
    _nutritionalFactsController.dispose();
    super.dispose();
  }

  Future<void> _createRecipe(User user) async {
    if (!_formKey.currentState!.validate() ||
        _selectedImage == null ||
        selectedMealPeriod == null) {
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
        context: context,
        title: _mealNameController.text,
        description: _descriptionController.text,
        ingredients: _ingredientsController.text.split(","),
        instructions: _instructionsController.text,
        facts: _nutritionalFactsController.text,
        imageUrl: _selectedImage!,
        period: selectedMealPeriod!,
        createdBy: user,
      );

      // Optionally handle success (e.g., show a success message)
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
          style: TextStyle(fontWeight: FontWeight.w500),
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
              _buildMultilineTextField(
                controller: _ingredientsController,
                hintText: 'Which ingredients were used in this recipe?',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the ingredients';
                  }
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _isLoading
                        ? const CircularProgressIndicator()
                        : CustomButton(
                            size: 10,
                            width: 150,
                            backColor: Colors.red,
                            text: 'Save and Complete',
                            textColor: Colors.white,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await _createRecipe(user!);
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                    CustomButton(
                      size: 10,
                      width: 150,
                      backColor: Colors.red,
                      text: 'Save and Assign',
                      textColor: Colors.white,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _createRecipe(user!);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const MealCreationScreen(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      validator: validator,
    );
  }

  Widget _buildMultilineTextField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      validator: validator,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
