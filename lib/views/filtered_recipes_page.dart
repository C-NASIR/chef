import 'package:chef/providers/data_provider.dart';
import 'package:chef/views/about_recipe_page.dart';
import 'package:chef/widgets/recipe_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilteredRecipesPage extends StatelessWidget {
  static const routeName = '/filtered_Recipe_Page';

  selectedRecipe(BuildContext ctx, String id) {
    Navigator.of(ctx).pushNamed(AboutRecipePage.routeName, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    final recipes = Provider.of<DataProvider>(context).getFiltered;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Recipes'),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context,i) {
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
    );
  }
}
