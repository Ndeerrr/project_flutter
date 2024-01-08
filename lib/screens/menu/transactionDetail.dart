import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_flutter/screens/menu/transactionUpdate.dart';

class TransactionDetail extends StatefulWidget {
  final String? documentId;
  final Map<String, dynamic>? transaction;

  const TransactionDetail({Key? key, this.documentId, this.transaction})
      : super(key: key);

  @override
  _TransactionDetailState createState() => _TransactionDetailState();
}

// ignore: must_be_immutable
class _TransactionDetailState extends State<TransactionDetail> {
  final TextEditingController priceController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      Map<String, dynamic> transaction = widget.transaction!;
      priceController.text = transaction['price'];
      detailController.text = transaction['detail'];
      statusController.text = transaction['status'];
      dateController.text = transaction['date'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 138, 94, 209),
        title: const Text('Transaction'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final updatedData = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionUpdate(
                    documentId: widget.documentId,
                    transaction: widget.transaction,
                  ),
                ),
              );
              if (updatedData != null) {
                print('Updated Data: $updatedData');
                setState(() {
                  widget.transaction!['price'] = updatedData['price'];
                  widget.transaction!['detail'] = updatedData['detail'];
                  widget.transaction!['status'] = updatedData['status'];
                  priceController.text = updatedData['price'];
                  detailController.text = updatedData['detail'];
                  statusController.text = updatedData['status'];
                });
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height - 56,
            color: Color.fromARGB(255, 138, 94, 209),
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
                      "${statusController.text == "1" ? "+ " : "- "}${formatCurrency(int.parse(priceController.text))}",
                      style: TextStyle(
                        color: statusController.text == "1"
                            ? Colors.green
                            : Color.fromARGB(255, 255, 121, 121),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      dateController.text,
                      style: TextStyle(
                        color: Color.fromARGB(255, 193, 175, 219),
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: MediaQuery.of(context).size.height - 233,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Text(
                          detailController.text,
                          style: TextStyle(
                            color: Color.fromARGB(255, 138, 94, 209),
                            fontSize: 25,
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
    );
  }

  String formatCurrency(int amount) {
    final currencyFormat = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    final formattedAmount = currencyFormat.format(amount.abs());

    return amount < 0 ? "- $formattedAmount" : formattedAmount;
  }
}
