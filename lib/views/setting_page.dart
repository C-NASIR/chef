import 'package:chef/providers/data_provider.dart';
import 'package:chef/views/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final User settingsUser = _auth.currentUser;

/// User Info Enum
enum UserInfoEnum { name, password }

/// Settings Page
class SettingsPage extends StatefulWidget {
  static const routeName = '/settings-page';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final successMessage = 'Saved your change';
  String displayError;
  GlobalKey<FormState> _formKey = GlobalKey();
  final Map<UserInfoEnum, String> _newUserInfo = Map();

  /// This method submits the form
  void onSubmitted() {
    final String name = _newUserInfo[UserInfoEnum.name];
    final String password = _newUserInfo[UserInfoEnum.password];

    if ((name == null || name.isEmpty) &&
        (password == null || password.isEmpty)) {
      this.setState(() {
        displayError = "Please provider at least one value";
      });
      return;
    }

    _formKey.currentState.save();
    final provider = Provider.of<DataProvider>(context, listen: false);

    // If the both values are intered
    if ((name != null && name.isNotEmpty) &&
        (password != null && password.isNotEmpty)) {
      print('both');
      provider.updateUserInfo(name: name, password: password).then((value) {
        createSnackBar(successMessage);
        provider.signOut();
        Navigator.of(context).pushNamed(SignInPage.routeName);
      }).catchError((err) {
        createSnackBar(err);
        print(err);
      });
    }

    // Only update the name
    else if (name != null && name.isNotEmpty) {
      print("name");
      provider.updateUserInfo(name: name).then((value) {
        createSnackBar(successMessage);
      }).catchError((err) {
        createSnackBar(err);
        print(err);
      });
    }

    // Only update the password
    else if (password != null && password.isNotEmpty) {
      print("password");
      provider.updateUserInfo(password: password).then((value) {
        createSnackBar(successMessage);
        provider.signOut();
        Navigator.of(context).pushNamed(SignInPage.routeName);
      }).catchError((err) {
        createSnackBar(err);
        print(err);
      });
    }
  }

  /// This method creates the snackbar
  void createSnackBar(String title) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 2),
      content: Center(child: Text(title)),
      backgroundColor: title == successMessage ? Colors.green : Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Text(
                    displayError != null
                        ? displayError
                        : "You can only change your name and password,  not your email",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color:
                            displayError == null ? Colors.black : Colors.red),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: "New Name",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder()),
                    onChanged: (value) {
                      this.setState(() {
                        _newUserInfo[UserInfoEnum.name] = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: "New Password",
                        prefixIcon: Icon(Icons.security),
                        border: OutlineInputBorder()),
                    onChanged: (value) {
                      this.setState(() {
                        _newUserInfo[UserInfoEnum.password] = value;
                      });
                    },
                    obscureText: true,
                  ),
                ),
                ElevatedButton(
                    child: Text("Save new Changes"),
                    onPressed: () {
                      onSubmitted();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
