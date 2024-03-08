import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book_app/CreatePage.dart';
import 'package:recipe_book_app/database/recipe_entity.dart';
import 'package:recipe_book_app/bottom_nav.dart';
import 'database/recipe_dao.dart';

class ReadPage extends StatefulWidget {
  final RecipeDao dao;
  ReadPage({required this.dao, Key? key});

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
        actions: <Widget>[
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
                      // Navigate to recipe details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailsPage(recipe: recipe),
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

  RecipeDetailsPage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.recipeName),
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