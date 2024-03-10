import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book_app/database/recipe_dao.dart';
import 'package:recipe_book_app/database/recipe_entity.dart';
import 'package:recipe_book_app/CreatePage.dart';
import 'package:recipe_book_app/UpdatePage.dart';
import 'package:recipe_book_app/DeletePage.dart';
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

class ReadPage extends StatefulWidget {
  final RecipeDao dao;
  ReadPage({required this.dao, Key? key});

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  String _selectedCuisine = 'All'; // Default selected cuisine
  String _selectedSorting = 'Alphabetical'; // Default selected sorting

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                _selectedCuisine = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return cuisines // Add your cuisines here
                  .map<PopupMenuEntry<String>>((String value) {
                return PopupMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList();
            },
          ),
          DropdownButton<String>(
            value: _selectedSorting,
            icon: Icon(Icons.sort),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedSorting = newValue;
                });
              }
            },
            items: <String>['Alphabetical', 'Rating'] // Add your sorting options here
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              GoRouter.of(context).push('/addRecipe');
            },
          )
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<RecipeEntity>>(
          future: widget.dao.listAllRecipes(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No recipes found.'));
            } else {
              List<RecipeEntity> recipes = snapshot.data!;

              // Apply filtering based on selected cuisine
              if (_selectedCuisine != 'All') {
                recipes = recipes.where((recipe) => recipe.category == _selectedCuisine).toList();
              }

              // Apply sorting based on selected option
              if (_selectedSorting == 'Alphabetical') {
                recipes.sort((a, b) => a.recipeName.compareTo(b.recipeName));
              } else if (_selectedSorting == 'Rating') {
                recipes.sort((a, b) => a.rating.compareTo(b.rating));
              }

              return ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  RecipeEntity recipe = recipes[index];
                  return ListTile(
                    title: Text(recipe.recipeName),
                    subtitle: Text(recipe.description),
                    leading: CircleAvatar(
                      backgroundImage: FileImage(File(recipe.imagePath)),
                      radius: 30,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailsPage(recipe: recipe, dao: widget.dao),
                        ),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}

class RecipeDetailsPage extends StatelessWidget {
  final RecipeEntity recipe;
  final RecipeDao dao;

  RecipeDetailsPage({required this.recipe, required this.dao});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.recipeName),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateRecipe(dao: dao, recipe: recipe),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeleteRecipePage(dao: dao),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(
              File(recipe.imagePath),
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),
            Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(recipe.description),
            SizedBox(height: 16.0),
            Text(
              'Ingredients:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(recipe.ingredients),
            SizedBox(height: 16.0),
            Text(
              'Rating: ${recipe.rating}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
