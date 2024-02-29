import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book_app/database/recipe_dao.dart';
import 'package:recipe_book_app/database/recipe_entity.dart';

import 'bottom_nav.dart';
import 'database/recipe_database.dart';

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
  final RecipeDatabase database;

  const AddRecipe({required this.database, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Add Recipe'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }
          ),
            backgroundColor: Colors.orangeAccent
        ),
        body: RecipeForm(database: database),
        bottomNavigationBar: BottomNav(),
      )
    );
  }
}

class RecipeForm extends StatefulWidget {
  final RecipeDatabase database;
  const RecipeForm({required this.database, Key? key}) : super(key: key);
  @override
  RecipeFormState createState() => RecipeFormState();
}

class RecipeFormState extends State<RecipeForm> {
  late RecipeDao dao;
  TextEditingController foodController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String selectedFood = '';
  String menuValue = '';
  bool usingDropdown = false;
  late String recipeName = '';
  final String description = '';
  final String ingredients = '';
  final String category = '';
  List<IngredientRow> ingredientRows = [];

  @override
  void initState() {
    super.initState();
    dao = widget.database.recipeDao;
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
              items: cuisines.map((unit) => DropdownMenuItem<String>(
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
          ElevatedButton(
            key: Key("recordButton"),
            onPressed: () async{
              String food = foodController.text;
              String description = descriptionController.text;
              String cuisine = menuValue;

              List<String> ingredientsList = [];
              for (var row in ingredientRows) {
                String ingredient = row.ingredientController.text;
                ingredientsList.add(ingredient);
              }

              String ingredients = ingredientsList.join(', ');
              final recipes = await dao.listAllEvents();
              int lastId = 0;
              if (recipes.isNotEmpty) {
                lastId = recipes.last.id;
              }

              RecipeEntity newRecipe = RecipeEntity(
                lastId + 1,
                food,
                description,
                ingredients,
                cuisine,
              );
              await dao.addRecipe(newRecipe);
              List<RecipeEntity> StoredRecipes = await dao.listAllEvents();
              RecipeEntity addedRecipe = StoredRecipes[StoredRecipes.length - 1];
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  key: Key("Alert"),
                  title: Text('Your ${addedRecipe.recipeName} recipe has been added'),
                  content: Text('Description: ${addedRecipe.description}\nIngredients: ${addedRecipe.ingredients}\nCuisine: ${addedRecipe.category}'),
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

class IngredientRow extends StatefulWidget{
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
        /*const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<int>(
            decoration: InputDecoration(labelText: 'Quantity'),
            value: quantityValue,
            items: List.generate(300, (index) {
              return DropdownMenuItem<int>(
                value: index + 1,
                child: Text('${index + 1}'),
              );
            }),
            onChanged: (value) {
              setState(() {
                quantityValue = value;
              });
            },
          ),
        ),
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Fraction'),
            value: fractionValue,
            items: ['1/4', '1/3', '1/2', '2/3', '3/4']
                .map((quantity) => DropdownMenuItem<String>(
              value: quantity,
              child: Text(quantity),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                fractionValue = value;
              });
            }
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Unit'),
            value: unitValue,
            items: ['Tbsp', 'tsp', 'cup', 'oz', 'g', 'mL', 'L']
                .map((unit) => DropdownMenuItem<String>(
              value: unit,
              child: Text(unit),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                unitValue = value;
              });
            }
          ),
        ),*/
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: onRemove,
        ),
      ],
    );
  }
}
