import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LiveScorePage extends StatefulWidget {
  @override
  _LiveScorePageState createState() => _LiveScorePageState();
}

class _LiveScorePageState extends State<LiveScorePage> {
  late Future<List<MatchData>> futureMatches;

  @override
  void initState() {
    super.initState();
    futureMatches = fetchLiveScores();
  }

  Future<List<MatchData>> fetchLiveScores() async {
    try {
      final response = await http.get(Uri.parse('https://api.cricapi.com/v1/cricScore?apikey=53112dc5-0020-4a5c-8b5a-12b3b414ef69'));

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);

          if (data['data'] != null) {
            List<MatchData> matches = [];
            for (var match in data['data']) {
              matches.add(MatchData.fromJson(match));
            }
            return matches;
          } else {
            throw Exception('Failed to load data or no data available');
          }
        } catch (e) {
          throw Exception('Failed to parse response body: $e');
        }
      } else {
        throw Exception('Failed to load live scores: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Live Matches',
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.bold,
                fontFamily: 'MyFont1',
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/Background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 100),
            child: FutureBuilder<List<MatchData>>(
              future: futureMatches,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No live scores available.', style: TextStyle(color: Colors.white)));
                } else {
                  var matches = snapshot.data!;
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(), // This makes the scrolling smooth
                    child: Column(
                      children: matches.map((match) {
                        return Card(
                          margin: EdgeInsets.all(8),
                          color: Colors.transparent,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                    child: Container(
                                      color: Colors.blueGrey.withOpacity(0.2),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Image.network(
                                        match.t1img,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, progress) {
                                          if (progress == null) {
                                            return child;
                                          } else {
                                            return Center(child: CircularProgressIndicator());
                                          }
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/placeholder_flag.png',
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${match.t1} vs ${match.t2}',
                                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              '${match.status} - ${match.series}',
                                              style: TextStyle(color: Colors.white, fontSize: 14),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              match.dateTime,
                                              style: TextStyle(color: Colors.white, fontSize: 14),
                                            ),
                                            SizedBox(height: 8),
                                            match.score != null
                                                ? Text(
                                              'Score: ${match.score}',
                                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                            )
                                                : Container(),
                                            SizedBox(height: 16),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    pageBuilder: (context, animation, secondaryAnimation) => MatchDetailPage(match: match),
                                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                      const begin = Offset(1.0, 0.0);
                                                      const end = Offset.zero;
                                                      const curve = Curves.easeInOut;

                                                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                                      var offsetAnimation = animation.drive(tween);

                                                      return SlideTransition(position: offsetAnimation, child: child);
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'View Details',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.teal,
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
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MatchData {
  final String id;
  final String t1;
  final String t2;
  final String status;
  final String series;
  final String dateTime;
  final String t1img;
  final String t2img;
  final String? score;

  MatchData({
    required this.id,
    required this.t1,
    required this.t2,
    required this.status,
    required this.series,
    required this.dateTime,
    required this.t1img,
    required this.t2img,
    this.score,
  });

  factory MatchData.fromJson(Map<String, dynamic> json) {
    return MatchData(
      id: json['id'] ?? '',
      t1: json['t1'] ?? '',
      t2: json['t2'] ?? '',
      status: json['status'] ?? '',
      series: json['series'] ?? '',
      dateTime: json['dateTimeGMT'] ?? '',
      t1img: json['t1img'] ?? 'assets/placeholder_flag.png',
      t2img: json['t2img'] ?? 'assets/placeholder_flag.png',
      score: json['score'] ?? null,
    );
  }
}

class MatchDetailPage extends StatelessWidget {
  final MatchData match;

  MatchDetailPage({required this.match});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Match Details',
          style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Myfont1'),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/Background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(), // Smooth scrolling added here as well
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '${match.t1} vs ${match.t2}',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Myfont2'),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Match Status: ${match.status}',
                    style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'Myfont2'),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Score: ${match.score ?? 'N/A'}',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Series: ${match.series}',
                    style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Myfont2'),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Date and Time: ${match.dateTime}',
                    style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Myfont2'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Team 1: ${match.t1}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Myfont2'),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Image.network(
                      match.t1img,
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/placeholder_flag.png', width: 50, height: 50);
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Team 2: ${match.t2}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Myfont2'),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Image.network(
                      match.t2img,
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/placeholder_flag.png', width: 50, height: 50);
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Refresh Score',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Myfont2',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
