import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebasecrud_1/model/expense.dart';
import 'package:intl/intl.dart';


import '../model/photo.dart';


class UpdateExpense extends StatefulWidget {
  const UpdateExpense({super.key, required this.expense});

  final Expenses expense;
  @override
  State<UpdateExpense> createState() => _UpdateExpenseState();
}

class _UpdateExpenseState extends State<UpdateExpense> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController amountcontroller = TextEditingController();
    TextEditingController timecontroller = TextEditingController();
  TextEditingController descriptioncontroller= TextEditingController();
  late String errormessage;
  late bool isError;

  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String urlFile = "";

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if(result== null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }
  

 Future selectDate() async {
  DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (selectedDate != null) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    setState(() {
      timecontroller.text = formattedDate;
    });
  }
}

 

//  Future uploadFile(context) async {
//   showLoaderDialog(context);
  
//   final path = 'images/${'${generateRandomString(5)}-${pickedFile!.name}'}';
//    final file = File(pickedFile!.path!);
//   final ref = FirebaseStorage.instance.ref().child(path);
  
//   setState(() {
//     uploadTask = ref.putFile(file);
//   });

//   final snapshot = await uploadTask!.whenComplete(() {});
//   final urlDownload = await snapshot.ref.getDownloadURL();
//   print('Download Link: $urlDownload');

//   updateDatabase(urlDownload, context);

//   //  setState(() {
//   //    urlFile = urlDownload;
//   //   uploadTask = null;
//   //   Navigator.pop(context);
//   //  });

//   // Navigator.pop(context);
 
// }

//  Future updateDatabase(urlDownload, context) async {
//   final currentUser = firebase_auth.FirebaseAuth.instance.currentUser!;
//     final userId = currentUser.uid;
//   final docUser = FirebaseFirestore.instance.collection('user').doc(userId);

//   try {
//     await docUser.update({
//       'image': urlDownload,
//     });

//     print('Document updated successfully');  // Add this line for debugging

//     showAlert(context, 'Success', 'Image Update Success');
//   } catch (error) {
//     print('Error updating database: $error');
//     showAlert(context, 'Error', 'Failed to update image');
//   }

//   setState(() {
//     pickedFile = null;
//   });
// }


String? currentImageUrl;

Future<void> fetchUserData() async {
  try {
    final expensesId = widget.expense.id;
    final docSnapshot =
        await FirebaseFirestore.instance.collection('expense').doc(expensesId).get();

    if (docSnapshot.exists) {
      final expenseData = docSnapshot.data() as Map<String, dynamic>;
      final imageUrl = expenseData['image'] as String?;

      setState(() {
        currentImageUrl = imageUrl;
        print('Current Image URL: $currentImageUrl');
      });
    }
  } catch (error) {
    print('Error fetching user data: $error');
  }
}



Widget imgExist() {
  if (urlFile.isNotEmpty) {
    return Image.network(
      urlFile,
      width: double.infinity,
      height: 250,
      fit: BoxFit.cover,
    );
  } else if (currentImageUrl != null && currentImageUrl!.isNotEmpty) {
    // Display the current image if no new image is selected
    return Image.network(
      currentImageUrl!,
      width: double.infinity,
      height: 250,
      fit: BoxFit.cover,
    );
  } else {
    return Image.asset(
      'images/no-image.png',
      fit: BoxFit.cover,
    );
  }
}



  Widget imgNotExist() => Image.asset(
    'images/no-image.png',
    fit: BoxFit.cover,
  );


 Future updateUser(String id) async {
  showLoaderDialog(context); // Show loader dialog when updating user

  try {
    // Initialize image URL variable
    String? imageUrl;

    // Check if a file is selected
    if (pickedFile != null) {
      final path = 'images/${generateRandomString(5)}-${pickedFile!.name}';
      final file = File(pickedFile!.path!);
      final ref = FirebaseStorage.instance.ref().child(path);

      // Upload file
      final snapshot = await ref.putFile(file).whenComplete(() {});
      imageUrl = await snapshot.ref.getDownloadURL();
      print('Download Link: $imageUrl');
    }

    // Prepare update data
    Map<String, dynamic> updateData = {
      'name': namecontroller.text,
      'amount': amountcontroller.text,
      'time': timecontroller.text,
      'description': descriptioncontroller.text
    };

    // Add image URL to update data if available
    if (imageUrl != null) {
      updateData['image'] = imageUrl;
    }

    // Update user document
    await FirebaseFirestore.instance.collection('expense').doc(id).update(updateData);

    // Close loader dialog
    Navigator.pop(context);

    // Reset form
    setState(() {
      pickedFile = null;
      amountcontroller.text = "";
      namecontroller.text = "";
      timecontroller.text = "";
      descriptioncontroller.text = "";
    });

    // Go back to the previous screen
    Navigator.pop(context);
  } catch (error) {
    print('Error updating user: $error');
    Navigator.pop(context); // Close loader dialog

    showAlert(context, 'Error', 'Failed to update user');
  }
}


  @override
void initState() {
  errormessage = "This is an error";
  isError = false;
  fetchUserData();
  namecontroller.text = widget.expense.name;
  amountcontroller.text = widget.expense.amount;
  timecontroller.text = widget.expense.time;
  descriptioncontroller.text = widget.expense.description;
  super.initState();
}


  @override
  void dispose() {
    super.dispose();
  }

  String generateRandomString(int len) {
    var r = Random();
    const chars = 'aasdadsdsaasdasdasdasdasdasdasdasdads232321';
    return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
  }

// showAlertDialogUpload(BuildContext  context) {
//   Widget cancelButton = TextButton(
//     onPressed: () {
//       Navigator.pop(context);
//     },
//     child: const Text('Cancel'),
//     );

//     Widget continueButton = TextButton(
//     onPressed: () {
//       Navigator.pop(context);
//       uploadFile(context);
//     },
//     child: const Text('Continuel'),
//     );

//     AlertDialog alert = AlertDialog(
//       title: const Text('Question?'),
//       content: const Text('Are you sure to upload this image?'),
//       actions: [
//         cancelButton,
//         continueButton
//       ],
//     );

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       }
//       );
// }

Widget progressBar(progress) => SizedBox(
  height: 50,
  child: Stack(
    fit: StackFit.expand,
    children: [
      LinearProgressIndicator(
        value: progress,
        backgroundColor: Colors.grey,
        color: Colors.cyan,
      ),
      Center(
        child: Text('${(100 * progress).roundToDouble()}%', style: const TextStyle(
          color: Colors.white,
        ),),
      )
    ],
  ),
);

Widget buildProgress() => StreamBuilder<TaskSnapshot>(
  stream: uploadTask?.snapshotEvents,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final data = snapshot.data!;
      double progress = data.bytesTransferred / data.totalBytes;

      return progressBar(progress);      // Return a widget here based on your progress data
    } else {
      // Return a placeholder or an empty SizedBox when there's no data
      return const SizedBox(height: 50);
    }
  },
);




showAlert(BuildContext context, String title, String msg) {
  Widget continueButton = TextButton(
    onPressed: () {
      Navigator.pop(context);
      if (title == "Success") {
        if (urlFile == '') urlFile = '-';
        Navigator.of(context).pop(Photo(image: urlFile));
      }
    },
    child: const Text('OKAY'),
  );

  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(msg),
    actions: [
      continueButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
            margin: const EdgeInsets.only(left: 7),
            child: const Text('UPDATING WAIT A SEC!'),
          )
        ],
      ),
    );

   showDialog(
  barrierDismissible: false,
  context: context,
  builder: (BuildContext context) {
    return alert;
  },
);

  }


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('UPDATE EXPENSES'),
      backgroundColor: Color(0xFF79ECF9),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
      ),
    ),
    body: ListView(
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'UPDATE EXPENSES',
                  style: txtstyle,
                ),
                GestureDetector(
                  child: Center(
                  child: (pickedFile != null || currentImageUrl != null)
                      ? imgExist()
                      : imgNotExist(),
                ),
                onTap: () {
                  selectFile();
                },
                ),

                
                const SizedBox(height: 20,),
                SizedBox(height: 15,),
                
                const SizedBox(height: 15),
                TextField(
                  controller: namecontroller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter name',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                    controller: amountcontroller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Amount',
                      prefixIcon: Icon(Icons.money),
                    ),
                  ),
                const SizedBox(height: 15),
                 TextField(
                  controller: timecontroller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Date',
                    prefixIcon: Icon(Icons.date_range),
                  ),
                  readOnly: true,
                  onTap: () {
                      selectDate();
                  },
                ),
                 const SizedBox(height: 15),
                TextField(
                  controller: descriptioncontroller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Expense Description',
                    prefixIcon: Icon(Icons.description),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Color(0xFF79ECF9),
                  ),
                  onPressed: () {
                    updateUser(widget.expense.id);
                  },
                  child: const Text('UPDATE EXPENSE' , style: TextStyle(color: Colors.black),),
                 
                ),
                 buildProgress(),
                const SizedBox(height: 15),
                (isError)
                    ? Text(
                        errormessage,
                        style: errortxtstyle,
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ],
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
    fontSize: 38,
  );
}
