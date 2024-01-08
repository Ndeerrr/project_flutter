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
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 40, bottom: 40),
                  width: double.infinity,
                  height: (MediaQuery.of(context).size.height / 4),
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: db
                        .collection('assignment')
                        .orderBy('deadline')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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

                      data = data.where((assignment) {
                        DateTime deadline;
                        try {
                          deadline = DateFormat('dd-MM-yyyy')
                              .parse(assignment['deadline']);
                        } catch (e) {
                          deadline = DateTime(1900, 1, 1);
                        }
                        return deadline.isAfter(
                            DateTime.now().subtract(Duration(days: 1)));
                      }).toList();

                      data.sort((a, b) {
                        DateTime dateA;
                        DateTime dateB;

                        try {
                          dateA = DateFormat('dd-MM-yyyy').parse(a['deadline']);
                        } catch (e) {
                          dateA = DateTime(1900, 1, 1);
                        }

                        try {
                          dateB = DateFormat('dd-MM-yyyy').parse(b['deadline']);
                        } catch (e) {
                          dateB = DateTime(1900, 1, 1);
                        }

                        var dateComparison = dateB.compareTo(dateA);
                        if (dateComparison != 0) {
                          return dateComparison;
                        }

                        return a['title']
                            .toLowerCase()
                            .compareTo(b['title'].toLowerCase());
                      });

                      return Container(
                        height: 200,
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final item = data[index];
                            return Card(
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'],
                                      style: TextStyle(
                                        fontSize: 20,
                                        color:
                                            Color.fromARGB(255, 138, 94, 209),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      item['deadline'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        color:
                                            Color.fromARGB(255, 193, 175, 219),
                                      ),
                                    ),
                                    Text(
                                      item['detail'],
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 138, 94, 209),
                                      ),
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AssignmentDetail(
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
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: (MediaQuery.of(context).size.height * 0.75 - 193),
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
                      children: [
                        Text(
                          "Overdue Assignment",
                          style: TextStyle(
                            color: Color.fromARGB(255, 138, 94, 209),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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

                            data.sort((a, b) {
                              DateTime dateA;
                              DateTime dateB;

                              try {
                                dateA = DateFormat('dd-MM-yyyy')
                                    .parse(a['deadline']);
                              } catch (e) {
                                dateA = DateTime(1900, 1, 1);
                              }

                              try {
                                dateB = DateFormat('dd-MM-yyyy')
                                    .parse(b['deadline']);
                              } catch (e) {
                                dateB = DateTime(1900, 1, 1);
                              }

                              var dateComparison = dateB.compareTo(dateA);
                              if (dateComparison != 0) {
                                return dateComparison;
                              }

                              return a['title']
                                  .toLowerCase()
                                  .compareTo(b['title'].toLowerCase());
                            });

                            // Filter data to show only assignments with deadlines before the current day
                            var currentDate = DateTime.now();
                            data = data.where((item) {
                              DateTime itemDate;
                              try {
                                itemDate = DateFormat('dd-MM-yyyy')
                                    .parse(item['deadline']);
                              } catch (e) {
                                itemDate = DateTime(1900, 1, 1);
                              }
                              return itemDate.isBefore(DateTime(
                                  currentDate.year,
                                  currentDate.month,
                                  currentDate.day));
                            }).toList();

                            return Container(
                              height:
                                  (MediaQuery.of(context).size.height * 0.75 -
                                          193) -
                                      120,
                              child: ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  final item = data[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 8.0),
                                    child: ListTile(
                                      title: Text(
                                        item['title'],
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 138, 94, 209),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: Text(
                                        item['deadline'],
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 193, 175, 219),
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
                      ],
                    ),
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
