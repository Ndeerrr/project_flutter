import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class TransactionCreate extends StatefulWidget {
  @override
  _TransactionCreateState createState() => _TransactionCreateState();
}

class _TransactionCreateState extends State<TransactionCreate> {
  final TextEditingController priceController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  int currentStatus = 1;
  var db = FirebaseFirestore.instance;

  String removeFormatting(String formattedValue) {
    return formattedValue.replaceAll(',', '');
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(today);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 138, 94, 209),
        title: const Text('Transaction'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 56,
            color: Color.fromARGB(255, 138, 94, 209),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 56,
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
                      "Price :",
                      style: TextStyle(
                        color: Color.fromARGB(255, 138, 94, 209),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    currentStatus = currentStatus == 0 ? 1 : 0;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: currentStatus == 0
                                      ? Color.fromARGB(255, 255, 121, 121)
                                      : Colors.green,
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: currentStatus == 0
                                    ? Icon(Icons.remove)
                                    : Icon(Icons.add),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                maxLength: 21,
                                controller: priceController,
                                onChanged: (value) {},
                                decoration: InputDecoration(
                                  counterText: '',
                                  hintText: 'Enter transaction price',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 193, 175, 219),
                                    ),
                                  ),
                                ),
                                cursorColor: Color.fromARGB(255, 138, 94, 209),
                                style: TextStyle(
                                  color: Color.fromARGB(255, 138, 94, 209),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  TextInputFormatter.withFunction(
                                      (oldValue, newValue) {
                                    if (newValue.text.isEmpty) {
                                      return newValue.copyWith(text: '');
                                    }

                                    final num = int.parse(newValue.text);
                                    final formattedValue =
                                        NumberFormat('###,###,###').format(num);
                                    return newValue.copyWith(
                                      text: formattedValue,
                                      selection: TextSelection.collapsed(
                                          offset: formattedValue.length),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Detail :",
                      style: TextStyle(
                        color: Color.fromARGB(255, 138, 94, 209),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: detailController,
                      decoration: InputDecoration(
                        hintText: 'Enter transaction detail',
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 193, 175, 219),
                          ),
                        ),
                      ),
                      minLines: (25 * MediaQuery.of(context).size.height / 1000)
                          .toInt(),
                      maxLines: (25 * MediaQuery.of(context).size.height / 1000)
                          .toInt(),
                      cursorColor: Color.fromARGB(255, 138, 94, 209),
                      style: TextStyle(
                        color: Color.fromARGB(255, 138, 94, 209),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  var error = false;
                  var listerror = "list Error :";
                  bool containsSingleQuote() {
                    return [
                      priceController.text,
                      detailController.text,
                    ].any((field) => field.contains("'"));
                  }

                  bool anyFieldIsEmpty() {
                    return [
                      priceController.text,
                      detailController.text,
                    ].any((field) => field.isEmpty);
                  }

                  bool isNumeric(String str) {
                    // ignore: unnecessary_null_comparison
                    if (str == null) {
                      return false;
                    }
                    return double.tryParse(str) != null;
                  }

                  if (containsSingleQuote()) {
                    error = true;
                    listerror =
                        listerror + "\n There's a quote(') in your input";
                  }
                  if (anyFieldIsEmpty()) {
                    error = true;
                    listerror = listerror + "\n All form needs to be filled";
                  }
                  if (!isNumeric(removeFormatting(priceController.text))) {
                    error = true;
                    listerror = listerror + "\n Price must be numbers";
                  }
                  if (error == false) {
                    final user = <String, dynamic>{
                      "price": removeFormatting(priceController.text),
                      "detail": detailController.text.toString(),
                      "status": currentStatus.toString(),
                      "date": formattedDate
                    };
                    db.collection("transaction").add(user).then(
                        (DocumentReference doc) =>
                            print('DocumentSnapshot added with ID: ${doc.id}'));
                    Navigator.pop(context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Input Error'),
                          content: Text(listerror),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
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
                child: Text('Add Data'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
