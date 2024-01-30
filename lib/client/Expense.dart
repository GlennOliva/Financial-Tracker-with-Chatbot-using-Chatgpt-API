import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:flutter/material.dart';
import 'package:flutter_firebasecrud_1/controller/Add_Expense.dart';
import 'package:flutter_firebasecrud_1/controller/Update_Expense.dart';
import 'package:flutter_firebasecrud_1/controller/View_Expense.dart';
import 'package:flutter_firebasecrud_1/model/expense.dart';



class Expense extends StatefulWidget {
  const Expense({Key? key});

  @override
  State<Expense> createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  Future deleteExpense(String id) async {
    final docUser = FirebaseFirestore.instance.collection('expense').doc(id);
    docUser.delete();
  }

 Future<String> getCurrentUserId() async {
    firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;
    return user?.uid ?? ""; // Returns an empty string if user is null
  }
Stream<List<Expenses>> readExpense(String userId) {
  return FirebaseFirestore.instance
      .collection('expense')
      .where('user_id', isEqualTo: userId)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => Expenses.fromJson(
                doc.data() as Map<String, dynamic>,
              ),
            )
            .toList(),
      );
}


 Widget buildList(Expenses expense) =>  ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(expense.image),
          radius: 25,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Expense_name: ${expense.name}',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount: ${expense.amount}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    'Date: ${expense.time}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    'Description: ${expense.description}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
        dense: true,
        onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ViewExpense()),
    );
  },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => UpdateExpense(expense: expense)),
                );
              },
              icon: Icon(Icons.edit_outlined),
            ),
            IconButton(
              onPressed: () {
                deleteExpense(expense.id);
              },
              icon: Icon(Icons.delete_outline),
            ),
          ],
        ),
      );




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Expenses'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddExpense()),
              );
            },
            icon: Icon(Icons.add_circle),
          ),
        ],
      ),
      body: Column(
        children: [
          
          Expanded(
            child: StreamBuilder<List<Expenses>>(
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
