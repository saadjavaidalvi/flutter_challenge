import 'package:flutter/material.dart';
import 'package:flutter_challenge/middlewares/dog_breeds.dart';
import 'package:flutter_challenge/pages/home_screen.dart';
import 'package:flutter_challenge/utils/assets_strings.dart';

class SpashScreen extends StatefulWidget {
  const SpashScreen({super.key});

  @override
  State<SpashScreen> createState() => _SpashScreenState();
}

class _SpashScreenState extends State<SpashScreen> {
  bool isLoading = true;
  Map breadsData = {};
  @override
  void initState() {
    super.initState();
    DogBreeds().getAllBreeds().then((value) {
      breadsData = value;
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? HomeScreen(breadsData)
        : Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AssetString().runningDogGif,
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
