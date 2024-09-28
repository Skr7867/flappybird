// import 'dart:convert';

// import 'package:flame/collisions.dart';
// import 'package:flame/components.dart';
// import 'package:flame/effects.dart';
// import 'package:flame_audio/flame_audio.dart'; // Import for FlameAudio
// import 'package:flappybirds/game/configuration.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:sms_autofill/sms_autofill.dart';

// import '../game/assets.dart';
// import '../game/bird_movement.dart';
// import '../game/flappy_bird_game.dart';

// class Bird extends SpriteGroupComponent<BirdMovement>
//     with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
//   Bird();
//   String mob = "";
//   int scr = 0;

//   // Function to autofill or manually enter phone number
//   Future<void> getmob() async {
//     try {
//       String? mobileNumber = await SmsAutoFill().hint;
//       if (mobileNumber != null) {
//         mob = mobileNumber;
//       } else {
//         mob = "Please enter your phone number";
//       }
//     } catch (e) {
//       mob = "Error retrieving phone number";
//     }
//   }

//   // Function to send score to your server when the score reaches 1000
//   Future<void> _sendScore() async {
//     if (scr >= 2) {
//       // Adjusted condition to 1000 or whatever threshold you need
//       String url =
//           "https://bossapp.in/game/update_score_game.php"; // Change this to your server URL

//       var response = await http.post(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "mob": mob,
//           "scr": scr,
//         }),
//       );
//       if (response.statusCode == 200) {
//         print('Score sent successfully');
//       } else {
//         print('Failed to send score');
//       }
//     }
//   }

//   // Sample function to simulate score change
//   void increaseScore() {
//     scr += 5; // Adjust score increment based on game logic
//     if (scr >= 2) {
//       _sendScore();
//     }
//   }

//   @override
//   Future<void> onLoad() async {
//     // Load bird sprites
//     final birdMidFlap = await gameRef.loadSprite(Assets.birdMidFlap);
//     final birdUpFlap = await gameRef.loadSprite(Assets.birdUpFlap);
//     final birdDownFlap = await gameRef.loadSprite(Assets.birdDownFlap);

//     size = Vector2(52, 40);
//     position = Vector2(50, gameRef.size.y / 2 - size.y / 2);

//     // Assign sprites to different bird movements
//     sprites = {
//       BirdMovement.middle: birdMidFlap,
//       BirdMovement.up: birdUpFlap,
//       BirdMovement.down: birdDownFlap,
//     };
//     current = BirdMovement.middle;

//     // Add a hitbox for collision detection
//     add(CircleHitbox());

//     // Preload the flying sound
//     await FlameAudio.audioCache.load(Assets.flying);
//   }

//   void fly() {
//     // Create a fly movement effect for the bird
//     add(
//       MoveByEffect(
//         Vector2(0, Config.gravity),
//         EffectController(duration: 0.2, curve: Curves.decelerate),
//         onComplete: () => current = BirdMovement.down,
//       ),
//     );
//     current = BirdMovement.up;

//     // Play flying sound
//     FlameAudio.play(Assets.flying);
//   }

//   @override
//   void onCollisionStart(
//     Set<Vector2> intersectionPoints,
//     PositionComponent other,
//   ) {
//     super.onCollisionStart(intersectionPoints, other);
//     gameOver();
//   }

//   void reset() {
//     // Reset the bird position and score
//     position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
//     scr = 0;
//   }

//   void gameOver() {
//     // Display game over overlay and pause the game
//     FlameAudio.play(Assets.collision);
//     gameRef.overlays.add('gameOver');
//     gameRef.pauseEngine();
//     gameRef.isHit = true;
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);
//     // Apply bird velocity to position
//     position.y += Config.birdVelocity * dt;
//     if (position.y < 1) {
//       gameOver();
//     }
//   }
// }

import 'dart:convert';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart'; // Import for FlameAudio
import 'package:flappybirds/game/configuration.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sms_autofill/sms_autofill.dart';
import '../game/assets.dart';
import '../game/bird_movement.dart';
import '../game/flappy_bird_game.dart';

class Bird extends SpriteGroupComponent<BirdMovement>
    with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  Bird();

  String mob = ""; // Store mobile number here
  int scr = 0; // Current score
  int highestScr = 0;

  Future<void> getmob() async {
    try {
      String? mobileNumber = await SmsAutoFill().hint;
      if (mobileNumber != null) {
        mob = mobileNumber;
      } else {
        mob = "Please enter your phone number";
      }
    } catch (e) {
      mob = "Error retrieving phone number";
    }
  }

  // Function to send the highest score to the server
  Future<void> _sendScore() async {
    if (highestScr >= 3 && mob.isNotEmpty) {
      // Ensure a valid score and phone number
      String url = "https://bossapp.in/game/update_score_game.php";

      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "mob": mob,
          "scr": highestScr,
        }),
      );
      if (response.statusCode == 200) {
        print('Score sent successfully');
      } else {
        print('Failed to send score: ${response.statusCode}, ${response.body}');
      }
    }
  }

  // Function to update score and check for a new highest score
  void increaseScore() {
    scr += 5; // Adjust score increment based on game logic

    // If the current score exceeds the highest score, update and send it
    if (scr > highestScr) {
      highestScr = scr;
      print("New highest score: $highestScr");
      _sendScore(); // Send the new highest score
    }
  }

  @override
  Future<void> onLoad() async {
    // Load bird sprites
    final birdMidFlap = await gameRef.loadSprite(Assets.birdMidFlap);
    final birdUpFlap = await gameRef.loadSprite(Assets.birdUpFlap);
    final birdDownFlap = await gameRef.loadSprite(Assets.birdDownFlap);

    size = Vector2(52, 40);
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);

    // Assign sprites to different bird movements
    sprites = {
      BirdMovement.middle: birdMidFlap,
      BirdMovement.up: birdUpFlap,
      BirdMovement.down: birdDownFlap,
    };
    current = BirdMovement.middle;

    // Add a hitbox for collision detection
    add(CircleHitbox());

    // Preload the flying sound
    await FlameAudio.audioCache.load(Assets.flying);
  }

  void fly() {
    // Create a fly movement effect for the bird
    add(
      MoveByEffect(
        Vector2(0, Config.gravity),
        EffectController(duration: 0.2, curve: Curves.decelerate),
        onComplete: () => current = BirdMovement.down,
      ),
    );
    current = BirdMovement.up;

    // Play flying sound
    FlameAudio.play(Assets.flying);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    gameOver();
  }

  void reset() {
    // Reset the bird position and current score
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    scr = 0;
  }

  void gameOver() {
    // Display game over overlay and pause the game
    FlameAudio.play(Assets.collision);
    gameRef.overlays.add('gameOver');
    gameRef.pauseEngine();
    gameRef.isHit = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Apply bird velocity to position
    position.y += Config.birdVelocity * dt;
    if (position.y < 1) {
      gameOver();
    }
  }
}
