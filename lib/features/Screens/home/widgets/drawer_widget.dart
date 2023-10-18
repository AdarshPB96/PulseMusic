import 'package:flutter/material.dart';
import 'package:music_application_1/features/Screens/settings/aboutus.dart';
import 'package:music_application_1/features/Screens/settings/privacypolicy.dart';
import 'package:music_application_1/features/Screens/settings/terms_and_conditions.dart';
import 'package:share_plus/share_plus.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(
              Icons.privacy_tip,
              color: Colors.white,
            ),
            title: const Text(' Privacy ',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyScreen(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.article_outlined,
              color: Colors.white,
            ),
            title: const Text(
              'Tearms And Conditions ',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsScreen(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.info_outlined,
              color: Colors.white,
            ),
            title: const Text('About Us ',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutUsScreen(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.share,
              color: Colors.white,
            ),
            title: const Text(' Share ',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Share.share('Check out this amazing app!', subject: ''

                  // sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                  );
            },
          ),
        ],
      ),
    );
  }
}
