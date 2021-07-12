import 'package:chef/providers/data_provider.dart';
import 'package:chef/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'create_account_page.dart';

class SignInPage extends StatefulWidget {
  static const routeName = '/SignInPage';
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SignInPage> {
  GlobalKey<FormState> _formkey = GlobalKey();
  String email = 'holahip903@cnxingye.com';
  String password = 'SuperSecretPassword!2';
  bool firstTime = true;

  @override
  void initState() {
    Provider.of<DataProvider>(context, listen: false)
        .userAuth
        .listen((User user) {
      if (user == null) {
        print('user is signed out');
      }
    });
    super.initState();
  }

  // This methods tries to sign in the user
  void signIn(BuildContext ctx) async {
    if (!_formkey.currentState.validate()) return;
    _formkey.currentState.save();

    try {
      final answer = await Provider.of<DataProvider>(ctx, listen: false)
          .signIn(email: email, password: password);

      if (answer == "Success") {
        print("You signed in my friend");
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      } else {
        print('There was error signin in $answer');
      }
    } catch (err) {
      print('can\'t sign in the user $err');
      createSnackBar("Sorry, something went wrong, try again");
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
                "Recipe Maker",
                style: TextStyle(
                    backgroundColor: Colors.black54,
                    color: Colors.white,
                    fontSize: 50),
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
                      Container(
                        child: Text(
                          "Sign in",
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              hintText: email, border: OutlineInputBorder()),
                          validator: (value) {
                            if (value.isEmpty) return "Email is Required";
                            return null;
                          },
                          onChanged: (text) {
                            email = text;
                          }),
                      SizedBox(height: 10),
                      TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: password,
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty) return "Password is Required";
                            return null;
                          },
                          onChanged: (text) {
                            password = text;
                          }),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text('Sign In'),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blueGrey[700])),
                          onPressed: () {
                            signIn(context);
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () => Navigator.of(context)
                            .pushReplacementNamed(CreateAccountPage.routeName),
                        child: Text("Create Account / Forget Account"),
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
