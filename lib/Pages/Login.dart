import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/Pages/Signup.dart';
import 'package:travel_app/Pages/bottomnav.dart';
import 'package:travel_app/Pages/forgotpassword.dart';
import 'package:travel_app/widget/support_widget.dart';

import '../services/database.dart';
import '../services/shared_pref.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = "", password = "";
  bool _obscureText = true;

  final _formkey = GlobalKey<FormState>();

  TextEditingController useremailcontroller = TextEditingController();
  TextEditingController userpasswordcontroller = TextEditingController();

  userLogin() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? currentUser = userCredential.user;

      if (currentUser != null) {
        var userSnapshot = await DatabaseMethods().getUserDetailsByEmail(email);

        if (userSnapshot.docs.isNotEmpty) {
          var userData = userSnapshot.docs.first.data() as Map<String, dynamic>;

          await SharedPreferenceHelper().saveUserName(userData['Name']);
          await SharedPreferenceHelper().saveUserEmail(userData['Email']);
          await SharedPreferenceHelper().saveUserId(userData['Id']);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNav()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("User data not found. Please try again."),
          ));
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No User Found for that email", style: TextStyle(fontSize: 18.0, color: Colors.black)),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Wrong Password Provided by User", style: TextStyle(fontSize: 18.0, color: Colors.black)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xff1a5317),
                          Color(0xff1a5317),
                        ]
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))),
                child: const Text(""),
              ),
              Container(
                margin: const EdgeInsets.only(top: 80.0, left: 20.0, right: 20.0),
                child: Column(children: [
                  Center(child: Image.asset("images/srilogo.png", width: MediaQuery.of(context).size.width / 2.4, fit: BoxFit.cover)),
                  const SizedBox(height: 40.0),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.9,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: Form(
                        key: _formkey,
                        child: Column(children: [
                          const SizedBox(height: 30.0),
                          const Text(
                            "Log in to take your trip planning\nto the next level",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: useremailcontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Email",
                              hintStyle: AppWidget.lightTextFieldStyle(),
                              prefixIcon: const Icon(Icons.email_outlined),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: userpasswordcontroller,
                            obscureText: _obscureText,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Password';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: AppWidget.lightTextFieldStyle(),
                              prefixIcon: const Icon(Icons.password_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPassword()));
                            },
                            child: Container(
                              alignment: Alignment.topRight,
                              child: Text("Forgot Password", style: AppWidget.lightTextFieldStyle()),
                            ),
                          ),
                          const SizedBox(height: 40.0),
                          GestureDetector(
                            onTap: () {
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  email = useremailcontroller.text;
                                  password = userpasswordcontroller.text;
                                });
                                userLogin();
                              }
                            },
                            child: Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                width: 200.0,
                                decoration: BoxDecoration(color: const Color(0xff1a5317), borderRadius: BorderRadius.circular(20.0)),
                                child: const Center(
                                  child: Text(
                                    "LOG IN",
                                    style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'Overlay', fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp()));
                    },
                    child: const Text(
                      "Don’t have an account yet? Sign up",
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
