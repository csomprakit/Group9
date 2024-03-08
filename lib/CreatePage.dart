import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book_app/database/recipe_dao.dart';
import 'package:recipe_book_app/database/recipe_entity.dart';
import 'GalleryAccess.dart';
import 'bottom_nav.dart';

List<String> cuisines = [
  'Fusion',
  'Italian',
  'French',
  'Chinese',
  'Japanese',
  'Mexican',
  'Indian',
  'Thai',
  'Spanish',
  'Greek',
  'Middle Eastern',
  'Korean',
  'Vietnamese',
  'Brazilian',
  'American',
  'British',
  'German',
  'Ethiopian',
  'Moroccan',
  'Mediterranean',
  'Asian',
  'Eastern European',
  'Caribbean',
  'African',
  'Australian/New Zealand'
];

class AddRecipe extends StatelessWidget {
  final RecipeDao dao;

  const AddRecipe({required this.dao, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recipe'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      body: RecipeForm(dao: dao),
      bottomNavigationBar: BottomNav(),
    );
  }
}

class RecipeForm extends StatefulWidget {
  final RecipeDao dao;
  const RecipeForm({required this.dao, Key? key}) : super(key: key);

  @override
  RecipeFormState createState() => RecipeFormState();
}

class RecipeFormState extends State<RecipeForm> {
  TextEditingController foodController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imagePathController = TextEditingController();
  TextEditingController ratingController = TextEditingController();

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
  }

  void updateImagePath(String path) {
    setState(() {
      imagePathController.text = path;
    });
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text(''),
          const Text('Recipe Name'),
          TextFormField(
            key: Key("recipeName"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
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
            key: Key("description"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
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
          GalleryAccess(updateImagePath: updateImagePath),
          Text(''),
          const Text('Rating'), // New field for recipe rating
          TextFormField(
            key: Key("rating"),
            controller: ratingController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Text(''),
          ElevatedButton(
            key: Key("recordButton"),
            onPressed: () async {
              String food = foodController.text;
              String description = descriptionController.text;
              String cuisine = menuValue;
              String image = imagePathController.text;
              int rating = int.parse(ratingController.text); // Parse the rating value

              List<String> ingredientsList = [];
              for (var row in ingredientRows) {
                String ingredient = row.ingredientController.text;
                ingredientsList.add(ingredient);
              }

              String ingredients = ingredientsList.join(', ');
              final recipes = await widget.dao.listAllRecipes();
              int lastId = 0;
              if (recipes.length != 0) {
                lastId = recipes.last.id;
              }

              RecipeEntity newRecipe = RecipeEntity(
                lastId + 1,
                food,
                description,
                ingredients,
                cuisine,
                image,
                rating, // Pass the rating to the RecipeEntity constructor
              );
              widget.dao.addRecipe(newRecipe);

              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  key: Key("Alert"),
                  title: Text('Your recipe has been added'),
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
              setState(() {});
            },
            child: const Text('Record Food'),
          )
        ],
      ),
    );
  }
}

class IngredientRow extends StatefulWidget {
  final onRemove;
  final ingredientController;
  final quantityValue;
  final fractionValue;
  final unitValue;

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
            key: Key('ingredientField'),
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
