import 'package:flappybirds/game/flappy_bird_game.dart';
import 'package:flutter/material.dart';

import '../game/assets.dart';
import 'main_menu_screen.dart';

class GameOverScreen extends StatefulWidget {
  final FlappyBirdGame game;
  static const String id = 'gameOver';

  GameOverScreen({
    Key? key,
    required this.game,
  }) : super(key: key);

  @override
  _GameOverScreenState createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  final InterstitialAdManager adManager = InterstitialAdManager();

  @override
  void initState() {
    super.initState();
    adManager
        .loadInterstitialAd(); // Load the interstitial ad when the screen is loaded
  }

  @override
  void dispose() {
    adManager
        .dispose(); // Dispose of the ad manager when this screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black38,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Score: ${widget.game.bird.scr}',
              style: const TextStyle(
                fontSize: 60,
                color: Colors.white,
                fontFamily: 'Game',
              ),
            ),
            Text(
              'Max Score: ${widget.game.bird.scr}',
              style: const TextStyle(
                fontSize: 60,
                color: Colors.white,
                fontFamily: 'Game',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset(Assets.gameOver),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (adManager.isInterstitialAdReady) {
                  adManager.showInterstitialAd(onAdClosed: onRestart);
                } else {
                  onRestart();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text(
                'Restart',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                adManager.showInterstitialAd(onAdClosed: () {
                  widget.game.overlays.remove('gameOver');
                  widget.game.overlays.add('profilePage');
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text(
                'Leaderboard',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onRestart() {
    widget.game.bird.reset(); // Reset the bird/game state
    widget.game.overlays.remove('gameOver'); // Remove the overlay
    widget.game.resumeEngine(); // Resume the game engine
  }
}
