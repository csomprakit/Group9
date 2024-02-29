import 'package:flutter/material.dart';
import 'package:recipe_book_app/database/recipe_database.dart'; // Import your recipe database files
import 'router.dart';
import 'database/recipe_dao.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  RecipeDatabase database = await $FloorRecipeDatabase.databaseBuilder('recipe.db').build();
  final dao = database.recipeDao;
  runApp(MyApp(dao: dao));
}

class MyApp extends StatelessWidget {
  final RecipeDao dao;

  const MyApp({ required this.dao, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter(dao: this.dao);
    final router = appRouter.getRouter();
    return MaterialApp.router(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: router,
    );
  }
}
