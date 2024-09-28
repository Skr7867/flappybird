import 'package:flame/game.dart';
import 'package:flappybirds/game/flappy_bird_game.dart';
import 'package:flappybirds/screens/game_over_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'leaderboard/profile_page.dart';
import 'screens/main_menu_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  final game = FlappyBirdGame();
  runApp(
    GameWidget(
      game: game,
      initialActiveOverlays: const [
        'mainMenu'
      ], // Fixed this part for consistency
      overlayBuilderMap: {
        'mainMenu': (context, _) => MainMenuScreen(game: game),
        'gameOver': (context, _) => GameOverScreen(game: game),
        'profilePage': (context, _) => ProfilePage(game: game),
      },
    ),
  );
}

// import 'package:flame/game.dart';
// import 'package:flappybirds/game/flappy_bird_game.dart';
// import 'package:flappybirds/screens/game_over_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// import 'authscreens/login_screen.dart';
// import 'authscreens/registration.dart';
// import 'leaderboard/profile_page.dart';
// import 'screens/main_menu_screen.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   MobileAds.instance.initialize();

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   final game = FlappyBirdGame();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/login',
//       routes: {
//         '/login': (context) => LoginScreen(game: game),
//         '/register': (context) => RegistrationScreen(game: game),
//         '/game': (context) => GamePage(),
//       },
//     );
//   }
// }

// class GamePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final game = FlappyBirdGame();

//     return Scaffold(
//       body: GameWidget(
//         game: game,
//         initialActiveOverlays: const ['mainMenu'],
//         overlayBuilderMap: {
//           'mainMenu': (context, _) => MainMenuScreen(game: game),
//           'gameOver': (context, _) => GameOverScreen(game: game),
//           'profilePage': (context, _) => ProfilePage(game: game),
//         },
//       ),
//     );
//   }
// }

class InterstitialAdManager {
  InterstitialAd? interstitialAd;
  bool isInterstitialAdReady = false;

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          'ca-app-pub-7730090131564483/7096656387', // Use your own Ad Unit ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;
          isInterstitialAdReady = true;
          print('Interstitial Ad loaded');
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial Ad failed to load: $error');
          isInterstitialAdReady = false;
        },
      ),
    );
  }

  void showInterstitialAd({required Null Function() onAdClosed}) {
    if (isInterstitialAdReady && interstitialAd != null) {
      interstitialAd!.show();
      interstitialAd = null;
      isInterstitialAdReady = false;
    } else {
      print('Interstitial Ad is not ready yet');
    }
  }

  void dispose() {
    interstitialAd?.dispose();
  }
}
