// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:fit_cibus/models/recipe.dart';
import 'package:fit_cibus/models/user.dart';
import 'package:fit_cibus/providers/saved_recipe_provider.dart';
import 'package:fit_cibus/providers/user_provider.dart';
import 'package:fit_cibus/providers/user_recipes.dart';
import 'package:fit_cibus/services/recipe_service.dart';
import 'package:fit_cibus/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EditRecipeScreen extends ConsumerStatefulWidget {
  final Recipe recipe;
  const EditRecipeScreen({super.key, required this.recipe});

  @override
  ConsumerState<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends ConsumerState<EditRecipeScreen> {
  File? _selectedImage;
  String? selectedMealPeriod;
  bool _isLoading = false;
  String? cldImage;
  String? status;
  bool isPrivate = false;

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
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _nutritionalFactsController =
      TextEditingController();

  final RecipeService recipeService = RecipeService();

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);

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
          cldImage!,
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
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25)),
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
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter description',
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
              controller: _ingredientsController,
              hintText: 'Add new ingredient',
              onEditingComplete: () {
                final newIngredient = _ingredientsController.text.trim();
                if (newIngredient.isNotEmpty &&
                    !ingredientOptions.contains(newIngredient)) {
                  setState(() {
                    ingredientOptions.add(newIngredient);
                    selectedIngredients.add(newIngredient);
                    _ingredientsController.clear();
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
                    _ingredientsController.clear();
                  });
                }
              },
              validator: (String? value) {
                return null;
              },
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
                child: TextFormField(
                  controller: _instructionsController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter instructions',
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
                child: TextFormField(
                  controller: _nutritionalFactsController,
                  maxLines: null,
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
            DropdownButton<String>(
              value: selectedMealPeriod,
              items: mealPeriods.map((period) {
                return DropdownMenuItem<String>(
                  value: period,
                  child: Text(period),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMealPeriod = value;
                });
              },
              hint: const Text('Select meal period'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Private',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: isPrivate,
                  onChanged: (value) {
                    setState(() {
                      isPrivate = value;
                      status = isPrivate ? 'private' : 'public';
                    });

                    print(status);
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
                    textColor: Colors.white,
                    size: 15,
                    backColor: Colors.redAccent,
                    width: double.infinity,
                    text: widget.recipe.id != null
                        ? 'Save Recipe'
                        : 'Create Recipe',
                    onPressed: () => user!.id == widget.recipe.createdBy
                        ? _saveRecipe()
                        : _createRecipe(user)),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _mealNameController.text = widget.recipe.title;
    _descriptionController.text = widget.recipe.description;
    selectedIngredients = widget.recipe.ingredients; // Convert list to string
    _instructionsController.text = widget.recipe.instructions;
    _nutritionalFactsController.text = widget.recipe.facts;
    if (widget.recipe.imageUrl.isNotEmpty) {
      cldImage = widget.recipe.imageUrl;
    }
    selectedMealPeriod = widget.recipe.period;
    status = widget.recipe.status;

    isPrivate = (status == 'private');
    setState(() {});
    print('---------------------recipe status--------------');
    print(isPrivate);
    print(widget.recipe.status);
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

  Future<void> _createRecipe(User user) async {
    setState(() {
      _isLoading = true;
    });

    print('-------------------Make recipe own Details---------------');
    if (_selectedImage != null) {
      print('--------${_selectedImage!.path}');
    } else {
      print('--------No image selected');
    }

    try {
      await recipeService.createRecipe(
        context,
        Recipe(
          title: _mealNameController.text,
          ingredients: selectedIngredients,
          instructions: _instructionsController.text,
          description: _descriptionController.text,
          status: status!,
          facts: _nutritionalFactsController.text,
          period: selectedMealPeriod!,
          imageUrl: _selectedImage != null
              ? _selectedImage!.path
              : widget.recipe.imageUrl,
          createdBy: user.id,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      ref
          .read(savedRecipesProvider.notifier)
          .removeSavedRecipe(user.id, widget.recipe.id!);

      await ref.read(userRecipesProvider.notifier).loadUserRecipes();
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create recipe: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveRecipe() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = ref.read(userProvider);
      final updatedRecipe = Recipe(
        id: widget.recipe.id,
        title: _mealNameController.text,
        description: _descriptionController.text,
        ingredients: selectedIngredients,
        instructions: _instructionsController.text,
        facts: _nutritionalFactsController.text,
        status: status!,
        imageUrl: _selectedImage != null
            ? await _uploadImage()
            : widget.recipe.imageUrl,
        updatedAt: DateTime.now(),
        createdAt: widget.recipe.createdAt,
        createdBy: user!.id,
        period: selectedMealPeriod!,
      );

      await ref
          .read(userRecipesProvider.notifier)
          .updateRecipe(widget.recipe.id as String, updatedRecipe);

      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save recipe: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _takePicture() async {
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

  Future<String> _uploadImage() async {
    final cloudinary = CloudinaryPublic('daq5dsnqy', 'jqx9kpde');
    CloudinaryResponse uploadResult = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(_selectedImage!.path, folder: 'voltican_fitness'),
    );
    final image = uploadResult.secureUrl;
    print('Image URL: $image');

    return image; // Return the actual image URL
  }
}



// -----------------------------------------------------
