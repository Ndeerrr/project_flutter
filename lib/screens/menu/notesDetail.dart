import 'package:flutter/material.dart';
import 'package:project_flutter/screens/menu/notesUpdate.dart';

class NotesDetail extends StatefulWidget {
  final String? documentId;
  final Map<String, dynamic>? notes;

  const NotesDetail({Key? key, this.documentId, this.notes}) : super(key: key);

  @override
  _NotesDetailState createState() => _NotesDetailState();
}

// ignore: must_be_immutable
class _NotesDetailState extends State<NotesDetail> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.notes != null) {
      Map<String, dynamic> notes = widget.notes!;
      titleController.text = notes['title'];
      detailController.text = notes['detail'];
      dateController.text = notes['date'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 138, 94, 209),
        title: const Text('Notes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final updatedData = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotesUpdate(
                    documentId: widget.documentId,
                    notes: widget.notes,
                  ),
                ),
              );
              if (updatedData != null) {
                print('Updated Data: $updatedData');
                setState(() {
                  widget.notes!['title'] = updatedData['title'];
                  widget.notes!['detail'] = updatedData['detail'];
                  titleController.text = updatedData['title'];
                  detailController.text = updatedData['detail'];
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: MediaQuery.of(context).size.height - 196,
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
}
