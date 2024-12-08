import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class BallSpeedPage extends StatefulWidget {
  @override
  _BallSpeedPageState createState() => _BallSpeedPageState();
}

class _BallSpeedPageState extends State<BallSpeedPage> {
  final TextEditingController distanceController =
  TextEditingController(text: '20.08'); // Default pitch length
  bool isTiming = false;
  Stopwatch stopwatch = Stopwatch();
  Timer? timer;
  double? calculatedSpeed;

  void startTimer() {
    if (stopwatch.isRunning) return; // Prevent multiple starts
    stopwatch.start();
    setState(() {
      isTiming = true;
    });

    timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {});
    });
  }

  void stopTimer() {
    if (!stopwatch.isRunning) return; // Prevent stopping if not running
    stopwatch.stop();
    timer?.cancel();

    final double? distance = double.tryParse(distanceController.text.trim());
    final double elapsedTimeInSeconds = stopwatch.elapsedMilliseconds / 1000;

    if (distance == null || elapsedTimeInSeconds == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid input. Please enter a valid distance."),
        ),
      );
      return;
    }

    // Calculate speed in m/s and convert to km/h
    final double speedInMetersPerSecond = distance / elapsedTimeInSeconds;
    final double speedInKilometersPerHour = speedInMetersPerSecond * 3.6;

    setState(() {
      isTiming = false;
      calculatedSpeed = speedInKilometersPerHour;
    });
  }

  void reset() {
    stopwatch.reset();
    timer?.cancel();
    setState(() {
      isTiming = false;
      calculatedSpeed = null;
    });
  }

  void showHowItWorksDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'How It Works',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
        child: RichText(
        text: TextSpan(
        style: TextStyle(fontSize: 16, color: Colors.black),
        children: [
        TextSpan(text: '1. Set the pitch length in meters (default is 20.08).\n\n'),
        TextSpan(text: '2. Press ', style: TextStyle(fontWeight: FontWeight.normal)),
        TextSpan(text: 'Start', style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: ' when the ball is delivered.\n\n'),
        TextSpan(text: '3. Press ', style: TextStyle(fontWeight: FontWeight.normal)),
        TextSpan(text: 'Stop', style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: ' when the ball reaches the batsman.\n\n'),
        TextSpan(
        text:
        '4. The elapsed time will be used to calculate the speed of the ball in km/h.\n\n'),
        TextSpan(text: '5. You can modify the pitch length if needed.\n\n'),
        TextSpan(text: '6. Use the ', style: TextStyle(fontWeight: FontWeight.normal)),
        TextSpan(text: 'Reset', style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: ' button to clear the stopwatch and start over.'),
        ],
        ),
        ),
          ),
        actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Got it!',
                style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    stopwatch.stop();
    super.dispose();
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
          // Blur Effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          // Main Content
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Back Button
                    SizedBox(height: 40),
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),

                    // Title
                    SizedBox(height: 10),
                    Text(
                      'BALL SPEED CALCULATOR',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                        fontFamily: 'MyFont1',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),

                    // How It Works Link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: showHowItWorksDialog,
                        child: Text(
                          'How It Works?',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Distance Input
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Pitch Length (in meters)',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: distanceController,
                      decoration: InputDecoration(
                        hintText: 'Enter pitch length',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.13),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20),

                    // Stopwatch Display
                    Text(
                      'Elapsed Time: ${stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}.${(stopwatch.elapsedMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),

                    // Buttons Layout
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: startTimer,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Start',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: stopTimer,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Stop',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: reset,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Reset',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),

                    // Speed Display
                    if (calculatedSpeed != null)
                      Text(
                        'Speed: ${calculatedSpeed!.toStringAsFixed(2)} km/h',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
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
