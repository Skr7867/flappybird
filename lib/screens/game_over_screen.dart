// ignore_for_file: library_private_types_in_public_api

import 'dart:async'; // Import for Timer
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_number/mobile_number.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../game/assets.dart';
import '../game/flappy_bird_game.dart';
import '../main.dart';

class GameOverScreen extends StatefulWidget {
  final FlappyBirdGame game;
  static const String id = 'gameOver';

  const GameOverScreen({
    super.key,
    required this.game,
  });

  @override
  _GameOverScreenState createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  String mobileNumber = ''; // Variable to store the fetched mobile number
  List<SimCard> simCards = []; // List to store SIM card information
  bool isLoading = true;
  bool isRestartButtonEnabled = false; // Track if Restart button is enabled
  bool isLeaderboardButtonEnabled =
      false; // Track if Leaderboard button is enabled
  final InterstitialAdManager adManager = InterstitialAdManager();
  int highestScore = 0;
  int countdown = 5; // 5-second countdown
  late Timer countdownTimer;

  @override
  void initState() {
    super.initState();
    _getMobileNumber(); // Fetch the mobile number
    adManager
        .loadInterstitialAd(); // Load the interstitial ad when the screen is loaded
    _loadHighestScore(); // Load the highest score from SharedPreferences
    _startButtonTimers(); // Start timers for buttons
    _startCountdown(); // Start the countdown
  }

  // Start a timer that will enable the Restart and Leaderboard buttons after 5 seconds
  void _startButtonTimers() {
    setState(() {
      isRestartButtonEnabled = false; // Disable the Restart button initially
      isLeaderboardButtonEnabled =
          false; // Disable the Leaderboard button initially
    });
    Timer(const Duration(seconds: 5), () {
      setState(() {
        isRestartButtonEnabled =
            true; // Enable the Restart button after 5 seconds
        isLeaderboardButtonEnabled =
            true; // Enable the Leaderboard button after 5 seconds
      });
    });
  }

  // Start a countdown for 5 seconds to show the remaining time
  void _startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          countdownTimer.cancel(); // Stop the countdown when it reaches 0
        }
      });
    });
  }

  // Request phone permission and fetch mobile number and SIM card info
  void _getMobileNumber() async {
    // Check if phone permission is granted using permission_handler
    var status = await Permission.phone.status;

    // If permission is denied, request it
    if (!status.isGranted) {
      status = await Permission.phone.request();
    }

    if (status.isGranted) {
      try {
        // Get mobile number using mobile_number plugin
        mobileNumber = await MobileNumber.mobileNumber ?? "mobile number null";

        if (mobileNumber.isNotEmpty) {
          log('Mobile number fetched: $mobileNumber');
          if (highestScore >= 400 && mobileNumber.isNotEmpty) {
            _sendScoreToServer(highestScore, mobileNumber);
          }
        } else {
          log('Failed to fetch mobile number.');
        }

        // Get SIM card information
        simCards = await MobileNumber.getSimCards ?? [];

        for (var sim in simCards) {
          log('SIM Card Info:  ${sim.number}');
        }
      } catch (e) {
        log('Failed to fetch mobile number or SIM cards: $e');
      }
    } else {
      // If permission is permanently denied, open the app settings
      if (status.isPermanentlyDenied) {
        openAppSettings();
      }
    }

    // Ensure the widget is mounted before calling setState
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  // Load the highest score from SharedPreferences
  Future<void> _loadHighestScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      highestScore =
          prefs.getInt('highestScore') ?? 0; // Load the highest score
    });
    _updateHighestScore(); // Check if the new score exceeds the highest score
  }

  // Update the highest score based on the current game session score
  Future<void> _updateHighestScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentScore = widget.game.bird.scr; // Current score from the game

    // Add the current score to the previous highest score
    highestScore += currentScore;

    // Save the updated highest score
    await prefs.setInt('highestScore', highestScore);
    setState(() {
      // Update the UI with the new highest score
    });
  }

  // Function to sanitize the mobile number, removing any prefix like +91 or 91
  String _sanitizeMobileNumber(String mobileNumber) {
    // Check if the mobile number starts with +91 or 91, and strip it
    if (mobileNumber.startsWith('+91')) {
      return mobileNumber.substring(3); // Remove the '+91' prefix
    } else if (mobileNumber.startsWith('91')) {
      return mobileNumber.substring(2); // Remove the '91' prefix
    }
    return mobileNumber; // Return as is if no prefix
  }

  // Function to send the score and mobile number to the server
  Future<void> _sendScoreToServer(int highestScore, String mobile) async {
    const String apiUrl = 'https://bossapp.in/game/update_score_game.php';

    try {
      // Sanitize the mobile number to remove any prefixes like +91 or 91
      String sanitizedMobile = _sanitizeMobileNumber(mobile);

      // Make the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'scr': highestScore.toString(), // Send the score as a parameter
          'mob':
              sanitizedMobile, // Send the sanitized mobile number as a parameter
        },
      );

      if (response.statusCode == 200) {
        log('Score and mobile number sent successfully: Score = $highestScore, Mobile = $sanitizedMobile');
      } else {
        log('Failed to send score and mobile number: ${response.statusCode}');
      }
    } catch (error) {
      log('$error');
    }
  }

  @override
  void dispose() {
    countdownTimer
        .cancel(); // Cancel the countdown timer when the widget is disposed
    adManager.dispose();
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
              'Score: ${widget.game.bird.scr}', // Display current score
              style: const TextStyle(
                fontSize: 60,
                color: Colors.white,
                fontFamily: 'Game',
              ),
            ),
            Text(
              'Max Score: $highestScore', // Display the highest score
              style: const TextStyle(
                fontSize: 60,
                color: Colors.white,
                fontFamily: 'Game',
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(Assets.gameOver),
            const SizedBox(height: 20),
            if (!isRestartButtonEnabled || !isLeaderboardButtonEnabled)
              Text(
                'Please wait: $countdown seconds',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                  fontFamily: 'Game',
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isRestartButtonEnabled
                  ? () {
                      if (adManager.isInterstitialAdReady) {
                        adManager.showInterstitialAd(
                          onAdClosed: () {
                            onRestart();
                          },
                        );
                      } else {
                        onRestart();
                      }
                    }
                  : null, // Disable button if not enabled
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Restart', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: isLeaderboardButtonEnabled
                  ? () {
                      if (adManager.isInterstitialAdReady) {
                        adManager.showInterstitialAd(
                          onAdClosed: () {
                            widget.game.overlays.remove('gameOver');
                            widget.game.overlays.add('profilePage');
                          },
                        );
                      } else {
                        widget.game.overlays.remove('gameOver');
                        widget.game.overlays.add('profilePage');
                      }
                    }
                  : null, // Disable button if not enabled
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Leaderboard', style: TextStyle(fontSize: 20)),
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
