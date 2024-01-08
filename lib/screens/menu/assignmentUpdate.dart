import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AssignmentUpdate extends StatefulWidget {
  final String? documentId;
  final Map<String, dynamic>? assignment;

  const AssignmentUpdate({Key? key, this.documentId, this.assignment})
      : super(key: key);

  @override
  _AssignmentUpdateState createState() => _AssignmentUpdateState();
}

// ignore: must_be_immutable
class _AssignmentUpdateState extends State<AssignmentUpdate> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.assignment != null) {
      Map<String, dynamic> assignment = widget.assignment!;
      titleController.text = assignment['title'];
      detailController.text = assignment['detail'];
      deadlineController.text = assignment['deadline'];
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime _dateTime = DateTime.now();

    void _showDatePicker() {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme:
                  ColorScheme.light(primary: Color.fromARGB(255, 138, 94, 209)),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
      ).then((value) {
        if (value != null) {
          setState(() {
            _dateTime = value;
            deadlineController.text =
                DateFormat('dd-MM-yyyy').format(_dateTime);
          });
        }
      });
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromARGB(255, 138, 94, 209),
          title: const Text('Assignment'),
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
                      titleController.text,
                      detailController.text,
                    ].any((field) => field.contains("'"));
                  }

                  bool anyFieldIsEmpty() {
                    return [
                      titleController.text,
                      detailController.text,
                    ].any((field) => field.isEmpty);
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
                  if (error == false) {
                    if (widget.documentId != null) {
                      FirebaseFirestore.instance
                          .collection('assignment')
                          .doc(widget.documentId)
                          .update({
                        'title': titleController.text,
                        'detail': detailController.text,
                        'deadline': deadlineController.text,
                      });
                    } else {
                      FirebaseFirestore.instance.collection('assignment').add({
                        'title': titleController.text,
                        'detail': detailController.text,
                        'deadline': deadlineController.text,
                      });
                    }
                    Navigator.pop(context, {
                      'title': titleController.text,
                      'detail': detailController.text,
                      'deadline': deadlineController.text,
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
                    4), // Adjust the border radius as needed
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
                        "Title :",
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
                        controller: titleController,
                        maxLength: 21,
                        decoration: InputDecoration(
                          hintText: 'Enter assignment title',
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
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Deadline :",
                            style: TextStyle(
                              color: Color.fromARGB(255, 138, 94, 209),
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: TextField(
                                controller: deadlineController,
                                readOnly: true,
                                enabled: false,
                                decoration: InputDecoration(
                                  hintText: 'Select deadline date',
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
                              )),
                              SizedBox(width: 10),
                              IconButton(
                                icon: Icon(Icons.calendar_today),
                                color: Color.fromARGB(255, 138, 94, 209),
                                onPressed: () {
                                  _showDatePicker();
                                },
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
                          hintText: 'Enter assignment detail',
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
                        minLines: 1,
                        maxLines: 5,
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
                              'Are you sure want to delete this assignment?'),
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
                                if (widget.documentId != null) {
                                  await FirebaseFirestore.instance
                                      .collection('assignment')
                                      .doc(widget.documentId)
                                      .delete();
                                }
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Done',
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
                  child: Text(
                    'Delete Assignment',
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
