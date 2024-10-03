import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappybirds/components/pipe.dart';
import 'package:flappybirds/game/configuration.dart';
import 'package:flappybirds/game/pipe_position.dart';

import '../game/assets.dart';
import '../game/flappy_bird_game.dart';

class PipeGroup extends PositionComponent with HasGameRef<FlappyBirdGame> {
  PipeGroup();

  final _random = Random();

  @override
  Future<void> onLoad() async {
    position.x = gameRef.size.x;

    final heightMinusGround = gameRef.size.y - Config.groundHeight;
    final spacing = 100 + _random.nextDouble() * (heightMinusGround / 4);

    final centerY =
        spacing + _random.nextDouble() * (heightMinusGround - spacing / 1);
    addAll(
      [
        Pipe(pipePosition: PipePosition.top, height: centerY - spacing / 1),
        Pipe(
          pipePosition: PipePosition.bottom,
          height: heightMinusGround - (centerY + spacing / 3),
        ),
      ],
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Config.gameSpeed * dt;

    if (position.x < -10) {
      removeFromParent();
      updateScore();
    }
    if (gameRef.isHit) {
      removeFromParent();
      gameRef.isHit = false;
    }
  }

  void updateScore() {
    gameRef.bird.scr += 1;
    FlameAudio.play(Assets.point);
  }
}
