import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_firebasecrud_1/controller/Add_Income.dart';
import 'package:flutter_firebasecrud_1/controller/Update_Income.dart';
import 'package:flutter_firebasecrud_1/controller/View_Income.dart';


import '../model/income.dart';

class Income extends StatefulWidget {
  const Income({Key? key});

  @override
  State<Income> createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  Future deleteIncome(String id) async {
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


 Widget buildList(Incomes incomes) => ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(incomes.image),
        radius: 25,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              'Income_name: ${incomes.name}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                  'Amount: ${incomes.amount}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  'Date: ${incomes.time}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  'Description: ${incomes.description}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
      dense: true,
      onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ViewIncome()),
    );
  },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => UpdateIncome(income: incomes)),
              );
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () {
              deleteIncome(incomes.id);
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Income'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddIncome()),
              );
            },
            icon: const Icon(Icons.add_circle),
          ),
        ],
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
                  final incomes = snapshot.data!;
                  return ListView(
                    children: incomes.map(buildList).toList(),
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
