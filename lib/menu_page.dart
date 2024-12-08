import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MenuPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Logout function
  void _logout(BuildContext context) async {
    await _auth.signOut(); // Log out from Firebase
    Navigator.pushReplacementNamed(context, '/login'); // Navigate to the login page
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
          // Page content
          Column(
            children: [
              // Logout button
              Padding(
                padding: const EdgeInsets.only(top: 40.0, right: 16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    onPressed: () => _logout(context), // Call logout function
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 70),
              // Menu Options
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 14.0),
                  children: [
                    MenuOption(
                      text: 'Watch Live Score',
                      imagePath: 'assets/live_score_icon.jpg',
                      onTap: () {
                        Navigator.pushNamed(context, '/live_score'); // Navigate to live score page
                      },
                      height: 113,
                      imageWidth: 120,
                      imageHeight: 120,
                    ),
                    SizedBox(height: 60),
                    MenuOption(
                      text: 'Calculate Score',
                      imagePath: 'assets/calculate_score_icon.jpg',
                      onTap: () {
                        Navigator.pushNamed(context, '/calculate_score'); // Navigate to score calculation page
                      },
                      height: 113,
                      imageWidth: 120,
                      imageHeight: 120,
                    ),
                    SizedBox(height: 60),
                    MenuOption(
                      text: 'Calculate Ball Speed',
                      imagePath: 'assets/ball_speed_icon.jpg',
                      onTap: () {
                        Navigator.pushNamed(context, '/ball_speed'); // Navigate to ball speed calculation page
                      },
                      height: 113,
                      imageWidth: 120,
                      imageHeight: 120,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Menu Option Widget
class MenuOption extends StatelessWidget {
  final String text;
  final String imagePath;
  final VoidCallback onTap;
  final double height; // Height of the rectangle
  final double imageWidth; // Width of the image
  final double imageHeight; // Height of the image

  const MenuOption({
    required this.text,
    required this.imagePath,
    required this.onTap,
    required this.height,
    required this.imageWidth,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        decoration: BoxDecoration(
          color: Color(0xFF3E7EB2).withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        height: height, // Set custom height for the rectangle
        child: Row(
          children: [
            // Image on the left (1/3rd of the container width)
            Align(
              alignment: Alignment.topLeft, // Align the image to top-left
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  width: imageWidth, // Set custom width for the image
                  height: imageHeight, // Set custom height for the image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16),
            // Text on the right (2/3rd of the container width)
            Expanded(
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontFamily: 'MyFont2', // Apply the custom font
                  ),
                  textAlign: TextAlign.center, // Center text in the available space
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
