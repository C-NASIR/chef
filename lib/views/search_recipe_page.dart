import 'package:chef/models/recipe.dart';
import 'package:chef/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// In class folders
import './about_recipe_page.dart';
import '../widgets/recipe_item.dart';

class SearchRecipePage extends StatefulWidget {
  static const routeName = '/searchRecipePage';

  @override
  _SearchRecipePageState createState() => _SearchRecipePageState();
}

class _SearchRecipePageState extends State<SearchRecipePage> {
  List<Recipe> recipes = [];
  DataProvider provider;
  bool firstRun = true;

  @override
  void didChangeDependencies() {
    if (firstRun) {
      final pro = Provider.of<DataProvider>(context);
      final favs = pro.getFavorites();
      this.setState(() {
        firstRun = false;
        provider = pro;
        recipes = favs;
      });
    }
    super.didChangeDependencies();
  }

  selectedRecipe(BuildContext ctx, String id) {
    Navigator.of(ctx).pushNamed(AboutRecipePage.routeName, arguments: id);
  }

  void searchChanged(String query) {
    this.setState(() {
      recipes = provider.getRecipeByName(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Recipes'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 20), hintText: 'Search'),
              onChanged: searchChanged,
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
            ),
          ),
          SizedBox(height: 40),
          Row(children: [
            SizedBox(width: 20),
            Text("Your Top Results")
          ]),
          SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () => selectedRecipe(context, recipes[i].id),
                        child: RecipeItem(
                            title: recipes[i].name,
                            imageUrl: recipes[i].imageUrl),
                      ),
                      SizedBox(height: 20)
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }
}
