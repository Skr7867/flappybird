// import 'package:flame/components.dart';
// import 'package:flame/events.dart';
// import 'package:flame/game.dart';
// import 'package:flappybirds/components/ground.dart';
// import 'package:flappybirds/components/pipe_group.dart';
// import 'package:flutter/material.dart';

// import '../components/background.dart';
// import '../components/bird.dart';
// import 'configuration.dart';

// class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
//   FlappyBirdGame();
//   late Bird bird;
//   late TextComponent score;
//   Timer interval = Timer(Config.pipeInterval, repeat: true);
//   bool isHit = false;
//   @override
//   Future<void> onLoad() async {
//     addAll([
//       Background(),
//       Ground(),
//       bird = Bird(),
//       score = buildScore(),
//     ]);

//     interval.onTick = () => add(PipeGroup());
//   }

//   TextComponent buildScore() {
//     return TextComponent(
//       text: 'Score: 0',
//       position: Vector2(size.x / 2, size.y / 2 * 0.2),
//       anchor: Anchor.center,
//       textRenderer: TextPaint(
//         style: const TextStyle(
//           fontSize: 40,
//           fontWeight: FontWeight.bold,
//           fontFamily: 'Game',
//         ),
//       ),
//     );
//   }

//   @override
//   void onTap() {
//     super.onTap();
//     bird.fly();
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);
//     interval.update(dt);

//     score.text = 'Score: ${bird.scr}';
//   }
// }

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flappybirds/components/ground.dart';
import 'package:flappybirds/components/pipe_group.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // Import for Google Ads

import '../components/background.dart';
import '../components/bird.dart';
import 'configuration.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  FlappyBirdGame();

  late Bird bird;
  late TextComponent score;
  Timer interval = Timer(Config.pipeInterval, repeat: true);
  bool isHit = false;

  // Banner Ad variable
  late BannerAd _bannerAd;
  bool isBannerAdLoaded = false;

  @override
  Future<void> onLoad() async {
    addAll([
      Background(),
      Ground(),
      bird = Bird(),
      score = buildScore(),
    ]);

    interval.onTick = () => add(PipeGroup());

    // Initialize the banner ad
    _loadBannerAd();
  }

  // Load the banner ad
  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: "ca-app-pub-7730090131564483/6401687661",
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {},
      ),
    );

    _bannerAd.load();
  }

  @override
  void onTap() {
    super.onTap();
    bird.fly();
  }

  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt);

    score.text = 'Score: ${bird.scr}';
  }

  @override
  void onRemove() {
    super.onRemove();
    // Dispose the banner ad when the game is removed
    _bannerAd.dispose();
  }

  TextComponent buildScore() {
    return TextComponent(
      text: 'Score: 0',
      position: Vector2(size.x / 2, size.y / 2 * 0.2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          fontFamily: 'Game',
        ),
      ),
    );
  }

  void setState(Null Function() param0) {}
}
