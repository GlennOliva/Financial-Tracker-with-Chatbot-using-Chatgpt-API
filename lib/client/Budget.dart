import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:flutter/material.dart';
import 'package:flutter_firebasecrud_1/controller/Add_Budget.dart';
import 'package:flutter_firebasecrud_1/controller/Update_Budget.dart';
import 'package:flutter_firebasecrud_1/controller/View_Budget.dart';
import 'package:flutter_firebasecrud_1/model/budget.dart';




class Budget extends StatefulWidget {
  const Budget({Key? key});

  @override
  State<Budget> createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  Future deleteBudget(String id) async {
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


 Widget buildList(Budgets budget) => ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(budget.image),
        radius: 25,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              'Budget_name: ${budget.name}',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
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
                  'Amount: ${budget.amount}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  'Date: ${budget.time}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  'Description: ${budget.description}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
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
      MaterialPageRoute(builder: (context) => ViewBudget()),
    );
  },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => UpdateBudget(budget: budget)),
              );
            },
            icon: Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () {
              deleteBudget(budget.id);
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
        title: Text('List of Budget'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddBudget()),
              );
            },
            icon: Icon(Icons.add_circle),
          ),
        ],
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
                  final budgets = snapshot.data!;
                  return ListView(
                    children: budgets.map(buildList).toList(),
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
