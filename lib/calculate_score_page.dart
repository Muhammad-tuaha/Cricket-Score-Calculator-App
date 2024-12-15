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
  int maxOvers = 0; // Number of overs to be set by user
  bool oversSet = false; // Tracks if overs are set

  // Function to add score
  void addScore(String score) {
    setState(() {
      if (totalWickets < maxWickets && totalOvers < maxOvers) {
        if (score == 'W') {
          totalWickets++;
          scores[currentBall] = 'W';
          allBallScores.add('W');
          currentBall++;
        } else if (score == 'NB' || score == 'WB') {
          totalScore += 1;
          allBallScores.add(score);
        } else if (score.isNotEmpty) {
          totalScore += int.tryParse(score) ?? 0;
          scores[currentBall] = score;
          allBallScores.add(score);
          currentBall++;
        }

        if (currentBall == 6) {
          totalOvers++;
          currentBall = 0;
          scores = List.filled(6, '', growable: false);
        }
      }
    });
  }

  // Undo the last action
  void undoLast() {
    setState(() {
      if (allBallScores.isNotEmpty) {
        String lastScore = allBallScores.removeLast();
        if (lastScore == 'W') {
          totalWickets = (totalWickets > 0) ? totalWickets - 1 : 0;
        } else if (lastScore == 'NB' || lastScore == 'WB') {
          totalScore -= 1;
        } else if (lastScore.isNotEmpty) {
          totalScore -= int.tryParse(lastScore) ?? 0;
        }

        if (currentBall > 0) {
          currentBall--;
          scores[currentBall] = '';
        } else if (totalOvers > 0) {
          totalOvers--;
          currentBall = 5;
        }
      }
    });
  }

  // Reset match
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

  // Show a dialog to set the number of overs
  void showOversDialog() {
    TextEditingController oversController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/Background.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),
            Center(
              child: AlertDialog(
                title: Text('Set Number of Overs'),
                content: TextField(
                  controller: oversController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'Enter number of overs'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      int enteredOvers = int.tryParse(oversController.text) ?? 0;
                      if (enteredOvers > 0) {
                        setState(() {
                          maxOvers = enteredOvers;
                          oversSet = true;
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Set'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showOversDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: oversSet
          ? Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/Background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 40),
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
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MyFont1',
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.settings, color: Colors.white),
                    onPressed: showOversDialog,
                  ),
                ],
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: scores.map((score) => buildCircle(score)).toList(),
              ),
              SizedBox(height: 20),
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
                    'Overs: $totalOvers / $maxOvers',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  padding: EdgeInsets.all(16),
                  children: [
                    for (var score in ['0', '1', '2', '3', '4', '6'])
                      buildButton(score, Colors.black, () => addScore(score)),
                    buildButton('WB', Colors.black, () => addScore('WB')),
                    buildButton('NB', Colors.black, () => addScore('NB')),
                    buildButton('OUT', Colors.red, () => addScore('W')),
                    buildButton('UNDO', Colors.green, undoLast),
                    buildButton('RESET', Colors.blue, resetMatch),
                  ],
                ),
              ),
            ],
          ),
        ],
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

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
}
