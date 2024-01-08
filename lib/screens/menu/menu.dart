import 'package:flutter/material.dart';
import 'package:project_flutter/screens/menu/Notes.dart';
import 'package:project_flutter/screens/menu/assignment.dart';
import 'package:project_flutter/screens/menu/dashboard.dart';
import 'package:project_flutter/screens/menu/transaction.dart';

class Menu extends StatefulWidget {
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<Menu> {
  int _currentIndex = 0;

  List<Widget> _pages = [
    Transaction(),
    Assignment(),
    Notes(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _pages[_currentIndex],
          ),
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 138, 94, 209),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withOpacity(0.5),
              elevation: 0.0,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check),
                  label: 'Assignment',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.book),
                  label: 'Notes',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class kosong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Kosong'),
    );
  }
}
