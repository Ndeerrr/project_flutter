import 'package:flutter/material.dart';
import 'package:project_flutter/screens/menu/assignmentUpdate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentDetail extends StatefulWidget {
  final String? documentId;
  final Map<String, dynamic>? assignment;

  const AssignmentDetail({Key? key, this.documentId, this.assignment})
      : super(key: key);

  @override
  _AssignmentDetailState createState() => _AssignmentDetailState();
}

// ignore: must_be_immutable
class _AssignmentDetailState extends State<AssignmentDetail> {
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 138, 94, 209),
        title: const Text('Assignment'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final updatedData = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AssignmentUpdate(
                    documentId: widget.documentId,
                    assignment: widget.assignment,
                  ),
                ),
              );
              if (updatedData != null) {
                print('Updated Data: $updatedData');
                setState(() {
                  widget.assignment!['title'] = updatedData['title'];
                  widget.assignment!['detail'] = updatedData['detail'];
                  widget.assignment!['deadline'] = updatedData['deadline'];
                  titleController.text = updatedData['title'];
                  detailController.text = updatedData['detail'];
                  deadlineController.text = updatedData['deadline'];
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
                      titleController.text,
                      style: TextStyle(
                        color: Color.fromARGB(255, 138, 94, 209),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      deadlineController.text,
                      style: TextStyle(
                        color: Color.fromARGB(255, 193, 175, 219),
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: MediaQuery.of(context).size.height - 269,
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
                        content: Text('Are you sure?'),
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
                                    .collection('assignment')
                                    .doc(widget.documentId)
                                    .delete();
                              }
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text('Done'),
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
                child: Text('Done'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
