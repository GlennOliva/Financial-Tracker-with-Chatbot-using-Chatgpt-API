import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
   TextEditingController usernamecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A909F),
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                Image.asset(
                  'images/financelogo.png',
                  height: 200,
                  width: 250,
                ),
                const Text(
                        'FORGOTPASS FORM',
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
                    child:  TextFormField(
                      controller: usernamecontroller,
                      decoration: const InputDecoration(
                        errorStyle: TextStyle(fontSize: 15),
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
                      style: const TextStyle(color: Colors.white), 
                      validator: (value) {
            if (value == null || !value.contains('@')) {
              return "Enter a valid email address";
            }
            return null;
          },// Text color
                    ),
                  ),
    
                Container(
                  margin: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF79ECF9),
                      minimumSize: const Size.fromHeight(60),
                    ),
                    onPressed: resetPassword,
                    child: const Text(
                      'FORGOT PASSWORD',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A909F),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF0A909F),
    );

    
  }

  Future resetPassword() async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(color: Color(0xFF79ECF9)),
    ),
  );

  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: usernamecontroller.text.trim(),
    );

    // Close the loading dialog and show a success message dialog
    Navigator.of(context).pop();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Password Reset Email Sent'),
        content: const Text('A password reset email has been sent to your email address.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the success message dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );

    // Navigate to the login page
    // Navigate to the login page
Navigator.of(context).pushReplacement(
  MaterialPageRoute(
    builder: (context) => Login(),
  ),
);

  } on FirebaseAuthException {
    // Close the loading dialog

    // Handle other error codes and show an error message
    await showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Password Reset Email Sent'),
    content: const Text('A password reset email has been sent to your email address.'),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(); // Close the success message dialog
          
          // Show a message informing the user to log in again
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Please log in again with your updated password.'),
            ),
          );

          // Navigate to the login page
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Login(),
            ),
          );
        },
        child: const Text('OK'),
      ),
    ],
  ),
);
  } finally {
    
  }
}
}