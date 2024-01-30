import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_firebasecrud_1/controller/Add_Investment.dart';
import 'package:flutter_firebasecrud_1/controller/Update_Investment.dart';
import 'package:flutter_firebasecrud_1/controller/View_Investment.dart';
import 'package:flutter_firebasecrud_1/model/investment.dart';



class Investment extends StatefulWidget {
  const Investment({Key? key});

  @override
  State<Investment> createState() => _InvestmentState();
}

class _InvestmentState extends State<Investment> {
  Future deleteInvestment(String id) async {
    final docUser = FirebaseFirestore.instance.collection('investment').doc(id);
    docUser.delete();
  }

 Future<String> getCurrentUserId() async {
    firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;
    return user?.uid ?? ""; // Returns an empty string if user is null
  }
Stream<List<Investments>> readExpense(String userId) {
  return FirebaseFirestore.instance
      .collection('investment')
      .where('user_id', isEqualTo: userId)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => Investments.fromJson(
                doc.data() as Map<String, dynamic>,
              ),
            )
            .toList(),
      );
}


 Widget buildList(Investments investments) => ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(investments.image),
        radius: 25,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              'Investment_name: ${investments.name}',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
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
                  'Amount: ${investments.amount}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  'Date: ${investments.time}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  'Description: ${investments.description}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
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
      MaterialPageRoute(builder: (context) => ViewInvestment()),
    );
  },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => UpdateInvestment(investment: investments)),
              );
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () {
              deleteInvestment(investments.id);
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
        title: const Text('List of Investment'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddInvestment()),
              );
            },
            icon: const Icon(Icons.add_circle),
          ),
        ],
      ),
      body: Column(
        children: [
          
          Expanded(
            child: StreamBuilder<List<Investments>>(
               stream: (() async* {
    String userId = await getCurrentUserId();
    yield* readExpense(userId);
  })(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final investments = snapshot.data!;
                  return ListView(
                    children: investments.map(buildList).toList(),
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
