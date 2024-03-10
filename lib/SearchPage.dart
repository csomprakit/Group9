import 'package:flutter/material.dart';
import 'package:recipe_book_app/database/recipe_dao.dart';
import 'package:recipe_book_app/database/recipe_entity.dart';
import 'package:recipe_book_app/UpdatePage.dart';
import 'package:recipe_book_app/DeletePage.dart';

class SearchPage extends StatefulWidget {
  final dao;
  SearchPage({required this.dao});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchQuery = '';
  List<RecipeEntity> recipes = []; // Initialize recipes list

  void _handleSearch(String query) async {
    setState(() {
      _searchQuery = query;
    });

    try {
      final allRecipes = await widget.dao.listAllRecipes();

      setState(() {
        recipes = allRecipes.where((recipe) {
          return recipe.recipeName.toLowerCase().contains(
              _searchQuery.toLowerCase()) ||
              recipe.ingredients.toLowerCase().contains(
                  _searchQuery.toLowerCase());
        }).toList();
      });

      print('Filtered recipes:');
      for (var recipe in recipes) {
        print('Recipe Name: ${recipe.recipeName}');
        print('Ingredients: ${recipe.ingredients}');
        print('------------------------------------');
      }
    } catch (error) {
      print('Error filtering recipes: $error');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Search: $_searchQuery',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: _handleSearch,
              decoration: InputDecoration(
                labelText: 'Enter search',
                border: OutlineInputBorder(),
              ),
            ),
            Expanded(
              child: recipes.isNotEmpty
                  ? ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailsPage(recipe: recipe, dao: widget.dao),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(recipe.recipeName),
                      subtitle: Text(recipe.ingredients),
                    ),
                  );
                },
              )
                  : Center(
                child: Text('No recipes found for "$_searchQuery"'),
              ),
            ),

          ],
        ),
      ),
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
            Image(
              image: AssetImage(recipe.imagePath),
              width: 250,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('Error loading image: $error');
                return Placeholder(
                  fallbackWidth: 250,
                  fallbackHeight: 250,
                );
              },
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
