import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:flutter/material.dart';
import 'package:flutter_firebasecrud_1/model/budget.dart';




class ViewBudget extends StatefulWidget {
  const ViewBudget({Key? key});

  @override
  State<ViewBudget> createState() => _ViewBudgetState();
}

class _ViewBudgetState extends State<ViewBudget> {
  Future deleteExpense(String id) async {
    final docUser = FirebaseFirestore.instance.collection('budget').doc(id);
    docUser.delete();
  }

 Future<String> getCurrentUserId() async {
    firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;
    return user?.uid ?? ""; // Returns an empty string if user is null
  }
Stream<List<Budgets>> readExpense(String userId) {
  return FirebaseFirestore.instance
      .collection('budget')
      .where('user_id', isEqualTo: userId)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => Budgets.fromJson(
                doc.data() as Map<String, dynamic>,
              ),
            )
            .toList(),
      );
}


 Widget buildList(Budgets budgets) =>  Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 600, 
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(budgets.image), 
                ),
              ),
            ),
            const SizedBox(height: 16),
const SizedBox(height: 16),
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
  'Budget_name: ${budgets.name}',
  overflow: TextOverflow.ellipsis,
  maxLines: 1,
  textAlign: TextAlign.justify, // Add this line
  style: const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  ),
),
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Amount: ${budgets.amount}',
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      textAlign: TextAlign.justify, // Add this line
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    Text(
      'Date: ${budgets.time}',
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      textAlign: TextAlign.justify, // Add this line
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    Text(
      'Description: ${budgets.description}',
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      textAlign: TextAlign.justify, // Add this line
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
  ],
),
            
          ],
        ),
          ]
      ),
      
      ),
    );






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VIEW BUDGET'),
        backgroundColor: Color(0xFF79ECF9),
        
      ),
      body: Column(
        children: [
          
          Expanded(
            child: StreamBuilder<List<Budgets>>(
               stream: (() async* {
    String userId = await getCurrentUserId();
    yield* readExpense(userId);
  })(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final expenses = snapshot.data!;
                  return ListView(
                    children: expenses.map(buildList).toList(),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
