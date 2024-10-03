import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart'; // Import for FlameAudio
import 'package:flappybirds/game/configuration.dart';
import 'package:flutter/material.dart';

import '../game/assets.dart';
import '../game/bird_movement.dart';
import '../game/flappy_bird_game.dart';

class Bird extends SpriteGroupComponent<BirdMovement>
    with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  Bird();

  int scr = 0; // Current score

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
