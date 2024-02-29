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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddRecipe(dao: widget.dao),
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
          child: FutureBuilder<List<RecipeEntity>>(
              future: widget.dao.listAllEvents(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No recipes found.');
                } else {
                  List<RecipeEntity> recipeEvents = snapshot.data!
                      .map((entity) => RecipeEntity(
                      entity.id,
                      entity.recipeName,
                      entity.description,
                      entity.ingredients,
                      entity.category,
                      entity.imagePath))
                      .toList();
                  return Column(
                    children: recipeEvents
                        .map((event) => Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(event.recipeName),
                            subtitle: Text(event.description),
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(
                                  event.imagePath ?? 'lib/assets/carbonara.jpg'),
                            ),
                            onTap: () {
                              // Navigate to recipe details page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RecipeDetailsPage(recipe: event)),
                              );
                            },
                          ),
                        ),
                      ],
                    ))
                        .toList(),
                  );
                }
              })),
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
          ],
        ),
      ),
    );
  }
}
