import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/Pages/Login.dart';
import 'package:travel_app/Pages/bottomnav.dart';
import 'package:travel_app/services/shared_pref.dart';
import '../widget/support_widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "", name = "";
  bool _obscurePassword = true; // For toggling password visibility

  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  // Function to get the current count of "Traveler" documents
  Future<int> _getTravelerCount() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc('UserTraveler')
        .collection('UserTraveler')
        .get();
    return snapshot.docs.length;
  }

  Future<void> registration() async {
    if (password.isNotEmpty) {
      try {
        // Creating a new user with email and password
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // Send a verification email to the newly created user
        await userCredential.user!.sendEmailVerification();

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Registered Successfully. Please check your email for verification.",
            style: TextStyle(fontSize: 20.0),
          ),
        ));

        // Get the current traveler count and generate a new document ID
        int travelerCount = await _getTravelerCount();
        String travelerId =
            "Traveler ${(travelerCount + 1).toString().padLeft(2, '0')}";

        // Save user data in Firestore
        Map<String, dynamic> addUserInfo = {
          "Name": namecontroller.text,
          "Email": mailcontroller.text,
          "Id": travelerId,
        };

        // Save the user details under the specified path in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc('UserTraveler')
            .collection('UserTraveler')
            .doc(travelerId)
            .set(addUserInfo);

        // Save user details locally using SharedPreferences
        await SharedPreferenceHelper().saveUserName(namecontroller.text);
        await SharedPreferenceHelper().saveUserEmail(mailcontroller.text);
        await SharedPreferenceHelper().saveUserId(travelerId);

        // Navigate to the bottom navigation page after successful registration
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const BottomNav()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.lightGreen,
            content: Text("Password provided is too weak",
                style: TextStyle(fontSize: 20.0)),
          ));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.lightGreen,
            content: Text("An account already exists for that email.",
                style: TextStyle(fontSize: 20.0)),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("An error occurred. Please try again.",
                style: TextStyle(fontSize: 20.0)),
          ));
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter a valid password.",
            style: TextStyle(fontSize: 20.0)),
      ));
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
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 3),
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: const Text(""),
              ),
              Container(
                margin:
                const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        "images/srilogo.png",
                        width: MediaQuery.of(context).size.width / 2.4,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding:
                        const EdgeInsets.only(left: 20.0, right: 20.0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 1.6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              const SizedBox(height: 30.0),
                              const Text(
                                "Sign up to take your trip planning\nto the next level",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10.0),
                              TextFormField(
                                controller: namecontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Name';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Name",
                                  hintStyle: AppWidget.lightTextFieldStyle(),
                                  prefixIcon: const Icon(Icons.person_outline),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              TextFormField(
                                controller: mailcontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter E-mail';
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
                                controller: passwordcontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Password';
                                  }
                                  return null;
                                },
                                obscureText: _obscurePassword, // Control visibility
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: AppWidget.lightTextFieldStyle(),
                                  prefixIcon: const Icon(Icons.password_outlined),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40.0),
                              GestureDetector(
                                onTap: () async {
                                  if (_formkey.currentState!.validate()) {
                                    setState(() {
                                      email = mailcontroller.text;
                                      name = namecontroller.text;
                                      password = passwordcontroller.text;
                                    });
                                    await registration();
                                  }
                                },
                                child: Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    width: 200.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff1a5317),
                                      borderRadius:
                                      BorderRadius.circular(20.0),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "SIGN UP",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontFamily: 'Overlay',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LogIn()),
                        );
                      },
                      child: const Text(
                        "Already have an Account? Log in",
                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
