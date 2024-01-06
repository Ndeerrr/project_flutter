import 'package:flutter/material.dart';
import 'package:project_flutter/auth/auth_service.dart';
import 'package:project_flutter/screens/login.dart';

class Register extends StatefulWidget {
  final bool? showAdditionalContent;
  const Register({
    Key? key,
    this.showAdditionalContent,
  }) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 138, 94, 209),
        title: const Text(''),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          color: Color.fromARGB(255, 138, 94, 209),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Container(
                width: double.infinity,
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
                        "Welcome",
                        style: TextStyle(
                          color: Color.fromARGB(255, 138, 94, 209),
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        "Hello there, register your account here!",
                        style: TextStyle(
                          color: Color.fromARGB(255, 178, 156, 212),
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 50 * MediaQuery.of(context).size.height / 750,
                      ),
                      Text(
                        "Email",
                        style: TextStyle(
                          color: Color.fromARGB(255, 193, 175, 219),
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10 * MediaQuery.of(context).size.height / 750,
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
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
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 138, 94, 209),
                        ),
                      ),
                      SizedBox(
                        height: 30 * MediaQuery.of(context).size.height / 750,
                      ),
                      Text(
                        "Password",
                        style: TextStyle(
                          color: Color.fromARGB(255, 193, 175, 219),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10 * MediaQuery.of(context).size.height / 750,
                      ),
                      TextField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
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
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 138, 94, 209),
                        ),
                      ),
                      SizedBox(
                        height: 80 * MediaQuery.of(context).size.height / 750,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final message = await AuthService().register(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );

                          if (message == 'Registration Success') {
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message ?? 'An error occurred'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 138, 94, 209),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          minimumSize:
                              Size(double.infinity, kMinInteractiveDimension),
                          fixedSize: Size(double.infinity, 60.0),
                        ),
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 145 * MediaQuery.of(context).size.height / 750,
                      ),
                      if (widget.showAdditionalContent ?? true)
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 193, 175, 219),
                                  fontSize: 20,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const Login(
                                        showAdditionalContent: false,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Sign in",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 138, 94, 209),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
