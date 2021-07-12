import 'package:chef/models/recipe.dart';
import 'package:chef/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutRecipePage extends StatefulWidget {
  static const routeName = '/about-recipe';

  @override
  _AboutRecipePageState createState() => _AboutRecipePageState();
}

class _AboutRecipePageState extends State<AboutRecipePage> {
  bool isVaforite = false;
  bool firstRun = true;
  String recipeId;
  DataProvider provider;

  @override
  void didChangeDependencies() {
    if (firstRun) {
      provider = Provider.of<DataProvider>(context, listen: false);
      final favs = provider.getFavorites();
      recipeId = ModalRoute.of(context).settings.arguments as String;
      final favRecipe =
          favs.where((recipe) => recipe.id == recipeId).length > 0;
      if (favRecipe) {
        this.setState(() {
          isVaforite = true;
          firstRun = false;
        });
      }
    }
    super.didChangeDependencies();
  }

  bool isFavorite(String recipeId) {
    return isVaforite;
  }

  void toggleFavorite(String recipeId) {
    if (isVaforite) {
      provider.removeFavorite(recipeId).then((value) {
        this.setState(() {
          isVaforite = false;
        });
      }).catchError((error) {
        print(error);
      });
    } else {
      provider.addFavorite(recipeId).then((value) {
        this.setState(() {
          isVaforite = true;
        });
      }).catchError((error) {
        print(error);
      });
    }
  }

  Widget buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget buildContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      height: 150,
      width: 300,
      child: child,
    );
  }

  Widget buildItem(String firstValue, String secondValue) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            firstValue,
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
          ),
          Text(
            secondValue,
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }

  Widget buildRestriction(String title, IconData icon){
  return Container(
      width: 300,
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
          ),
          Icon(icon, color: icon == Icons.done ? Colors.green : Colors.red, size: 30,)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Recipe recipe;
    if (recipeId != null) recipe = provider.getRecipeWithId(recipeId);
    return Scaffold(
      appBar: AppBar(
        title: Text('${recipeId == null ? "" : recipe.name}'),
      ),
      body: recipe == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 300,
                    width: double.infinity,
                    child: Image.network(
                      recipe.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  buildItem("The Time", recipe.cookTime.toString()),
                  buildItem("Serving", recipe.servings.toString()),
                  buildItem("Calories", recipe.calories.toString()),
                  buildRestriction("Gluten Free", recipe.isGlutenFree
                  ? Icons.done 
                  : Icons.cancel_rounded),
                  buildRestriction("Lactose Free", recipe.isLactoseFree
                  ? Icons.done 
                  : Icons.cancel_rounded),
                  buildRestriction("Vegetarian", recipe.isVegetarian
                  ? Icons.done 
                  : Icons.cancel_rounded),
                  buildRestriction("Vegan", recipe.isVegan
                  ? Icons.done 
                  : Icons.cancel_rounded),
                  buildSectionTitle(context, 'Ingredients'),
                  buildContainer(
                    ListView.builder(
                      itemBuilder: (ctx, index) => Card(
                        color: Theme.of(context).accentColor,
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            child: Text(recipe.ingredients[index])),
                      ),
                      itemCount: recipe.ingredients.length,
                    ),
                  ),
                  buildSectionTitle(context, 'Steps'),
                  buildContainer(
                    ListView.builder(
                      itemBuilder: (ctx, index) => Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              child: Text('# ${(index + 1)}'),
                            ),
                            title: Text(
                              recipe.instruction[index],
                            ),
                          ),
                          Divider()
                        ],
                      ),
                      itemCount: recipe.instruction.length,
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          isFavorite(recipeId) ? Icons.star : Icons.star_border,
        ),
        onPressed: () => toggleFavorite(recipeId),
      ),
    );
  }
}
