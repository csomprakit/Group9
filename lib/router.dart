import 'package:go_router/go_router.dart';
import 'package:recipe_book_app/CreatePage.dart';
import 'package:recipe_book_app/ReadPage.dart';
import 'package:recipe_book_app/SettingsPage.dart';
import 'package:recipe_book_app/contacts.dart';
import 'HomePage.dart';
import 'database/recipe_database.dart';
import 'database/recipe_dao.dart';

class AppRouter
{
  late final RecipeDatabase database;
  final RecipeDao dao;

  AppRouter({required this.dao});

  GoRouter getRouter()
  {
    return GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, routerState)
          {
            return HomePage(dao: this.dao);
          },
        ),
        GoRoute(
          path: '/search',
          builder: (context, routerState)
          {
            return ReadPage(dao: this.dao);
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
              return AddRecipe(dao: this.dao);
            }
        ),
        GoRoute(
            path: '/contacts',
            builder: (context, routerState)
            {
              return importContacts();
            }
        )
      ],
    );
  }

}

