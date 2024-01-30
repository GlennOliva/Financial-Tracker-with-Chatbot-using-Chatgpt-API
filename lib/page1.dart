
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebasecrud_1/alldata.dart';
import 'package:flutter_firebasecrud_1/model/user.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();

}

class _Page1State extends State<Page1> {
  final user = firebase_auth.FirebaseAuth.instance.currentUser!;

  getUserData(String uid) {
  var collection = FirebaseFirestore.instance.collection('user');
  return StreamBuilder(
    stream: collection.doc(uid).snapshots(),
    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text('Error = ${snapshot.error}');
      } else if (snapshot.hasData && snapshot.data!.exists) {
        final data = snapshot.data!.data() as Map<String, dynamic>;
        final user = User(
          name: data['name'],
          email: data['email'],
          id: data['id'],
          image: '',
        );
        return BuildUserInfo(user);
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}


  Widget BuildUserInfo(User user) => Column(
    children: [
      const Text('From firestore'),
      const SizedBox(height: 15,),
      Text(user.id , style: txtstyle,),
      const SizedBox(height: 15,),
      Text(user.name, style: txtstyle,),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase CRUD'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Succesful conenct to firebase'),
            const SizedBox(height: 15,),
            Text('Signed as: ' ),
            Text(user.email!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            getUserData(user.uid),
            ElevatedButton(
              onPressed: () {
                  firebase_auth.FirebaseAuth.instance.signOut();
              },
              child: const Text('SIGN OUT')
              ),
              SizedBox(height: 15,),
              ElevatedButton(
                onPressed: () {
                   Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AllData(),
      ));
                },
                child: Text('Click here to go All data'))

          ],
        ),
      ),
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
    fontSize: 18,
  );
  
}