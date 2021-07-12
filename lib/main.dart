import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/data_provider.dart';

// Importing Screens to connect to routes
import './views/search_recipe_page.dart';
import './views/about_recipe_page.dart';
import 'views/recipes_page.dart';
import './views/home_page.dart';
import 'views/sign_in_page.dart';
import './views/create_account_page.dart';
import './views/create_recipe_page.dart';
import './views/favorite_recipes_page.dart';
import './views/filters_screen.dart';
import './views/filtered_recipes_page.dart';
import 'views/setting_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DataProvider(),
      child: MaterialApp(
        title: 'Recipe Maker',
        theme: ThemeData(
            appBarTheme: AppBarTheme(backgroundColor: Colors.green[500])),
        initialRoute: SignInPage.routeName,
        routes: {
          SignInPage.routeName: (_) => SignInPage(),
          HomePage.routeName: (_) => HomePage(),
          CreateRecipePage.routeName: (_) => CreateRecipePage(),
          CreateAccountPage.routeName: (_) => CreateAccountPage(),
          SearchRecipePage.routeName: (_) => SearchRecipePage(),
          RecipesPage.routeName: (_) => RecipesPage(),
          AboutRecipePage.routeName: (_) => AboutRecipePage(),
          FavoriteRecipesPage.routeName: (_) => FavoriteRecipesPage(),
          FilteredRecipesPage.routeName: (_) => FilteredRecipesPage(),
          SettingsPage.routeName: (_) => SettingsPage(),
          FiltersScreen.routeName: (_) => FiltersScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
