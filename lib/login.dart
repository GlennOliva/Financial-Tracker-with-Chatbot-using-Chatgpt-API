import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebasecrud_1/client/Navigationbar.dart';
import 'package:flutter_firebasecrud_1/register.dart';

import 'forgotpassword.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
   bool _obscureText = true;
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  late String errormessage;
  late bool isError;

  @override
  void initState() {
    errormessage = "This is an error";
    isError = false;
    super.initState();
  }

  @override
  void dispose() {
        usernamecontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                Image.asset(
                  'images/financelogo.png',
                  height: 230,
                  width: 350,
                ),
                const Text(
                          'LOGIN FORM',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF79ECF9),
                          ),
                        ),
                        const SizedBox(height: 15,),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.white),
                  ),
                  child:  TextField(
                      controller: usernamecontroller,
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                      labelStyle: TextStyle(color: Colors.white),
                      icon: Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Icon(
                          Icons.email_sharp,
                          color: Colors.white,
                        ),
                      ),
                      border: InputBorder.none, // Remove the default underline
                    ),
                    style: const TextStyle(color: Colors.white), // Text color
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.white),
                  ),
                  child: TextField(
                    controller: passwordcontroller,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: const TextStyle(color: Colors.white),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText; // Toggle the visibility
                          });
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.remove_red_eye
                              : Icons.visibility_off, // Toggle icon
                          color: Colors.white,
                        ),
                      ),
                      icon: const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                      ),
                      border: InputBorder.none, // Remove the default underline
                    ),
                    style: const TextStyle(color: Colors.white), // Text color
                    obscureText: _obscureText, // Use the updated _obscureText value
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                           Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) =>
                        const ForgotPassword()
                        ),
                       );
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF79ECF9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(15),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF79ECF9),
                      minimumSize: const Size.fromHeight(60),
                    ),
                     onPressed: () {
                  checkLogin(
                    usernamecontroller.text,
                    passwordcontroller.text,
                  );
                },
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A909F),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                       Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) =>
                        Register()
                        ),
                       );
                      },
                      child: const Text(
                        'REGISTER',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF79ECF9),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF0A909F),
    );
  }

  var errortxtstyle = const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.red,
    letterSpacing: 1,
    fontSize: 18,
  );
  var txtstyle = const TextStyle(
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
    fontSize: 38,
  );

  Future<void> checkLogin(String username, String password) async {
    showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password,
      );

      // Log success
      print('Login successful');

      if (mounted) {
        // Check if the widget is still mounted before calling setState
        setState(() {
          isError = false; // Set to false for a successful login
          errormessage = "";
          Navigator.pop(context); // Dismiss the loading indicator on success

          // Navigate to the HomeScreen or any other screen after a successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NavigationPage()),
          );
        });
      }
    } on FirebaseAuthException catch (e) {
      print('Login failed: $e');

      if (mounted) {
        // Check if the widget is still mounted before calling setState
        setState(() {
          isError = true;
          errormessage = e.message.toString();
          Navigator.pop(context); // Dismiss the loading indicator on error
        });
      }
    }
  }


}
