import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Map<String, double>> getTotalExpenses() async {
    final user = FirebaseAuth.instance.currentUser;
    Map<String, double> expensesByDate = {};

    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('expense')
          .where('user_id', isEqualTo: user.uid)
          .get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (QueryDocumentSnapshot document in documents) {
        String date = document['time']; // Replace 'time' with the actual field name
        double amount = double.parse(document['amount'].toString());

        expensesByDate[date] = (expensesByDate[date] ?? 0.0) + amount;
      }
    }

    return expensesByDate;
  }


  Future<Map<String, double>> getTotalIncome() async {
    final user = FirebaseAuth.instance.currentUser;
    Map<String, double> incomeByDate = {};

    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('income')
          .where('user_id', isEqualTo: user.uid)
          .get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (QueryDocumentSnapshot document in documents) {
        String date = document['time']; // Replace 'time' with the actual field name
        double amount = double.parse(document['amount'].toString());

        incomeByDate[date] = (incomeByDate[date] ?? 0.0) + amount;
      }
    }

    return incomeByDate;
  }


  Future<Map<String, double>> getTotalBudget() async {
    final user = FirebaseAuth.instance.currentUser;
    Map<String, double> budgetByDate = {};

    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('budget')
          .where('user_id', isEqualTo: user.uid)
          .get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (QueryDocumentSnapshot document in documents) {
        String date = document['time']; // Replace 'time' with the actual field name
        double amount = double.parse(document['amount'].toString());

      budgetByDate[date] = (budgetByDate[date] ?? 0.0) + amount;
      }
    }

    return budgetByDate;
  }


Future<Map<String, double>> getTotalInvestment() async {
    final user = FirebaseAuth.instance.currentUser;
    Map<String, double> investmentByDate = {};

    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('investment')
          .where('user_id', isEqualTo: user.uid)
          .get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (QueryDocumentSnapshot document in documents) {
        String date = document['time']; // Replace 'time' with the actual field name
        double amount = double.parse(document['amount'].toString());

      investmentByDate[date] = (investmentByDate[date] ?? 0.0) + amount;
      }
    }

    return investmentByDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10, top: 10),
            child: const Row(
              children: [
                Text(
                  'DASHBOARD',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('TOTAL EXPENSES' ,  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            ],
          ),
          FutureBuilder<Map<String, double>>(
            future: getTotalExpenses(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                Map<String, double> expensesByDate = snapshot.data ?? {};

                  List<Color> sectionColors = [
        Colors.blue,
        Colors.green,
        Colors.orange,
        // Add more colors as needed
      ];

                return Container(
                  margin: const EdgeInsets.all(16.0),
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: expensesByDate.isNotEmpty ? expensesByDate.values.reduce((a, b) => a > b ? a : b) : 0,
                      barGroups: expensesByDate.entries
                          .map(
                            (entry) => BarChartGroupData(
                              x: expensesByDate.keys.toList().indexOf(entry.key) + 1,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value,
                                  color: sectionColors[expensesByDate.keys.toList().indexOf(entry.key) % sectionColors.length],
                                  width: 25,
                                  
                                ),
                              ],
                            ),
                          )
                          .toList(),
                          
                    ),
                  ),
                );
              }
            },
          ),
          // Continue with other sections
    const SizedBox(height: 20,),
    const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'TOTAL INCOME',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    ),
    FutureBuilder<Map<String, double>>(
      future: getTotalIncome(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Map<String, double> incomeByDate = snapshot.data ?? {};

          // Define colors for each section
          List<Color> sectionColors = [
            Colors.blue,
            Colors.green,
            Colors.orange,
            // Add more colors as needed
          ];

          return Container(
            margin: const EdgeInsets.all(16.0),
            height: 300,
            child: PieChart(
              PieChartData(
                sections: incomeByDate.entries
                    .map(
                      (entry) => PieChartSectionData(
                        value: entry.value,
                        color: sectionColors[incomeByDate.keys.toList().indexOf(entry.key) % sectionColors.length],
                        title: '${entry.value}',
                        radius: 100, // Set the radius as needed
                      ),
                    )
                    .toList(),
                sectionsSpace: 0, // Adjust space between sections
                centerSpaceRadius: 40, // Adjust the center space radius
              ),
            ),
          );
        }
      },
    ),
// Continue with other sections
    // Continue with other sections
const SizedBox(height: 20,),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('TOTAL INVESTMENT' ,  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            ],
          ),
          FutureBuilder<Map<String, double>>(
            future: getTotalInvestment(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                Map<String, double> invesmentByDate = snapshot.data ?? {};

                  List<Color> sectionColors = [
        Colors.blue,
        Colors.green,
        Colors.orange,
        // Add more colors as needed
      ];

                return Container(
                  margin: const EdgeInsets.all(16.0),
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: invesmentByDate.isNotEmpty ? invesmentByDate.values.reduce((a, b) => a > b ? a : b) : 0,

                      barGroups: invesmentByDate.entries
                          .map(
                            (entry) => BarChartGroupData(
                              x: invesmentByDate.keys.toList().indexOf(entry.key) + 1,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value,
                                  color: sectionColors[invesmentByDate.keys.toList().indexOf(entry.key) % sectionColors.length],
                                  width: 25,
                                  
                                ),
                              ],
                            ),
                          )
                          .toList(),
                          
                    ),
                  ),
                );
              }
            },
          ),

          const SizedBox(height: 20,),
    const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'TOTAL BUDGET',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    ),
    FutureBuilder<Map<String, double>>(
      future: getTotalBudget(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Map<String, double> budgetByDate = snapshot.data ?? {};

          // Define colors for each section
          List<Color> sectionColors = [
            Colors.blue,
            Colors.green,
            Colors.orange,
            // Add more colors as needed
          ];

          return Container(
            margin: const EdgeInsets.all(16.0),
            height: 300,
            child: PieChart(
              PieChartData(
                sections: budgetByDate.entries
                    .map(
                      (entry) => PieChartSectionData(
                        value: entry.value,
                        color: sectionColors[budgetByDate.keys.toList().indexOf(entry.key) % sectionColors.length],
                        title: '${entry.value}',
                        radius: 100, // Set the radius as needed
                      ),
                    )
                    .toList(),
                sectionsSpace: 0, // Adjust space between sections
                centerSpaceRadius: 40, // Adjust the center space radius
              ),
            ),
          );
        }
      },
    ),

// Continue with other sections


        ],
      ),
    );
  }
}
