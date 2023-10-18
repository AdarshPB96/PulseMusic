import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_application_1/core/colors/colors.dart';
import 'package:music_application_1/core/constants/constant_size.dart';
import 'package:music_application_1/domain/models/songmodel.dart';
import 'package:music_application_1/features/Screens/home/widgets/drawer_widget.dart';
import 'package:music_application_1/features/Screens/home/widgets/horizontal_listview.dart';
import 'package:music_application_1/features/Screens/home/widgets/no_songs_widget.dart';
import 'package:music_application_1/features/Screens/home/widgets/songlist_widget.dart';
import 'package:music_application_1/features/Screens/splash/splash_screen.dart';
import '../miniplayer/miniplayer.dart';

List<Audio> audioList = [];
final AssetsAudioPlayer audioPlayer1 = AssetsAudioPlayer.withId('0');

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Songs> mysongs = box.values.toList();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _globalKey,
        drawer: const DrawerWidget(),
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              _globalKey.currentState!.openDrawer();
            },
            icon: const Icon(Icons.menu),
            color: Colors.white,
          ),
          title: const Text("Home"),
        ),
        body: Container(
          decoration: containerColor(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 70,
                width: 500,
                child: HorizontalListview(),
              ),

              const Padding(
                padding: EdgeInsets.only(left: 10, top: 8),
                child: Text(
                  'Songs',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              sizedBoxH15,
              Expanded(
                  child: mysongs.isNotEmpty
                      ? ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
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
                      : const NoSongsWidget())
            ],
          ),
        ),
        bottomSheet: const MiniPlayer(),
      ),
    );
  }
}




