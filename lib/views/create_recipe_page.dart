import '../models/recipe.dart';
import '../providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateRecipePage extends StatefulWidget {
  static const routeName = '/createRecipePage';

  @override
  _CreateRecipePageState createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final successMessage = 'Recipe SuccessFully  Saved';
  final errorMessage = "Sorry, we couldn’t save recipe, try again";
  final _coloriesFocusNode = FocusNode();
  final _servingsFocusNode = FocusNode();
  final _timeFocusNode = FocusNode();
  final _ingredientsFocusNode = FocusNode();
  final _instructionsFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  Recipe _editedRecipes = Recipe(
      name: '',
      ingredients: [],
      calories: 0,
      servings: 0,
      instruction: [],
      imageUrl: "https://via.placeholder.com/300",
      isGlutenFree: false,
      isLactoseFree: false,
      cookTime: 0,
      isVegan: false,
      isVegetarian: false);

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _coloriesFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    _servingsFocusNode.dispose();
    _timeFocusNode.dispose();
    _ingredientsFocusNode.dispose();
    _instructionsFocusNode.dispose();
    super.dispose();
  }

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

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm(BuildContext context) async {
    final isValid = _form.currentState.validate();

    // If the form is invalid just return
    if (!isValid) return;

    if (_editedRecipes.name.isEmpty) return;

    dissMissKeybaord(context);
    _form.currentState.save();
    final result = await Provider.of<DataProvider>(context, listen: false)
        .addRecipe(_editedRecipes);
    if (result) {
      createSnackBar(successMessage);
    } else {
      createSnackBar(errorMessage);
    }

    _form.currentState.reset();
    _imageUrlController.text = "";
  }

  void createSnackBar(String title) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 2),
      content: Center(child: Text(title)),
      backgroundColor: title == successMessage ? Colors.green : Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void dissMissKeybaord(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recipe'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveForm(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) return "Name is required";
                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_coloriesFocusNode);
                },
                onChanged: (value) {
                  print('name is $value');
                  this.setState(() {
                    _editedRecipes.name = value;
                  });
                },
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Calories (How many colories)'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) return "Calories is required";
                  return null;
                },
                keyboardType: TextInputType.number,
                focusNode: _coloriesFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_ingredientsFocusNode);
                },
                onChanged: (value) {
                  this.setState(() {
                    _editedRecipes.calories = int.parse(value);
                  });
                },
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Servings (How many servings)'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) return "Servings  is required";
                  return null;
                },
                keyboardType: TextInputType.number,
                focusNode: _servingsFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_ingredientsFocusNode);
                },
                onChanged: (value) {
                  this.setState(() {
                    _editedRecipes.servings = int.parse(value);
                  });
                },
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Time (30 min like 0.5)'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) return "Time is required";
                  return null;
                },
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                focusNode: _timeFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_ingredientsFocusNode);
                },
                onChanged: (value) {
                  this.setState(() {
                    _editedRecipes.cookTime = double.parse(value);
                  });
                },
              ),
              _buildSwitchListTile(
                'Gluten-free',
                'Only include gluten-free meals.',
                _editedRecipes.isGlutenFree,
                (value) {
                  setState(() {
                    _editedRecipes.isGlutenFree = value;
                  });
                },
              ),
              _buildSwitchListTile(
                'Lactose-free',
                'Only include lactose-free meals.',
                _editedRecipes.isLactoseFree,
                (value) {
                  setState(() {
                    _editedRecipes.isLactoseFree = value;
                  });
                },
              ),
              _buildSwitchListTile(
                'Vegetarian',
                'Only include vegetarian meals.',
                _editedRecipes.isVegetarian,
                (value) {
                  setState(() {
                    _editedRecipes.isVegetarian = value;
                  });
                },
              ),
              _buildSwitchListTile(
                'Vegan',
                'Only include vegan meals.',
                _editedRecipes.isVegan,
                (value) {
                  setState(() {
                    _editedRecipes.isVegan = value;
                  });
                },
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Ingredients (1 per line)'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value.isEmpty) return "Ingredients are required";
                  return null;
                },
                focusNode: _ingredientsFocusNode,
                onChanged: (value) {
                  this.setState(() {
                    _editedRecipes.ingredients = value.split("\n");
                  });
                },
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Instructions (1 per line)'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value.isEmpty) return "Instructions are required";
                  return null;
                },
                focusNode: _instructionsFocusNode,
                onChanged: (value) {
                  this.setState(() {
                    _editedRecipes.instruction = value.split("\n");
                  });
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm(context);
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          this.setState(() {
                            _editedRecipes.imageUrl = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
