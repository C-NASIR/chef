import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/recipe.dart';

class DataProvider extends ChangeNotifier {
  final database = FirebaseFirestore.instance;
  String _currentUserID = '';
  List<Recipe> _recipes = [];
  List<Recipe> _favorites = [];
  List<Recipe> _filtered = [];

  FirebaseAuth _auth;
  CollectionReference users;
  CollectionReference recipeReference;

  set currentUserID(String userID) {
    _currentUserID = userID;
  }

  Stream<User> get userAuth {
    return FirebaseAuth.instance.authStateChanges();
  }

  List<Recipe> getRecipes() {
    return [..._recipes];
  }

  List<Recipe> getFavorites() {
    return [..._favorites];
  }

  List<Recipe> get getFiltered {
    return [..._filtered];
  }

  DataProvider() {
    _auth = FirebaseAuth.instance;
    recipeReference = database.collection('recipes');
    users = database.collection('users');
  }

  /// This private methods get's the data from firebase and makes it local
  Future<void> _getAllRecipesAndSync() async {
    try {
      if (_recipes.length > 0) return;
      QuerySnapshot querySnapshot = await recipeReference.get();
      querySnapshot.docs.forEach((doc) {
        List<String> tempIngredients = [];
        List<String> tempInstructions = [];
        doc['ingredients']
            .forEach((item) => {tempIngredients.add(item.toString())});
        doc['instruction']
            .forEach((item) => {tempInstructions.add(item.toString())});

        _recipes.add(Recipe(
            id: doc.id,
            name: doc['name'],
            ingredients: tempIngredients,
            calories: doc['colories'],
            servings: doc['servings'],
            instruction: tempInstructions,
            isGlutenFree: doc['isGlutenFree'],
            isLactoseFree: doc['isLactoseFree'],
            isVegan: doc['isVegan'],
            isVegetarian: doc['isVegetarian'],
            cookTime: double.parse(doc['cookTime'].toString()),
            imageUrl: doc['imageUrl']));
      });

      //Populate the favorite array
      populateFavorite();
      populateFiltered();
      notifyListeners();
    } catch (error) {
      print('There was an  error  fetching  data, $error');
    }
  }

  /// This function filteres the data for user restrictions
  void populateFiltered() async {
    try {
      final user = await users.doc(_currentUserID).get();
      _recipes.forEach((recipe) {
        if (user['isGlutenFree'] && !recipe.isGlutenFree) return;
        if (user['isLactoseFree'] && !recipe.isLactoseFree) return;
        if (user['isVegan'] && !recipe.isVegan) return;
        if (user['isVegetarian'] && !recipe.isVegetarian) return;
        _filtered.add(recipe);
      });
    } catch (err) {
      print('There was an error filtering recipes $err');
    }
  }

  /// Search Recipes by name
  List<Recipe> getRecipeByName(String query) {
    final name = query[0].toUpperCase() + query.substring(1, query.length);
    List<Recipe> searchedRecipes = [];
    _recipes.forEach((recipe) {
      if (recipe.name.startsWith(name)) searchedRecipes.add(recipe);
    });
    return searchedRecipes;
  }

  // This methods adds content
  Future<bool> addRecipe(Recipe recipe) async {
    try {
      final recipeRef = await recipeReference.add({
        'colories': recipe.calories,
        'instruction': recipe.instruction,
        'name': recipe.name,
        'imageUrl': recipe.imageUrl,
        'ingredients': recipe.ingredients,
        'cookTime': recipe.cookTime,
        'servings': recipe.servings,
        'isGlutenFree': recipe.isGlutenFree,
        'isLactoseFree': recipe.isLactoseFree,
        'isVegan': recipe.isVegan,
        'isVegetarian': recipe.isVegetarian,
      });

      _recipes.insert(
          0,
          Recipe(
              id: recipeRef.id,
              name: recipe.name,
              ingredients: recipe.ingredients,
              calories: recipe.calories,
              servings: recipe.servings,
              instruction: recipe.instruction,
              imageUrl: recipe.imageUrl,
              cookTime: recipe.cookTime,
              isGlutenFree: recipe.isGlutenFree,
              isLactoseFree: recipe.isLactoseFree,
              isVegan: recipe.isVegan,
              isVegetarian: recipe.isVegetarian));
      populateFiltered();
      notifyListeners();
      return true;
    } catch (error) {
      return false;
    }
  }

  /// This method get's recipe by recipe Id
  Recipe getRecipeWithId(String id) {
    return _recipes.firstWhere((recipe) => recipe.id == id);
  }

  /// This methods removes recipe by taking the recipe id
  void removeRecipe({@required String recipeId}) {}

  /// This methods updates recipe by taking recipeId and new recipe
  void updateRecipe({@required String recipeId, @required Recipe newRecipe}) {}

  /// This methods creates a new user by email and password
  Future<String> createUser(String email, String password, name) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Get the new user ID
      _currentUserID = userCredential.user.uid;

      await users.doc(_currentUserID).set({
        email: userCredential.user.email,
        'name': name,
        'uid': _currentUserID,
        'favorites': [],
        'isGlutenFree': false,
        'isLactoseFree': false,
        'isVegan': false,
        'isVegetarian': false,
      });

      _getAllRecipesAndSync().then((value) => null).catchError((_) => null);
      return "Success";
    } catch (error) {
      return error.message;
    }
  }

  /// This methods signs in user by email and password
  Future<String> signIn({String email, String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _currentUserID = userCredential.user.uid;
      _getAllRecipesAndSync().then((value) => null).catchError((_) => null);
      return 'Success';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  /// This method clears the data when the user signs out
  void signOut() async {
    await _auth.signOut();
    while (_recipes.isNotEmpty) _recipes.removeAt(_recipes.length - 1);
    while (_favorites.isNotEmpty) _favorites.removeAt(_favorites.length - 1);
    _currentUserID = '';
  }

  /// This method changes user information
  Future<String> updateUserInfo({String password, String name}) async {
    try {
      if (password != null) {
        await _auth.currentUser.updatePassword(password);
      }
      if (name != null) {
        await users.doc(_currentUserID).update({"name": name});
      }
      return "Success";
    } catch (err) {
      print(err);
      return err;
    }
  }

  /// This method adds filters
  Future<Map<String, bool>> getCurrentFilteres() async {
    Map<String, bool> currentFilteres = Map();
    try {
      final doc = await users.doc(_currentUserID).get();
      currentFilteres['isGlutenFree'] = doc['isGlutenFree'];
      currentFilteres['isLactoseFree'] = doc['isLactoseFree'];
      currentFilteres['isVegan'] = doc['isVegan'];
      currentFilteres['isVegetarian'] = doc['isVegetarian'];
      notifyListeners();
      return currentFilteres;
    } catch (error) {
      print('couldn\'t get restrictions');
      return currentFilteres;
    }
  }

  /// This method adds filters
  Future<String> addFilteres(Map<String, bool> restrictions) async {
    try {
      await users.doc(_currentUserID).update({
        'isGlutenFree': restrictions['isGlutenFree'],
        'isLactoseFree': restrictions['isLactoseFree'],
        'isVegan': restrictions['isVegan'],
        'isVegetarian': restrictions['isVegetarian'],
      });
      while (_filtered.isNotEmpty) _filtered.removeAt(0);
      populateFiltered();
      notifyListeners();
      return "Success";
    } catch (error) {
      return 'couldn\'t update restrictions';
    }
  }

  /// Populate favorites array
  void populateFavorite() async {
    try {
      final doc = await users.doc(_currentUserID).get();

      doc['favorites'].forEach((favID) {
        final favRecipe = _recipes.firstWhere((recipe) => recipe.id == favID);
        _favorites.add(favRecipe);
      });
      notifyListeners();
    } catch (err) {
      print('can\'t get favorites $err');
    }
  }

  /// This methods adds favorites  to the users
  Future<String> addFavorite(String recipeId) async {
    try {
      List<dynamic> recipeList = [recipeId];
      await users
          .doc(_currentUserID)
          .update({'favorites': FieldValue.arrayUnion(recipeList)});
      _favorites.add(_recipes.firstWhere((r) => r.id == recipeId));
      notifyListeners();
      return "Success";
    } catch (error) {
      return 'can\'t add to favs $error';
    }
  }

  /// this method removes from favorite
  Future<String> removeFavorite(String recipeId) async {
    try {
      final userId = _auth.currentUser.uid;
      List<dynamic> recipeList = [recipeId];

      await users
          .doc(userId)
          .update({'favorites': FieldValue.arrayRemove(recipeList)});
      _favorites.removeWhere((recipe) => recipe.id == recipeId);
      notifyListeners();
      return "Success";
    } catch (error) {
      return 'can\'t remove from favs $error';
    }
  }
}
