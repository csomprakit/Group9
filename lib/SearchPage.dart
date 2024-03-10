import 'package:flutter/material.dart';

import 'database/recipe_entity.dart';

class SearchPage extends StatefulWidget {
  final dao;
  SearchPage({required this.dao});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchQuery = '';

  void _handleSearch(String query) async {
    setState(() async {
      _searchQuery = query;
      var recipes = await widget.dao.listAllRecipes();

    });
    try {
      List<RecipeEntity> recipes = await widget.dao.listAllRecipes();

      setState(() {
        recipes = recipes.where((recipe) {
          return recipe.recipeName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              recipe.ingredients.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();
      });
    } catch (error) {
      print('Error fetching recipes: $error');
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
          ],
        ),
      ),
    );
  }
}
