import 'package:flutter/material.dart';

import '../CustomeButton/custom_button.dart';
import '../game/flappy_bird_game.dart';
import '../main.dart';
import 'user_model.dart';

class ProfilePage extends StatefulWidget {
  final FlappyBirdGame game;
  final InterstitialAdManager adManager = InterstitialAdManager();
  static const String id = 'profilePage'; // Route identifier

  ProfilePage({
    Key? key,
    required this.game,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    widget.adManager.loadInterstitialAd();
  }

  @override
  void dispose() {
    widget.adManager.dispose(); // Dispose of the ad when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/leaderboard.png",
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 25,
                  child: Image.asset(
                    "assets/images/line.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.9,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: userItems.length,
                itemBuilder: (context, index) {
                  final items = userItems[index];
                  return Padding(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, bottom: 15),
                    child: Row(
                      children: [
                        Text(
                          items.rank,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 15),
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(items.image),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          items.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          height: 25,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 5),
                              const RotatedBox(
                                quarterTurns: 1,
                                child: Icon(
                                  Icons.back_hand,
                                  color: Color.fromARGB(255, 255, 187, 0),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                items.point.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: 120,
            top: 680,
            child: CustomButton(
              text: 'Play',
              onPressed: () {
                widget.adManager.showInterstitialAd(onAdClosed: () {
                  widget.game.overlays.add('gameOver');
                });
                widget.game.overlays.remove('profilePage');
                widget.game.overlays.add('gameOver');
              },
            ),
          ),
          const Positioned(
            top: 50,
            left: 110,
            child: Text(
              "Leaderboard",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Rank 1st
          Positioned(
            top: 140,
            right: 130,
            child: rank(
              radius: 30.0,
              height: 10,
              image: "assets/images/g.jpeg",
              name: "Saddam Sir",
              point: "23131",
            ),
          ),
          // Rank 2nd
          Positioned(
            top: 140,
            left: 20,
            child: rank(
              radius: 30.0,
              height: 10,
              image: "assets/images/k.jpeg",
              name: "Amit Sir",
              point: "12323",
            ),
          ),
          // Rank 3rd
          Positioned(
            top: 140,
            right: 20,
            child: rank(
              radius: 30.0,
              height: 10,
              image: "assets/images/j.jpeg",
              name: "Rahul Sir",
              point: "6343",
            ),
          ),
        ],
      ),
    );
  }

  Column rank({
    required double radius,
    required double height,
    required String image,
    required String name,
    required String point,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundImage: AssetImage(image),
        ),
        SizedBox(height: height),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: height),
        Container(
          height: 25,
          width: 70,
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            children: [
              const SizedBox(width: 5),
              const Icon(
                Icons.back_hand,
                color: Color.fromARGB(255, 255, 187, 0),
              ),
              const SizedBox(width: 5),
              Text(
                point,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
