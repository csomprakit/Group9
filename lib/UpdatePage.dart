import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book_app/database/recipe_dao.dart';
import 'package:recipe_book_app/database/recipe_entity.dart';
import 'package:recipe_book_app/CreatePage.dart';
import 'GalleryAccess.dart';

class UpdateRecipe extends StatelessWidget {
  final RecipeDao dao;
  final RecipeEntity recipe;

  const UpdateRecipe({required this.dao, required this.recipe, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Recipe'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      body: UpdateRecipeForm(dao: dao, recipe: recipe),
    );
  }
}

class UpdateRecipeForm extends StatefulWidget {
  final RecipeDao dao;
  final RecipeEntity recipe;

  const UpdateRecipeForm({required this.dao, required this.recipe, Key? key})
      : super(key: key);

  @override
  _UpdateRecipeFormState createState() => _UpdateRecipeFormState();
}

class _UpdateRecipeFormState extends State<UpdateRecipeForm> {
  TextEditingController foodController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imagePathController = TextEditingController();

  String selectedFood = '';
  String menuValue = '';
  bool usingDropdown = false;
  late String recipeName = '';
  final String description = '';
  final String ingredients = '';
  final String category = '';
  final String imagePath = '';
  List<IngredientRow> ingredientRows = [];

  @override
  void initState() {
    super.initState();
    foodController.text = widget.recipe.recipeName;
    descriptionController.text = widget.recipe.description;
    imagePathController.text = widget.recipe.imagePath;
    // Add initialization for other fields if needed
  }

  void addIngredientRow() {
    TextEditingController ingredientController = TextEditingController();
    int? quantityValue;
    String? fractionValue;
    String? unitValue;

    setState(() {
      ingredientRows.add(IngredientRow(
        onRemove: () {
          setState(() {
            ingredientRows.removeLast();
          });
        },
        ingredientController: ingredientController,
        quantityValue: quantityValue,
        fractionValue: fractionValue,
        unitValue: unitValue,
      ));
    });
  }

  void updateImagePath(String path) {
    setState(() {
      imagePathController.text = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text(''),
          const Text('Recipe Name'),
          TextFormField(
            controller: foodController,
            onChanged: (value) {
              setState(() {
                selectedFood = '';
                usingDropdown = false;
              });
            },
          ),
          Text(''),
          const Text('Description'),
          TextFormField(
            controller: descriptionController,
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Text("Ingredients"),
              ...ingredientRows,
              ElevatedButton(
                onPressed: addIngredientRow,
                child: const Icon(Icons.add),
              ),
            ],
          ),
          Text(''),
          Text("Cuisine"),
          Container(
            height: 50,
            child: DropdownButtonFormField<String>(
              items: cuisines
                  .map((unit) => DropdownMenuItem<String>(
                value: unit,
                child: Text(unit),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  menuValue = value!;
                });
              },
            ),
          ),
          Text(''),
          GalleryAccess(updateImagePath: updateImagePath),
          Text(''),
          ElevatedButton(
            onPressed: () async {
              // Implement update logic here
              String food = foodController.text;
              String description = descriptionController.text;
              String cuisine = menuValue;
              String image = imagePathController.text;

              List<String> ingredientsList = [];
              for (var row in ingredientRows) {
                String ingredient = row.ingredientController.text;
                ingredientsList.add(ingredient);
              }

              String ingredients = ingredientsList.join(', ');

              RecipeEntity updatedRecipe = RecipeEntity(
                widget.recipe.id,
                food,
                description,
                ingredients,
                cuisine,
                image,
                widget.recipe.rating, // Retain the previous rating
              );

              // Update the recipe
              await widget.dao.updateRecipe(updatedRecipe);

              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Your recipe has been updated'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        GoRouter.of(context).push('/home');
                      },
                      child: Text('Ok'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Update Recipe'),
          )
        ],
      ),
    );
  }
}

class IngredientRow extends StatefulWidget {
  final Function()? onRemove;
  final TextEditingController ingredientController;
  final int? quantityValue;
  final String? fractionValue;
  final String? unitValue;

  const IngredientRow({
    Key? key,
    this.onRemove,
    required this.ingredientController,
    required this.quantityValue,
    required this.fractionValue,
    required this.unitValue,
  }) : super(key: key);

  @override
  IngredientRowState createState() => IngredientRowState();
}

class IngredientRowState extends State<IngredientRow> {
  late Function()? onRemove;
  late TextEditingController ingredientController;
  late int? quantityValue;
  late String? fractionValue;
  late String? unitValue;

  @override
  void initState() {
    onRemove = widget.onRemove;
    ingredientController = widget.ingredientController;
    quantityValue = widget.quantityValue;
    fractionValue = widget.fractionValue;
    unitValue = widget.unitValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: ingredientController,
            decoration: InputDecoration(labelText: 'Ingredient'),
          ),
        ),
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: onRemove,
        ),
      ],
    );
  }
}
