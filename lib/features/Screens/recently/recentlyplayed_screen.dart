import 'package:flutter/material.dart';
import 'package:music_application_1/core/colors/colors.dart';
import 'package:music_application_1/domain/models/recentplayed.dart';
import 'package:music_application_1/features/Screens/miniplayer/miniplayer.dart';
import 'package:music_application_1/features/Screens/recently/widgets/appbar.dart';
import 'package:music_application_1/features/Screens/recently/widgets/recently_listview_item.dart';

class Recentlyplayedscreen extends StatelessWidget {
   Recentlyplayedscreen({super.key});
  final box = RecentplayedBox.getinstance();
  @override
  Widget build(BuildContext context) {
    List<RecentlyPlayed> rplayedlist = box.values.toList().reversed.toList();
    return Scaffold(
      appBar: appBarRecently(context),
      body: Container(
        decoration: containerColor(),
        child: Column(children: [
          Expanded(
            child:  rplayedlist.isNotEmpty
                      ? ListView.separated(
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          itemBuilder: (context, index) => RecentlyPlayedlist(
                              song: rplayedlist[index % rplayedlist.length],
                              songlist: rplayedlist,
                              index: index),
                          itemCount: rplayedlist.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            "Your Recent played songs will appear here!",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
          ),
        ]),
      ),
      bottomSheet: const MiniPlayer(),
    );
  }
}

