// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flappybirds/widgets/custome_textfield.dart';
import 'package:flutter/material.dart';

import '../game/flappy_bird_game.dart';
import '../screens/main_menu_screen.dart';
import 'registration.dart';

class LoginScreen extends StatefulWidget {
  static String get id => 'loginScreen';
  final FlappyBirdGame game;

  const LoginScreen({
    Key? key,
    required this.game,
  }) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  // Form field controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.yellow.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.only(top: 150, left: 15, right: 15),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                Text(
                  'Welcome back!',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                CustomTextFormField(emailController: emailController),
                SizedBox(height: 16.0),

                // Password Field
                CustomTextFormField(emailController: passwordController),
                SizedBox(height: 24.0),

                // Login Button
                ElevatedButton(
                  onPressed: () {
                    // widget.game.overlays.remove('loginScreen');
                    // widget.game.overlays.add('mainMenu');

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainMenuScreen(game: widget.game),
                      ),
                    );

                    if (formKey.currentState!.validate()) {
                      // Process login data
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login successful!')),
                      );
                    }
                  },
                  child: Text('Login'),
                ),
                SizedBox(height: 16.0),

                // Create Account Text
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to Registration Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistrationScreen(
                            game: widget.game,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Don’t have an account? Create Account',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
