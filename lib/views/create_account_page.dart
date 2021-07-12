//import 'dart:js';
import 'package:chef/providers/data_provider.dart';
import 'package:chef/views/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';

class CreateAccountPage extends StatefulWidget {
  static const routeName = "Create_Account_page";
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  GlobalKey<FormState> _formkey = GlobalKey();
  String email = '';
  String name = '';
  String password = '';

  void register(BuildContext context) async {
    if (!_formkey.currentState.validate()) return;

    try {
      final result = await Provider.of<DataProvider>(context, listen: false)
          .createUser(email, password, name);
      if (result != 'Success') createSnackBar(result);
      if (result == "Success") {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      }
    } catch (err) {
      print('can\'t create a user $err');
      createSnackBar("Sorry, something wen't wrong. try again");
    }
  }

  void createSnackBar(String title) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 2),
      content: Text(title),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/background.jpeg"),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: Text(
                "Create Account",
                style: TextStyle(
                    backgroundColor: Colors.black54,
                    color: Colors.white,
                    fontSize: 30),
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(10),
                width: 350,
                decoration: BoxDecoration(color: Colors.black12),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: 'Name', border: OutlineInputBorder()),
                          validator: (value) {
                            if (value.isEmpty) return "Name is required";
                            return null;
                          },
                          onChanged: (text) {
                            name = text.trim();
                          }),
                      SizedBox(height: 10),
                      TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value.isEmpty) return "Email is required";
                            return null;
                          },
                          onChanged: (text) {
                            email = text.trim();
                          }),
                      SizedBox(height: 20),
                      TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty) return "Password is required";
                            return null;
                          },
                          onChanged: (text) {
                            password = text.trim();
                          }),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text('Create Account'),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blueGrey[700])),
                          onPressed: () => register(context),
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () => Navigator.of(context)
                            .pushReplacementNamed(SignInPage.routeName),
                        child: Text("sign in with  email and password"),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
