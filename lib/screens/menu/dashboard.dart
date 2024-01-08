import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project_flutter/screens/landing.dart';
import 'package:project_flutter/screens/menu/assignmentDetail.dart';
import 'package:project_flutter/screens/menu/notes.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
        title: const Text(''),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout_rounded),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirmation'),
                    content: Text('Are you sure want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color.fromARGB(255, 138, 94, 209),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => landing_screen(),
                            ),
                          );
                        },
                        child: Text(
                          'Log out',
                          style: TextStyle(
                            color: Color.fromARGB(255, 138, 94, 209),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 138, 94, 209),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
            ),
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
                  margin: EdgeInsets.only(
                    right: 40,
                    left: 40,
                  ),
                  width: double.infinity,
                  height: (MediaQuery.of(context).size.height / 4),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: db.collection('transaction').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      List<Map<String, dynamic>> items =
                          snapshot.data!.docs.map((doc) {
                        return {
                          'status': doc['status'],
                          'price': doc['price'],
                        };
                      }).toList();

                      int totalPemasukan = 0;
                      int totalPengeluaran = 0;

                      for (var item in items) {
                        if (item['price'] != null && item['status'] != null) {
                          int price = int.parse(item['price']);
                          int status = int.parse(item['status']);

                          if (status == 1) {
                            totalPemasukan += price;
                          } else if (status == 0) {
                            totalPengeluaran += price;
                          }
                        }
                      }

                      int totalCurrentMoney = totalPemasukan - totalPengeluaran;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Current Money",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            formatCurrency(totalCurrentMoney),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: calculateFontSize(
                                totalCurrentMoney.toDouble(),
                                0,
                              ),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Visibility(
                            visible:
                                (MediaQuery.of(context).size.height / 4 - 80) >
                                    105,
                            child: Column(
                              children: [
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Pemasukan",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            formatCurrency(totalPemasukan),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: calculateFontSize(
                                                totalPemasukan.toDouble(),
                                                1,
                                              ),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Pengeluaran",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            formatCurrency(totalPengeluaran),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: calculateFontSize(
                                                totalPemasukan.toDouble(),
                                                1,
                                              ),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: (MediaQuery.of(context).size.height * 0.75 - 200),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                  ),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              "On Progress Deadline",
                              style: TextStyle(
                                color: Color.fromARGB(255, 138, 94, 209),
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              width: double.infinity,
                              height: (MediaQuery.of(context).size.height / 4),
                              child: StreamBuilder<
                                  QuerySnapshot<Map<String, dynamic>>>(
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

                                  data = data.where((assignment) {
                                    DateTime deadline;
                                    try {
                                      deadline = DateFormat('dd-MM-yyyy')
                                          .parse(assignment['deadline']);
                                    } catch (e) {
                                      deadline = DateTime(1900, 1, 1);
                                    }
                                    return deadline.isAfter(DateTime.now()
                                        .subtract(Duration(days: 1)));
                                  }).toList();

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
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 8),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromARGB(
                                                        255, 138, 94, 209)
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 10,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Card(
                                            child: ListTile(
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item['title'],
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Color.fromARGB(
                                                          255, 138, 94, 209),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    item['deadline'],
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Color.fromARGB(
                                                          255, 193, 175, 219),
                                                    ),
                                                  ),
                                                  Text(
                                                    item['detail'],
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 138, 94, 209),
                                                    ),
                                                    maxLines: 4,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
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
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 20, left: 20),
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Notes()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 138, 94, 209),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              minimumSize: Size(
                                  double.infinity, kMinInteractiveDimension),
                              fixedSize: Size(double.infinity, 60.0),
                            ),
                            child: Text(
                              "Notes",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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

  String formatCurrency(int amount) {
    final currencyFormat = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    final formattedAmount = currencyFormat.format(amount.abs());

    return amount < 0 ? "- $formattedAmount" : formattedAmount;
  }

  double calculateFontSize(double amount, int a) {
    String formattedAmount = formatCurrency(amount.toInt());

    int length = formattedAmount.length;
    double baseFontSize, fontSizeFactor;

    if (a == 0) {
      baseFontSize = 50;
      fontSizeFactor = 0.3;
    } else {
      baseFontSize = 24;
      fontSizeFactor = 0.3;
    }

    double adjustedFontSize = baseFontSize - (fontSizeFactor * length);
    adjustedFontSize = adjustedFontSize.clamp(20.0, double.infinity);

    return adjustedFontSize;
  }
}
