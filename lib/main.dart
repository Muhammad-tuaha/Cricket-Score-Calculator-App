import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'menu_page.dart';
import 'live_score_page.dart'; // Import the LiveScorePage
import 'calculate_score_page.dart'; // Import the ScoreCalculationPage
import 'ball_speed_page.dart'; // Import the BallSpeedPage
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CricScoreApp());
}

class CricScoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/menu': (context) => MenuPage(),
        '/live_score': (context) => LiveScorePage(), // Route to LiveScorePage
        '/calculate_score': (context) => ScoreCalculationPage(), // Route to ScoreCalculationPage
        '/ball_speed': (context) => BallSpeedPage(), // Route to BallSpeedPage
      },
      onGenerateRoute: (settings) {
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            Widget page;
            switch (settings.name) {
              case '/login':
                page = LoginPage();
                break;
              case '/signup':
                page = SignUpPage();
                break;
              case '/menu':
                page = MenuPage();
                break;
              case '/live_score':
                page = LiveScorePage();
                break;
              case '/calculate_score':
                page = ScoreCalculationPage();
                break;
              case '/ball_speed':
                page = BallSpeedPage();
                break;
              default:
                page = LoginPage();
            }
            return FadeTransition(
              opacity: animation,
              child: page,
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        );
      },
    );
  }
}
