import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:flutter/material.dart';
import 'package:flutter_firebasecrud_1/model/income.dart';



class ViewIncome extends StatefulWidget {
  const ViewIncome({Key? key});

  @override
  State<ViewIncome> createState() => _ViewIncomeState();
}

class _ViewIncomeState extends State<ViewIncome> {
  Future deleteExpense(String id) async {
    final docUser = FirebaseFirestore.instance.collection('income').doc(id);
    docUser.delete();
  }

 Future<String> getCurrentUserId() async {
    firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;
    return user?.uid ?? ""; // Returns an empty string if user is null
  }
Stream<List<Incomes>> readExpense(String userId) {
  return FirebaseFirestore.instance
      .collection('income')
      .where('user_id', isEqualTo: userId)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => Incomes.fromJson(
                doc.data() as Map<String, dynamic>,
              ),
            )
            .toList(),
      );
}


 Widget buildList(Incomes incomes) =>  Card(
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
                  image: NetworkImage(incomes.image), 
                ),
              ),
            ),
            const SizedBox(height: 16),
const SizedBox(height: 16),
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
  'Income_name: ${incomes.name}',
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
      'Amount: ${incomes.amount}',
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      textAlign: TextAlign.justify, // Add this line
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    Text(
      'Date: ${incomes.time}',
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      textAlign: TextAlign.justify, // Add this line
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    Text(
      'Description: ${incomes.description}',
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
        title: const Text('VIEW INCOME'),
        backgroundColor: Color(0xFF79ECF9),
        
      ),
      body: Column(
        children: [
          
          Expanded(
            child: StreamBuilder<List<Incomes>>(
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
