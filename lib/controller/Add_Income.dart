import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebasecrud_1/model/expense.dart';
import 'package:flutter_firebasecrud_1/model/income.dart';
import 'package:intl/intl.dart';


class AddIncome extends StatefulWidget {
  const AddIncome({Key? key});

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late String errorMessage;
  late bool isError;

  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String urlFile = "";

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

   Future<String> getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? ""; // Returns an empty string if user is null
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
      timeController.text = formattedDate;
    });
  }
}


 Future<void> createExpense(String userId) async {
  // Create a reference to the 'expense' collection in Firestore
  final docIncome = FirebaseFirestore.instance.collection('income').doc();

  // Check if a file is picked
  if (pickedFile != null) {
    // Upload the file to Firebase Storage
    final storageRef = FirebaseStorage.instance.ref().child('images/${docIncome.id}');
    uploadTask = storageRef.putFile(File(pickedFile!.path!));

    // Wait for the upload to complete
    await uploadTask!.whenComplete(() async {
      // Get the URL of the uploaded image
      urlFile = await storageRef.getDownloadURL();

      // Create the Expenses object
      final expense = Expenses(
        id: docIncome.id,
        userId: userId,
        name: nameController.text,
        amount: amountController.text,
        time: timeController.text,
        description: descriptionController.text,
        image: urlFile,
      );

      // Set the document in Firestore
      final json = expense.toJson();
      await docIncome.set(json);

      // Clear the controllers and navigate back
      clearControllersAndNavigateBack();

      // Show success message using SnackBar
      showSuccessSnackBar('Income successfully added!');
    });
  } else {
    // If no file is picked, create the Expenses object without the image
    final income = Incomes(
      id: docIncome.id,
      name: nameController.text,
      amount: amountController.text,
      time: timeController.text,
      description: descriptionController.text,
      image: "",
      userId: "",
    );

    // Set the document in Firestore
    final json = income.toJson();
    await docIncome.set(json);

    // Clear the controllers and navigate back
    clearControllersAndNavigateBack();

    // Show success message using SnackBar
    showSuccessSnackBar('Income successfully added!');
  }
}

// Helper method to clear controllers and navigate back
void clearControllersAndNavigateBack() {
  setState(() {
    nameController.text = "";
    amountController.text = "";
    timeController.text = "";
    descriptionController.text = "";
    urlFile = "";
    pickedFile = null;
  });

  Navigator.pop(context);
}

// Helper method to show a success SnackBar
void showSuccessSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ),
  );
}



  Widget imgExist() {
    return Image.file(
      File(pickedFile!.path!),
      width: double.infinity,
      height: 250,
      fit: BoxFit.cover,
    );
  }

  Widget imgNotExist() => Image.asset(
        'images/no-image.png',
        fit: BoxFit.cover,
      );

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            double progress = data.bytesTransferred / data.totalBytes;

            return progressBar(progress);
          } else {
            return const SizedBox(height: 50);
          }
        },
      );

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
              child: Text(
                '${(100 * progress).roundToDouble()}%',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );

  @override
  void initState() {
    errorMessage = "This is an error";
    isError = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Income'),
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
                    'ADD INCOME',
                    style: txtstyle,
                  ),
                  const SizedBox(height: 15),
                          Center(
              child: GestureDetector(
                onTap: () {
                  selectFile();
                },
                child: (pickedFile != null) ? imgExist() : imgNotExist(),
              ),
            ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter name',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Amount',
                      prefixIcon: Icon(Icons.money),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: timeController,
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
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Income Description',
                      prefixIcon: Icon(Icons.description),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Color(0xFF79ECF9),
                    ),
                    onPressed: () async {
                       String userId = await getCurrentUserId();
                      createExpense(userId);
                    },
                    child: const Text('ADD INCOME', style: TextStyle(color: Colors.black),),
                  ),
                  buildProgress(),
                  const SizedBox(height: 15),
                  (isError)
                      ? Text(
                          errorMessage,
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
