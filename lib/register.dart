import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // Add the "as firebase_auth" alias
import 'package:flutter/material.dart';
import 'package:flutter_firebasecrud_1/authenticator.dart';
import 'package:flutter_firebasecrud_1/login.dart';
import 'package:flutter_firebasecrud_1/model/user.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool _obscureText = true;
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
    super.dispose();
  }


 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A909F),
      ),
      body: Form(
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'images/financelogo.png',
                    height: 200,
                    width: 350,
                  ),
                  const Text(
                          'REGISTER FORM',
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
                      controller: namecontroller,
                      decoration: const InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(color: Colors.white),
                        icon: Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Icon(
                            Icons.people_alt_sharp,
                            color: Colors.white,
                          ),
                        ),
                        border: InputBorder.none, // Remove the default underline
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
            if (value == null || value.length < 6) {
              return "Name must be at least 6 characters";
            }
            return null;
          }, // Text color
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
                      controller: emailcontroller,
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
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.white),
                    ),
                    child: TextFormField(
                      controller: passwordcontroller,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 15),
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
                      obscureText: _obscureText,
                      validator: (value) {
            if (value == null || value.length < 8) {
              return "Password must be at least 8 characters";
            }
            return null;
          }, // Use the updated _obscureText value
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.all(15),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF79ECF9),
                        minimumSize: const Size.fromHeight(60),
                      ),
                      onPressed: RegisterUser,
                      child: const Text(
                        'REGISTER',
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
                           Login()),
                          
                         );
                        },
                        child: const Text(
                          'LOGIN',
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

   Future createUser() async {
    final currentUser = firebase_auth.FirebaseAuth.instance.currentUser!;
    final userId = currentUser.uid;
    final docUser = FirebaseFirestore.instance.collection('user').doc(userId);

    final user = User(
      name: namecontroller.text,
      email: emailcontroller.text,
      id: userId,
      image: '',
    );

    final json = user.toJson();
    await docUser.set(json);

    goToAuthenticator();
  }

  Future<void> RegisterUser() async {
    try {
      await firebase_auth.FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );
       createUser();

      setState(() {
        isError = false;
        errormessage = "";
      });


    } on firebase_auth.FirebaseAuthException catch (e) {
      print(e);

      setState(() {
        isError = true;
        errormessage = e.message.toString();
      });

    }
  }




  goToAuthenticator() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Authenticator(),
      ),
    );
  }
}
