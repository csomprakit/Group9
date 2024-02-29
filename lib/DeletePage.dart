import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book_app/database/recipe_dao.dart';
import 'package:recipe_book_app/database/recipe_entity.dart';

class DeleteRecipePage extends StatelessWidget {
  final RecipeDao dao;

  const DeleteRecipePage({required this.dao, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Recipe'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      body: RecipeList(dao: dao),
    );
  }
}

class RecipeList extends StatefulWidget {
  final RecipeDao dao;

  const RecipeList({required this.dao, Key? key}) : super(key: key);

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  late Future<List<RecipeEntity>> _recipesFuture;

  @override
  void initState() {
    super.initState();
    _recipesFuture = widget.dao.listAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RecipeEntity>>(
      future: _recipesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return Center(child: Text('No recipes found.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              RecipeEntity recipe = snapshot.data![index];
              return ListTile(
                title: Text(recipe.recipeName),
                subtitle: Text(recipe.category),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteRecipe(recipe);
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<void> _deleteRecipe(RecipeEntity recipe) async {
    await widget.dao.deleteRecipe(recipe);
    setState(() {
      _recipesFuture = widget.dao.listAllEvents();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Recipe "${recipe.recipeName}" deleted.'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
