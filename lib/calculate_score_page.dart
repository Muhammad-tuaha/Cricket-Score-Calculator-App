import 'package:flutter/material.dart';
import 'dart:ui'; // For the blur effect

class CalculateScorePage extends StatefulWidget {
  @override
  _CalculateScorePageState createState() => _CalculateScorePageState();
}

class _CalculateScorePageState extends State<CalculateScorePage> {
  List<String> scores = List.filled(6, '', growable: false); // 6 balls (1 over)
  List<String> allBallScores = []; // To track all scores entered
  int currentBall = 0;
  int totalScore = 0;
  int totalWickets = 0;
  final int maxWickets = 10; // Max wickets
  int totalOvers = 0; // Track total overs

  // Function to add score
  void addScore(String score) {
    setState(() {
      if (totalWickets < maxWickets) {
        // Add score for valid runs
        if (score == 'W' && totalWickets < maxWickets) {
          totalWickets++; // Increment wickets if it's a 'W'
        } else if (score != 'W' && score != 'WB' && score != 'NB' && score != 'BYE' && score != 'LB' && score.isNotEmpty) {
          totalScore += int.tryParse(score) ?? 0; // Add runs
        }

        scores[currentBall] = score; // Store the score
        allBallScores.add(score); // Track all ball scores
        currentBall++; // Move to next ball
      }

      // Reset after 7th score (start new over)
      if (currentBall == 6) {
        totalOvers++; // Increment overs after 6 balls (complete over)
        currentBall = 0; // Reset for next over
        scores = List.filled(6, '', growable: false); // Clear ball scores
      }
    });
  }

  // Undo the last action
  void undoLast() {
    setState(() {
      if (allBallScores.isNotEmpty) {
        // Get the last score and undo it
        String removedScore = allBallScores.removeLast();

        if (removedScore == 'W') {
          totalWickets = (totalWickets > 0) ? totalWickets - 1 : 0; // Decrease wickets
        } else if (removedScore != 'WB' && removedScore != 'NB' && removedScore != 'BYE' && removedScore != 'LB') {
          totalScore -= int.tryParse(removedScore) ?? 0; // Remove score
        }

        // If a ball score is removed, decrement the overs if necessary
        if (currentBall > 0 && currentBall % 6 == 0) {
          totalOvers--; // Decrease overs count
        }
        currentBall--; // Move back to previous ball
        scores[currentBall] = ''; // Clear the last ball score
      }
    });
  }

  // Reset match (new innings or reset)
  void resetMatch() {
    setState(() {
      totalScore = 0;
      totalWickets = 0;
      totalOvers = 0;
      currentBall = 0;
      allBallScores = [];
      scores = List.filled(6, '', growable: false);
    });
  }

  // Build the circle for score display
  Widget buildCircle(String score) {
    Color? circleColor;
    Color textColor = Colors.black;

    if (score == 'W') {
      circleColor = Colors.red;
      textColor = Colors.white;
    } else if (score == '4' || score == '6') {
      circleColor = Colors.orange;
      textColor = Colors.white;
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: circleColor ?? Colors.grey[500],
      child: Text(
        score,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Build buttons for score input
  Widget buildButton(String label, Color textColor, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with blur effect
          Positioned.fill(
            child: Image.asset(
              'assets/Background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Apply blur effect using BackdropFilter
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withOpacity(0.4), // Optional: add dark overlay
              ),
            ),
          ),
          // Main content
          Column(
            children: [
              // Add top spacing for the header (back button and 'CRICSCORE')
              SizedBox(height: 40),  // Increased space from the top
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  Text(
                    'Score Calculator',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MyFont1',
                    ),
                  ),
                  SizedBox(width: 1), // Placeholder for back button space
                ],
              ),

              // 'Score Calculator' Text below

              SizedBox(height: 50),

              // Display the 6 balls (in a row)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: scores.map((score) => buildCircle(score)).toList(),
              ),
              SizedBox(height: 20),

              // Display total score, total wickets, and total overs, one below the other
              Column(
                children: [
                  Text(
                    'Total Score: $totalScore',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Wickets: $totalWickets / $maxWickets',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Overs: $totalOvers',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Grid for score buttons
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                padding: EdgeInsets.all(16),
                children: [
                  for (var score in ['0', '1', '2', '3', '4', '6'])
                    buildButton(
                      score,
                      Colors.black,
                          () => addScore(score),
                    ),
                  buildButton('WB', Colors.black, () => addScore('WB')),
                  buildButton('NB', Colors.black, () => addScore('NB')),
                  buildButton('BYE', Colors.black, () => addScore('BYE')),
                  buildButton('LB', Colors.black, () => addScore('LB')),
                  buildButton('OUT', Colors.red, () => addScore('W')),
                  buildButton('UNDO', Colors.green, undoLast),
                  buildButton('RESET', Colors.blue, resetMatch),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}