
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebasecrud_1/client/Budget.dart';
import 'package:flutter_firebasecrud_1/client/Chat_support.dart';
import 'package:flutter_firebasecrud_1/client/Expense.dart';
import 'package:flutter_firebasecrud_1/client/Income.dart';
import 'package:flutter_firebasecrud_1/client/Home.dart';
import 'package:flutter_firebasecrud_1/client/Update_Profile.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_firebasecrud_1/login.dart';
import '../model/user.dart';
import 'Investment.dart';



class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key }) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;

  Stream<User?> readUser(String uid) {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? User.fromJson(doc.data()!) : null);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;

    List<Widget> _pages = [
      const Home(),
      Expense(), // Pass the expense parameter here
      const Income(),
      const Budget(),
      const Investment(),
      const ChatSupport()
    ];

    return Scaffold(
  appBar: AppBar(
    title: const Text('GAMCO PERSONAL FINANCE'),
    backgroundColor: Color(0xFF79ECF9),
  ),
  drawer: Drawer(
    child: StreamBuilder<User?>(
      stream: currentUser != null ? readUser(currentUser.uid) : null,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong ${snapshot.error}');
        } else if (snapshot.hasData) {
          final user = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 250,
                  width: 400,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color(0xFF79ECF9),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded( // Wrap with Expanded
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(user.image),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'email: ${user.email}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                                maxLines: 2,
                              ),
                            
                              Text(
                                'full_name: ${user.name}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    _navigateTo(0);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.money_off), // Icon representing expense
                  title: const Text('Expenses'),
                  onTap: () {
                    _navigateTo(1);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.money),
                  title: const Text('Income'),
                  onTap: () {
                    _navigateTo(2);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.savings),
                  title: const Text('Budget'),
                  onTap: () {
                    _navigateTo(3);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.trending_up),
                  title: const Text('Investment'),
                  onTap: () {
                    _navigateTo(4);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.chat_bubble),
                  title: const Text('Chat Support'),
                  onTap: () {
                    _navigateTo(5);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Update Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateProfile(user: user),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    firebase_auth.FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => Login()),
);

                  },
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ),
  ),
  body: _pages[_currentIndex],
);


  }

  void _navigateTo(int index) {
    setState(() {
      _currentIndex = index;
      Navigator.pop(context); // Close the drawer
    });
  }
}
