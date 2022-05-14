import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/allwidgets/progressDialog.dart';
import 'package:rider_app/main.dart';
import 'package:rider_app/screens/mainscreen.dart';
import 'package:rider_app/screens/registrationScreen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  static const String idScreen = "login";
  TextEditingController emailtextEditingController = TextEditingController();

  TextEditingController passwordtextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            SizedBox(height: 35),
            Image(
              image: AssetImage("assets/images/logo.png"),
              width: 390,
              height: 250,
              alignment: Alignment.center,
            ),
            SizedBox(height: 1),
            Text(
              "Login as Rider",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontFamily: "Brand Bold"),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: 1),
                  TextField(
                    controller: emailtextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(fontSize: 14),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10)),
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: passwordtextEditingController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(fontSize: 14),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10)),
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      if (!emailtextEditingController.text.contains("@")) {
                        displayToastMessage(
                            "Email Address is not Valid", context);
                      } else if (passwordtextEditingController.text.isEmpty) {
                        displayToastMessage(
                            "Password must not be empty", context);
                      } else {
                        loginAndAuthenticateUser(context);
                      }
                    },
                    child: Container(
                      height: 50,
                      child: Center(
                          child: Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Brand Bold",
                            color: Colors.white),
                      )),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.yellow,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RegsitrationScreen.idScreen, (route) => false);
                },
                child: Text("Do not have Account ? Register Here",
                    style: TextStyle(color: Colors.black)))
          ]),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAndAuthenticateUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "Authenticating ,Please wait..");
        });
    final User? firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailtextEditingController.text,
                password: passwordtextEditingController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      usersRef.child(firebaseUser.uid);

      usersRef.child(firebaseUser.uid).once().then((event) {
        final snap = event.snapshot;
        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idScreen, (route) => false);
          displayToastMessage(
              "Congratulations,your account has been created", context);
        } else {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage(
              "No record exist for this user .Please  create new one", context);
        }
      });
    } else {
      Navigator.pop(context);
      displayToastMessage("Error Occured ,can't signin", context);
    }
  }
}
