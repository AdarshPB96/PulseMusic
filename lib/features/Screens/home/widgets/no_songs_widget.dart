import 'package:flutter/material.dart';

class NoSongsWidget extends StatelessWidget {
  const NoSongsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Column(
          children: [
            Text(
              'No Songs',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'suggestion : Try to restart the app',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
  }
}
