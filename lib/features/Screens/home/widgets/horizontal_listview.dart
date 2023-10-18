import 'package:flutter/material.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:music_application_1/features/Screens/favourites/favourites_screen.dart';
import 'package:music_application_1/features/Screens/mostly/mostlyplayed.dart';
import 'package:music_application_1/features/Screens/recently/recentlyplayed_screen.dart';

class HorizontalListview extends StatelessWidget {
  const HorizontalListview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              height: 60,
              width: 150,
              child: GradientElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          Recentlyplayedscreen()));
                },
                style: GradientElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF880E4F),
                      Color.fromARGB(255, 86, 158, 34),
                    ],
                    // begin: Alignment.topCenter,
                    // end: Alignment.bottomCenter,
                  ),
                ),
                child: const Text("Recently Played"),
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            SizedBox(
              height: 60,
              width: 150,
              child: GradientElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MostlyPlayed(),
                  ));
                },
                style: GradientElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF880E4F),
                      Color.fromARGB(255, 86, 158, 34),
                    ],
                    // begin: Alignment.topCenter,
                    // end: Alignment.bottomCenter,
                  ),
                ),
                child: const Text("Mostly Played"),
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            SizedBox(
              height: 60,
              width: 150,
              child: GradientElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FavouritesScreen(),
                  ));
                },
                style: GradientElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF880E4F),
                      Color.fromARGB(255, 86, 158, 34),
                    ],
                    // begin: Alignment.topCenter,
                    // end: Alignment.bottomCenter,
                  ),
                ),
                child: const Text("Favourites"),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ],
    );
  }
}