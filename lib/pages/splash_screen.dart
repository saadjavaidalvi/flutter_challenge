import 'package:flutter/material.dart';
import 'package:flutter_challenge/middlewares/get_breeds.dart';
import 'package:flutter_challenge/pages/home_screen.dart';

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
        : const Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              ],
            ),
          );
  }
}
