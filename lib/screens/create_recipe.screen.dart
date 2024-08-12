import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voltican_fitness/models/user.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/screens/assign_recipe_screen.dart';
import 'package:voltican_fitness/services/recipe_service.dart';
import 'package:voltican_fitness/widgets/custom_button.dart';

class CreateRecipeScreen extends ConsumerStatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  _CreateRecipeScreenState createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends ConsumerState<CreateRecipeScreen> {
  final RecipeService recipeService = RecipeService();

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

  void _createRecipe(User user) {
    if (_selectedImage == null ||
        _mealNameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _ingredientsController.text.isEmpty ||
        _instructionsController.text.isEmpty ||
        _nutritionalFactsController.text.isEmpty ||
        selectedMealPeriod == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please fill in all required fields.'),
            actions: [
              TextButton(
                onPressed: () {},
                child: const Text('Ok'),
              )
            ],
          );
        },
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });
    recipeService.createRecipe(
      context: context,
      title: _mealNameController.text,
      description: _descriptionController.text,
      ingredients: _ingredientsController.text.split(","),
      instructions: _instructionsController.text,
      facts: _nutritionalFactsController.text,
      imageUrl: _selectedImage!,

      period: selectedMealPeriod!,
      createdBy: user, // Access the user ID here
    );
    setState(() {
      _isLoading = false;
    });
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
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Description'),
            const SizedBox(height: 10),
            _buildMultilineTextField(
              controller: _descriptionController,
              hintText: 'Enter recipe description',
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Ingredients'),
            const SizedBox(height: 10),
            _buildMultilineTextField(
              controller: _ingredientsController,
              hintText: 'Which ingredients were used in this recipe?',
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Instructions'),
            const SizedBox(height: 10),
            _buildMultilineTextField(
              controller: _instructionsController,
              hintText: 'Add the instructions involved',
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Nutritional Facts'),
            const SizedBox(height: 10),
            _buildMultilineTextField(
              controller: _nutritionalFactsController,
              hintText: 'Add the right nutritional facts',
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose a recipe period:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedMealPeriod,
              hint: const Text('Select a meal period'),
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
            ),
            const SizedBox(height: 20),
            if (selectedMealPeriod != null)
              Text(
                'Selected recipe period: $selectedMealPeriod',
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
                          onPressed: () {
                            _createRecipe(user!);
                            Navigator.of(context).pop();
                          },
                        ),
                  CustomButton(
                    size: 10,
                    width: 150,
                    backColor: Colors.red,
                    text: 'Save and Assign',
                    textColor: Colors.white,
                    onPressed: () {
                      _createRecipe(user!);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AssignRecipeScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.blueGrey[800],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black38),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildMultilineTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black38),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: TextFormField(
          controller: controller,
          maxLines: null,
          expands: true,
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
          ),
        ),
      ),
    );
  }
}
