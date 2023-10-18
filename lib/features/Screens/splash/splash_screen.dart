import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:music_application_1/domain/models/songmodel.dart';
import 'package:music_application_1/features/Screens/splash/methods/methods.dart';
import 'package:music_application_1/features/bottom/bottom.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

final audioQuery = OnAudioQuery();
final box = SongBox.getInstance();

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isFirstOpen = false;

  @override
  void initState() {
    super.initState();
    checkFirstOpen();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage(
              'assets/images/pulse-music-low-resolution-color-logo.png'),
        ),
      ),
    );
  }

  Future<void> checkFirstOpen() async {
    PermissionStatus status = await Permission.storage.status;
    isFirstOpen = status.isGranted;

    if (!isFirstOpen) {
      await requestStoragePermission();
      await addSongsToDatabase();
      goToMyApp();
    } else {
      goToMyApp();
    }
  }

  Future<void> requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      addSongsToDatabase();
      goToMyApp();
    } else {
      log("[Permission denied]");
      // Permission denied
    }
  }



  Future<void> goToMyApp() async {
    await Future.delayed(const Duration(seconds: 3));
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (ctx) => const BottomNavBar()),
    );
  }
}
