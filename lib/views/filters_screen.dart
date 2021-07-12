import 'package:chef/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/FilterScreen';

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  final successMessage = 'Filters SuccessFully  Saved';
  final errorMessage = "Sorry, we couldn’t save filters, try again";
  Map<String, bool> restrictions = {
    'isGlutenFree': false,
    'isLactoseFree': false,
    'isVegan': false,
    'isVegetarian': false
  };
  bool firstRun = true;

  Widget _buildSwitchListTile(
    String title,
    String description,
    bool currentValue,
    Function updateValue,
  ) {
    return SwitchListTile(
      title: Text(title),
      value: currentValue,
      subtitle: Text(
        description,
      ),
      onChanged: updateValue,
    );
  }

  @override
  void didChangeDependencies() {
    if (firstRun) {
      Provider.of<DataProvider>(context, listen: false)
          .getCurrentFilteres()
          .then((filters) {
        if (filters.isNotEmpty) {
          setState(() {
            restrictions = filters;
          });
        }
      }).catchError((err) {
        print('couln\'t get the restrictions $err');
      });
      this.setState(() {
        firstRun = false;
      });
    }
    super.didChangeDependencies();
  }

  void createSnackBar(String title) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 2),
      content: Center(child: Text(title)),
      backgroundColor: title == successMessage ? Colors.green : Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void addFilters(DataProvider provider) async {
    try {
      await provider.addFilteres(restrictions);
      createSnackBar(successMessage);
    } catch (err) {
      createSnackBar(errorMessage);
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Filters'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              addFilters(provider);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'Adjust your meal selection.',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildSwitchListTile(
                  'Gluten-free',
                  'Only include gluten-free meals.',
                  restrictions['isGlutenFree'],
                  (value) {
                    setState(() {
                      restrictions['isGlutenFree'] = value;
                    });
                  },
                ),
                _buildSwitchListTile(
                  'Lactose-free',
                  'Only include lactose-free meals.',
                  restrictions['isLactoseFree'],
                  (value) {
                    setState(() {
                      restrictions['isLactoseFree'] = value;
                    });
                  },
                ),
                _buildSwitchListTile(
                  'Vegetarian',
                  'Only include vegetarian meals.',
                  restrictions['isVegetarian'],
                  (value) {
                    setState(() {
                      restrictions['isVegetarian'] = value;
                    });
                  },
                ),
                _buildSwitchListTile(
                  'Vegan',
                  'Only include vegan meals.',
                  restrictions['isVegan'],
                  (value) {
                    setState(() {
                      restrictions['isVegan'] = value;
                    });
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
