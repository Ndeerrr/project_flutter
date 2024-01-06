import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project_flutter/screens/menu/assignmentCreate.dart';
import 'package:project_flutter/screens/menu/assignmentDetail.dart';

class Assignment extends StatefulWidget {
  const Assignment({Key? key}) : super(key: key);

  @override
  _AssignmentState createState() => _AssignmentState();
}

class _AssignmentState extends State<Assignment> {
  @override
  void initState() {
    super.initState();
  }

  var db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 138, 94, 209),
        title: const Text('Assignment'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AssignmentCreate(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          color: Color.fromARGB(255, 138, 94, 209),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height - 112,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.all(40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "On Progress",
                        style: TextStyle(
                          color: Color.fromARGB(255, 138, 94, 209),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: db
                            .collection('assignment')
                            .orderBy('deadline')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text("Error"),
                            );
                          }
                          var data = snapshot.data!.docs;

                          // Filter tasks that are after today or today
                          var onProgressData = data.where((item) {
                            DateTime taskDate = DateFormat('dd-MM-yyyy')
                                .parse(item['deadline']);
                            DateTime today = DateTime.now();
                            return taskDate
                                .isAfter(today.subtract(Duration(days: 1)));
                          }).toList();

                          data.sort((a, b) {
                            DateTime dateA;
                            DateTime dateB;

                            try {
                              dateA =
                                  DateFormat('dd-MM-yyyy').parse(a['deadline']);
                            } catch (e) {
                              dateA = DateTime(1900, 1,
                                  1); // Default date for invalid format
                            }

                            try {
                              dateB =
                                  DateFormat('dd-MM-yyyy').parse(b['deadline']);
                            } catch (e) {
                              dateB = DateTime(1900, 1,
                                  1); // Default date for invalid format
                            }

                            // Compare by formatted date
                            var dateComparison = dateB.compareTo(dateA);
                            if (dateComparison != 0) {
                              return dateComparison;
                            }

                            // Case-insensitive compare by title
                            return a['title']
                                .toLowerCase()
                                .compareTo(b['title'].toLowerCase());
                          });

                          return Container(
                            height:
                                ((MediaQuery.of(context).size.height - 227) *
                                        0.75) -
                                    30,
                            child: ListView.builder(
                              itemCount: onProgressData.length,
                              itemBuilder: (context, index) {
                                final item = onProgressData[index];
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 8.0),
                                  child: ListTile(
                                    title: Text(
                                      item['title'],
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 138, 94, 209),
                                      ),
                                    ),
                                    trailing: Text(
                                      item['deadline'],
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 193, 175, 219),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AssignmentDetail(
                                            documentId: item.id,
                                            assignment: item.data(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Overdue",
                        style: TextStyle(
                          color: Color.fromARGB(255, 138, 94, 209),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: db
                            .collection('assignment')
                            .orderBy('deadline')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text("Error"),
                            );
                          }
                          var data = snapshot.data!.docs;

                          // Filter overdue tasks
                          var overdueData = data.where((item) {
                            DateTime taskDate = DateFormat('dd-MM-yyyy')
                                .parse(item['deadline']);
                            DateTime today = DateTime.now();
                            return taskDate
                                .isBefore(today.subtract(Duration(days: 1)));
                          }).toList();

                          overdueData.sort((a, b) {
                            DateTime dateA;
                            DateTime dateB;

                            try {
                              dateA =
                                  DateFormat('dd-MM-yyyy').parse(a['deadline']);
                            } catch (e) {
                              dateA = DateTime(1900, 1,
                                  1); // Default date for invalid format
                            }

                            try {
                              dateB =
                                  DateFormat('dd-MM-yyyy').parse(b['deadline']);
                            } catch (e) {
                              dateB = DateTime(1900, 1,
                                  1); // Default date for invalid format
                            }

                            // Compare by formatted date
                            var dateComparison = dateB.compareTo(dateA);
                            if (dateComparison != 0) {
                              return dateComparison;
                            }

                            // Case-insensitive compare by title
                            return a['title']
                                .toLowerCase()
                                .compareTo(b['title'].toLowerCase());
                          });

                          return Container(
                            height:
                                ((MediaQuery.of(context).size.height - 227) /
                                        4) -
                                    15,
                            child: ListView.builder(
                              itemCount: overdueData.length,
                              itemBuilder: (context, index) {
                                final item = overdueData[index];
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 8.0),
                                  child: ListTile(
                                    title: Text(
                                      item['title'],
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 138, 94, 209),
                                      ),
                                    ),
                                    trailing: Text(
                                      item['deadline'],
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 193, 175, 219),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AssignmentDetail(
                                            documentId: item.id,
                                            assignment: item.data(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
