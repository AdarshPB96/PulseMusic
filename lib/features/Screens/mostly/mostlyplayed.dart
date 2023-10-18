import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_application_1/core/colors/colors.dart';
import 'package:music_application_1/domain/models/mostplayeddb.dart';
import 'package:music_application_1/features/Screens/miniplayer/miniplayer.dart';
import 'package:music_application_1/features/Screens/mostly/widgets/mostlylist_item.dart';

class MostlyPlayed extends StatelessWidget {
  MostlyPlayed({super.key});

  final box = MostPlayedBox.getInstance();
  final List<Audio> songs = [];
  final List<MostPlayed> mostfinalsongs = [];
  @override
  Widget build(BuildContext context) {
    initializeData();
    return Scaffold(
        appBar: mostlyAppbar(context),
        body: Container(
          decoration: containerColor(),
          child: Column(children: [
            Expanded(
              child: ValueListenableBuilder<Box<MostPlayed>>(
                  valueListenable: box.listenable(),
                  builder: (context, value, child) {
                    return mostfinalsongs.isNotEmpty
                        ? ListView.separated(
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            itemBuilder: (context, index) => MostPlayedList(
                                song: mostfinalsongs[index],
                                songlist: mostfinalsongs,
                                index: index),
                            itemCount: mostfinalsongs.length,
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              "Your most played songs will appear here!`",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                  }),
            ),
          ]),
        ),
        bottomSheet: const MiniPlayer());
  }

  AppBar mostlyAppbar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Mostly Played'),
        centerTitle: true,
      );
  }

  void initializeData() {
    List<MostPlayed> songlist = box.values.toList();
    int i = 0;
    for (MostPlayed items in songlist) {
      if (items.count > 3) {
        mostfinalsongs.insert(i, items);
        i++;
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeData();
    });
  }
}
