// // ignore_for_file: use_build_context_synchronously

// import 'package:music_application_1/function/fetch.dart';
// import 'package:flutter/material.dart';
// import 'package:music_application_1/models/songmodel.dart';
// import 'package:on_audio_query/on_audio_query.dart';

// import '../widget/Bottom.dart';

// // List<SongModel> allSongs = [];

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({
//     super.key,
//   });

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// final audioquery = OnAudioQuery();
// final box = SongBox.getInstance();

// final hivebox = SongBox.getInstance();

// List<SongModel> allSongs = [];

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     wait();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Padding(
//           padding: EdgeInsets.only(left: 28),
//           child: Image(
//             image: AssetImage(
//               'assets/images/MusicAppLogo.png',
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> goToMyApp() async {
//     await Future.delayed(const Duration(seconds: 3));
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (ctx) => const BottomNavBar()),
//     );
//   }

//   wait() async {
//     Fetching fetchingvar = Fetching();
//     await fetchingvar.requeststoragePermission();
//     goToMyApp();
//   }
// }

import 'package:flutter/material.dart';
import 'package:music_application_1/function/dbfunctions.dart';
import 'package:music_application_1/models/mostplayeddb.dart';
import 'package:music_application_1/models/songmodel.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widget/Bottom.dart';

final audioQuery = OnAudioQuery();
final box = SongBox.getInstance();

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isFirstOpen = false; // Flag to indicate if it's the first app open

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
          image: AssetImage('assets/images/pulse-music-low-resolution-color-logo.png'),
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
      // Permission denied
    }
  }

  Future<void> addSongsToDatabase() async {
    List<SongModel> fetchedSongs = await audioQuery.querySongs();
    List<Songs> songsToAdd = [];

    for (var element in fetchedSongs) {
      if (element.fileExtension == 'mp3') {
        songsToAdd.add(
          Songs(
            songname: element.title,
            artist: element.artist,
            duration: element.duration,
            songurl: element.uri,
            id: element.id,
          ),
        );
        for (var element in songsToAdd) {
          box.put(
              element.id,
              Songs(
                  songname: element.songname,
                  artist: element.artist,
                  duration: element.duration,
                  songurl: element.songurl,
                  id: element.id));

          mostplayeddb.put(
              element.id,
              MostPlayed(
                  songname: element.songname,
                  artist: element.artist,
                  duration: element.duration,
                  songurl: element.songurl,
                  count: 0,
                  id: element.id));

          mostplayeddb.put(
              element.id,
              MostPlayed(
                  songname: element.songname,
                  artist: element.artist,
                  duration: element.duration,
                  songurl: element.songurl,
                  count: 0,
                  id: element.id));
        }
      }
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
