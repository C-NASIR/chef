import 'package:chef/views/filters_screen.dart';
import 'package:flutter/material.dart';
import '../providers/data_provider.dart';
import './filtered_recipes_page.dart';
import './sign_in_page.dart';
import '../widgets/MainDrawer.dart';
import 'package:provider/provider.dart';
import 'create_recipe_page.dart';
import './search_recipe_page.dart';

final Color buttons = Colors.grey[700];

class HomePage extends StatelessWidget {
  static const routeName = '/';

  Widget newCard(
      {@required Text child,
      @required String pic,
      @required BuildContext context,
      @required String route}) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            color: buttons,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 125,
                width: 125,
                decoration: BoxDecoration(
                    color: buttons,
                    image: DecorationImage(
                        image: AssetImage("assets/images/$pic.png"),
                        fit: BoxFit.cover)),
              ),
              Container(
                width: 125,
                height: 15,
                alignment: Alignment.center,
                child: child,
                color: buttons,
              )
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
    );
  }

  @required
  Widget build(BuildContext context) {
    final provider = Provider.of<DataProvider>(context);
    return Scaffold(
        // backgroundColor: Colors.green,
        appBar: AppBar(
          title: Text('Home Page'),
          actions: [
            Builder(builder: (BuildContext context) {
              return TextButton(
                child: const Text('Sign out', style: TextStyle(color: Colors.white),),
                onPressed: () async {
                  provider.signOut();
                  Navigator.of(context).pushNamed(SignInPage.routeName);
                },
              );
            })
          ],
        ),
        drawer: MainDrawer(),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: Text(
                "Recipe Maker",
                style: TextStyle(
                    backgroundColor: Colors.black54,
                    color: Colors.white,
                    fontSize: 50),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                newCard(
                    child: Text("Add Recipe",
                        style: TextStyle(color: Colors.white)),
                    context: context,
                    route: CreateRecipePage.routeName,
                    pic: 'spoon'),
                newCard(
                    child: Text("For The Chef",
                        style: TextStyle(color: Colors.white)),
                    context: context,
                    route: FiltersScreen.routeName,
                    pic: 'knife'),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                newCard(
                    child: Text("Search Recipe",
                        style: TextStyle(color: Colors.white)),
                    context: context,
                    route: SearchRecipePage.routeName,
                    pic: 'magnifier'),
                newCard(
                    child: Text("Your Recipes",
                        style: TextStyle(color: Colors.white)),
                    context: context,
                    route: FilteredRecipesPage.routeName,
                    pic: 'book'),
              ],
            ),
          ],
        ));
  }
}
