import 'package:flutter/material.dart';
import 'package:project_flutter/screens/login.dart';
import 'package:project_flutter/screens/register.dart';

class landing_screen extends StatelessWidget {
  const landing_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Color.fromARGB(255, 138, 94, 209),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      Container(
                        margin: EdgeInsets.only(bottom: 40),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Welcome",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 60 *
                                          MediaQuery.of(context).size.width /
                                          500 *
                                          MediaQuery.of(context).size.height /
                                          750,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Manage your needs",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25 *
                                          MediaQuery.of(context).size.width /
                                          500,
                                    ),
                                  ),
                                  Text(
                                    "Seamlessly & Intuitively",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30 *
                                          MediaQuery.of(context).size.width /
                                          500,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const Login(
                                            showAdditionalContent: true,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      minimumSize: Size(double.infinity,
                                          kMinInteractiveDimension),
                                      fixedSize: Size(double.infinity, 60.0),
                                    ),
                                    child: Text(
                                      "Sign in with Google",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 138, 94, 209),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const Register(
                                            showAdditionalContent: true,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary:
                                          Color.fromARGB(255, 138, 94, 209),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        side: BorderSide(
                                          color: Colors.white,
                                          width: 3.0,
                                        ),
                                      ),
                                      minimumSize: Size(double.infinity,
                                          kMinInteractiveDimension),
                                      fixedSize: Size(double.infinity, 60.0),
                                    ),
                                    child: Text(
                                      "Create an account",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 100,
                            ),
                            Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account?",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const Login(
                                            showAdditionalContent: true,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Sign in",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
