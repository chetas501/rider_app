import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/allwidgets/progressDialog.dart';
import 'package:rider_app/main.dart';
import 'package:rider_app/screens/loginscreen.dart';
import 'package:rider_app/screens/mainscreen.dart';

class RegsitrationScreen extends StatelessWidget {
  RegsitrationScreen({Key? key}) : super(key: key);

  static const String idScreen = "register";
  TextEditingController nametextEditingController = TextEditingController();
  TextEditingController emailtextEditingController = TextEditingController();
  TextEditingController phonetextEditingController = TextEditingController();
  TextEditingController passwordtextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            SizedBox(height: 15),
            Image(
              image: AssetImage("assets/images/logo.png"),
              width: 390,
              height: 250,
              alignment: Alignment.center,
            ),
            SizedBox(height: 1),
            Text(
              "Register as Rider",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontFamily: "Brand Bold"),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: 1),
                  TextField(
                    controller: nametextEditingController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(fontSize: 14),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10)),
                    style: TextStyle(fontSize: 14),
                  ),
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
                    controller: phonetextEditingController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        labelText: "Phone Number",
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
                      if (nametextEditingController.text.length < 3) {
                        displayToastMessage(
                            "Name must contain 3 characters", context);
                      } else if (!emailtextEditingController.text
                          .contains("@")) {
                        displayToastMessage(
                            "Email Address is not Valid", context);
                      } else if (phonetextEditingController.text.length != 10) {
                        displayToastMessage(
                            "Phone Number is not Valid", context);
                      } else if (passwordtextEditingController.text.length <
                          6) {
                        displayToastMessage(
                            "Password must be atleast 6 characters", context);
                      } else {
                        registerNewUser(context);
                      }
                    },
                    child: Container(
                      height: 50,
                      child: Center(
                          child: Text(
                        "Create Account",
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
                      context, LoginScreen.idScreen, (route) => false);
                },
                child: Text("Have Account ? Login Here",
                    style: TextStyle(color: Colors.black)))
          ]),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "Registering ,Please wait..");
        });
    final User? firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailtextEditingController.text,
                password: passwordtextEditingController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      usersRef.child(firebaseUser.uid);
      Map userDataMap = {
        "name": nametextEditingController.text.trim(),
        "email": emailtextEditingController.text.trim(),
        "phone": phonetextEditingController.text.trim(),
        // "password": passwordtextEditingController.text,
      };
      usersRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage(
          "Congratulations,your account has been created", context);
      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.idScreen, (route) => false);
    } else {
      Navigator.pop(context);
      displayToastMessage("New User account has not been created", context);
    }
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
