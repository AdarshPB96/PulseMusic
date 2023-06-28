import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_application_1/Screens/AboutUs.dart';
import 'package:music_application_1/Screens/MostlyPlayed.dart';
import 'privacypolicy.dart';
import 'package:music_application_1/Screens/RecentlyPlayedScreen.dart';
import 'terms_and_conditions.dart';

import 'package:music_application_1/Screens/favourites_screen.dart';
import 'package:music_application_1/Screens/splash_screen.dart';
import 'package:music_application_1/models/songmodel.dart';
import 'package:music_application_1/widget/functions.dart';
import 'package:share_plus/share_plus.dart';

import 'miniplayer.dart';

List<Audio> audioList = [];
final AssetsAudioPlayer audioPlayer1 = AssetsAudioPlayer.withId('0');

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});

  // ignore: non_constant_identifier_names
  late List<Songs> Allsongs;
  List<Songs> mysongs = box.values.toList();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      drawer: Drawer(
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
              title:
                  const Text(' Share ', style: TextStyle(color: Colors.white)),
              onTap: () {
                Share.share('Check out this amazing app!', subject: ''

                    // sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                    );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black38, Color(0xFF880E4F)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
              ),
              IconButton(
                onPressed: () {
                  _globalKey.currentState!.openDrawer();
                },
                icon: const Icon(Icons.menu),
                color: Colors.white,
              ),
              // const SizedBox(
              //   height: 15,
              // ),
              SizedBox(
                height: 70,
                width: 500,
                child: ListView(
                  scrollDirection: Axis.horizontal,
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
                                     Recentlyplayedscreen()
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
                                builder: (context) =>  MostlyPlayed(),
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
                                builder: (context) =>  FavouritesScreen(),
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
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(left: 10, top: 8),
                child: Text(
                  'Songs',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                
                  

                  child: mysongs.isNotEmpty
                      ? ListView.separated(
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          itemBuilder: (context, index) => SongsList(
                            index: index,
                            song: mysongs[index],
                            songlist: mysongs,
                          ),
                          itemCount: mysongs.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            );
                          },
                        )
                      : Center(
                          child: Column(
                            children: const [
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
                        )
                
              )
            ],
          ),
        ),
      ),
      bottomSheet: const MiniPlayer(),
    );
  }
}
