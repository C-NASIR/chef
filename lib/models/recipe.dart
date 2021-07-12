import 'package:flutter/material.dart';

class Recipe {
  final String id;
  String name;
  List<String> ingredients;
  int calories;
  List<String> instruction;
  String imageUrl;
  int servings;
  double cookTime;
  bool isGlutenFree;
  bool isLactoseFree;
  bool isVegan;
  bool isVegetarian;

  Recipe({
    this.id,
    @required this.name,
    @required this.ingredients,
    @required this.calories,
    @required this.servings,
    @required this.instruction,
    @required this.imageUrl,
    @required this.isGlutenFree, this.isLactoseFree,
    @required this.isVegan, this.isVegetarian,
    @required this.cookTime,
  });
}
