import 'package:go_router/go_router.dart';
import 'package:recipe_book_app/CreatePage.dart';
import 'package:recipe_book_app/ReadPage.dart';
import 'package:recipe_book_app/SettingsPage.dart';
import 'HomePage.dart';
import 'database/recipe_database.dart';

class AppRouter
{
  late final RecipeDatabase database;
  AppRouter({required this.database});

  GoRouter getRouter()
  {
    return GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, routerState)
          {
            return HomePage(database: this.database);
          },
        ),
        GoRoute(
          path: '/search',
          builder: (context, routerState)
          {
            return ReadPage(database: database);
          },
        ),
        GoRoute(
          path: '/settings',
          builder: (context, routerState)
          {
            return SettingsPage();
          },
        ),
        GoRoute(
          path: '/addRecipe',
          builder: (context, routerState)
            {
              return AddRecipe(database: database);
            }
        )
      ],
    );
  }

}

