import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebasecrud_1/add_data.dart';
import 'package:flutter_firebasecrud_1/update_data.dart';
import 'package:flutter_firebasecrud_1/update_photo.dart';

import 'model/user.dart';

class AllData extends StatefulWidget {
  const AllData({super.key});

  @override
  State<AllData> createState() => _AllDataState();
}

class _AllDataState extends State<AllData> {

  Future deleteUser(String id) async {
      final docUser = FirebaseFirestore.instance.collection('user').doc(id);
      docUser.delete();
  }

  
  Stream<List<User>> readUsers(){
      return FirebaseFirestore.instance.collection('user').snapshots().map((snapshot) =>
       snapshot.docs.map((doc) => User.fromJson(
        doc.data(),
       )).toList(),
        );
  }
  

  Widget buildList(User user) => ListTile(
    leading: CircleAvatar(
      backgroundImage: NetworkImage(user.image),
      radius: 25,
    ),
    title: Text(user.name),
    subtitle: Text(user.email),
    dense: true,
    onTap: () {

    },
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
        onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>  UpdateData(user: user))
            );
        },
         icon: Icon(Icons.edit_outlined),
        ),
         IconButton(
        onPressed: () {
            deleteUser(user.id);
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
        title: Text('List of data'),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddData())
            );
          },
          icon: Icon(Icons.add_circle)),
          IconButton(
            onPressed: () {
 Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const UpdatePhoto())
            );
            },
            icon: Icon(Icons.upload)),
        ],
      ),
           
      body: StreamBuilder<List<User>>(
        stream: readUsers(),
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            return Text('Something went wrong ${snapshot.error}');
          }
          else if(snapshot.hasData){
            final user = snapshot.data!;
            return ListView(
              children: user.map(buildList).toList(),
            );
          }
          else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      },
      ),
      );
  }
}