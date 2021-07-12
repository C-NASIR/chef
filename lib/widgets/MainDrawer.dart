import 'package:chef/views/setting_page.dart';
import 'package:flutter/material.dart';
import '../views/favorite_recipes_page.dart';
import '../views/recipes_page.dart';

class MainDrawer extends StatelessWidget {
  Widget makeLink(IconData icon, String title, Function function) {
    return InkWell(
      onTap: function,
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(color: Color.fromRGBO(178, 254, 229, 1)),
        child: Row(children: [
          SizedBox(
            width: 10,
          ),
          Icon(icon, color: Colors.purple, size: 30),
          SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Column(
            children: [
              makeLink(Icons.star, "Your Favorites", () {
                Navigator.of(context).pushNamed(FavoriteRecipesPage.routeName);
              }),
              Divider(height: 3),
              makeLink(Icons.food_bank_rounded, "All recipes", () {
                Navigator.of(context).pushNamed(RecipesPage.routeName);
              }),
              Divider(height: 3),
              makeLink(Icons.settings, "Settings", () {
                Navigator.of(context).pushNamed(SettingsPage.routeName);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
