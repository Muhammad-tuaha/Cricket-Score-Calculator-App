import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // Import the gestures library
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth package

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false; // For showing loading spinner

  // Function to handle sign up
  Future<void> _signUp() async {
    try {
      setState(() {
        isLoading = true;
      });

      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();

      // Validate the input
      if (email.isEmpty || password.isEmpty) {
        throw FirebaseAuthException(
          code: 'invalid-input',
          message: 'Please enter both email and password.',
        );
      }

      // Create the user with Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If the user is successfully created, navigate to the menu page
      if (userCredential.user != null) {
        Navigator.pushReplacementNamed(context, '/menu'); // Navigate to menu page
      }
    } catch (e) {
      String errorMessage = 'Sign Up failed';

      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          errorMessage = 'The email address is already in use.';
        } else if (e.code == 'weak-password') {
          errorMessage = 'Password is too weak.';
        } else if (e.code == 'invalid-input') {
          errorMessage = e.message!;
        } else {
          errorMessage = e.message!;
        }
      } else {
        errorMessage = e.toString();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        isLoading = false; // Stop loading spinner
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          // Wrap the entire form in a SingleChildScrollView to allow scrolling
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Back Button
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0, left: 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.teal, size: 50),
                          onPressed: () {
                            Navigator.pop(context); // Navigate back to the login page
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Title
                    Text(
                      'CRICSCORE',
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                        fontFamily: 'MyFont1',
                      ),
                    ),
                    SizedBox(height: 30),

                    // Username Field
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: 'abc',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 22,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.13),
                        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Email Field
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'abc@gmail.com',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 22,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.13),
                        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Password Field
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                      decoration: InputDecoration(
                        hintText: '......',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 42,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.13),
                        contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),

                    // Sign-Up Button or Loading Indicator
                    isLoading
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                    )
                        : SizedBox(
                      width: 200,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _signUp,  // Call the _signUp function on button press
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 29,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Log In Navigation
                    RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: ' Log In',
                            style: TextStyle(
                              fontSize: 26,
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(context); // Navigate back to login page
                              },
                          ),
                        ],
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
