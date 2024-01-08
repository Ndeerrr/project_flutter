import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project_flutter/screens/menu/transactionCreate.dart';
import 'package:project_flutter/screens/menu/transactionDetail.dart';

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
        title: const Text('Transaction'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionCreate(),
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
                  margin: EdgeInsets.only(
                    top: 40,
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Recent Transaction",
                          style: TextStyle(
                            color: Color.fromARGB(255, 138, 94, 209),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: db
                              .collection('transaction')
                              .orderBy('date')
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
                                dateA =
                                    DateFormat('dd-MM-yyyy').parse(a['date']);
                              } catch (e) {
                                dateA = DateTime(1900, 1, 1);
                              }

                              try {
                                dateB =
                                    DateFormat('dd-MM-yyyy').parse(b['date']);
                              } catch (e) {
                                dateB = DateTime(1900, 1, 1);
                              }

                              return dateB.compareTo(dateA);
                            });

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
                                        item['date'],
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 138, 94, 209),
                                        ),
                                      ),
                                      trailing: Text(
                                        "${item['status'] == "1" ? "+ " : "- "}${formatCurrency(int.parse(item['price']))}",
                                        style: TextStyle(
                                          color: item['status'] == "1"
                                              ? Colors.green
                                              : Color.fromARGB(
                                                  255, 255, 121, 121),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TransactionDetail(
                                              documentId: item.id,
                                              transaction: item.data(),
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
