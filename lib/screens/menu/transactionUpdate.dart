import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class TransactionUpdate extends StatefulWidget {
  final String? documentId;
  final Map<String, dynamic>? transaction;

  const TransactionUpdate({Key? key, this.documentId, this.transaction})
      : super(key: key);

  @override
  _TransactionUpdateState createState() => _TransactionUpdateState();
}

class _TransactionUpdateState extends State<TransactionUpdate> {
  final TextEditingController priceController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      Map<String, dynamic> transaction = widget.transaction!;
      priceController.text = formatCurrency(transaction['price']);
      detailController.text = transaction['detail'];
      statusController.text = transaction['status'];
    }
  }

  String formatCurrency(String value) {
    final num = int.tryParse(value) ?? 0;
    return NumberFormat('###,###,###').format(num);
  }

  String removeFormatting(String formattedValue) {
    return formattedValue.replaceAll(',', '');
  }

  @override
  Widget build(BuildContext context) {
    int currentStatus = int.parse(statusController.text);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 138, 94, 209),
        title: const Text('transaction'),
        centerTitle: true,
        actions: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: InkWell(
              onTap: () async {
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

                if (containsSingleQuote()) {
                  error = true;
                  listerror = listerror + "\n There's a quote(') in your input";
                }
                if (anyFieldIsEmpty()) {
                  error = true;
                  listerror = listerror + "\n All form needs to be filled";
                }
                if (error == false) {
                  if (widget.documentId != null) {
                    FirebaseFirestore.instance
                        .collection('transaction')
                        .doc(widget.documentId)
                        .update({
                      'price': removeFormatting(priceController.text),
                      'detail': detailController.text,
                      'status': statusController.text,
                    });
                  } else {
                    FirebaseFirestore.instance.collection('transaction').add({
                      'price': removeFormatting(priceController.text),
                      'detail': detailController.text,
                      'status': statusController.text,
                    });
                  }

                  Navigator.pop(context, {
                    'price': removeFormatting(priceController.text),
                    'detail': detailController.text,
                    'status': statusController.text,
                  });
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
              borderRadius: BorderRadius.circular(
                4,
              ),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(8),
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
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
                                    statusController.text =
                                        currentStatus.toString();
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirmation'),
                        content: Text(
                            'Are you sure you want to delete this transaction?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (widget.documentId != null) {
                                await FirebaseFirestore.instance
                                    .collection('transaction')
                                    .doc(widget.documentId)
                                    .delete();
                              }
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text('Delete'),
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
                child: Text('Delete transaction'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
