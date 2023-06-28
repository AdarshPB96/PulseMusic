import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:music_application_1/function/add_to_favourites.dart';

import 'package:music_application_1/models/fav_model.dart';
import 'package:music_application_1/provider/fav_provider.dart';
import 'package:music_application_1/widget/functions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../function/dbfunctions.dart';
import '../widget/playerfunction.dart';
import 'home.dart';
import 'now_playing_screen.dart';

//  final List<FavModel> allFavSongs = favouritesdb.values.toList();

class FavouritesScreen extends StatelessWidget {
  FavouritesScreen({super.key});

  final box = Favouritesbox.getInstance();

  @override
  Widget build(BuildContext context) {
    // final favpro = Provider.of<Favprovider>(context);
    // final List<FavModel> allFavSongs = favouritesdb.values.toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Favourites'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black38, Color(0xFF880E4F)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Column(children: [
          Consumer<Favprovider>(
            builder: (context, value, child) {
              final List<FavModel> favitemsongs = value.getFavItemSongs();
              return Expanded(
                  child: favitemsongs.isNotEmpty
                      ? ListView.separated(
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          itemBuilder: (context, index) {
                            return ListTile(
      
      onTap: () {
        audioPlayer.stop();
        audioList.clear();
        for (FavModel item in favitemsongs) {
          audioList.add(Audio.file(item.songurl!,
              metas: Metas(
                title: item.songname,
                artist: item.artist,
                id: item.id.toString(),
              )));
        }
        playingaudio(context, index);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      leading: QueryArtworkWidget(
        id: favitemsongs[index].id!,
        size: 3000,
        artworkFit: BoxFit.cover,
        type: ArtworkType.AUDIO,
        artworkBorder: BorderRadius.circular(10),
        artworkQuality: FilterQuality.high,
        nullArtworkWidget: const Image(
          width: 50,
          height: 50,
          image: AssetImage(
            'assets/images/pulse-music-low-resolution-color-logo.png',
          ),
        ),
      ),
      title: Marquee(
        child: Text(
          favitemsongs[index].songname!,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      subtitle: Marquee(
        child: Text(favitemsongs[index].artist.toString(),
            style: const TextStyle(color: Colors.white)),
      ),
      trailing: IconButton(
          onPressed: () {
            value.removeFav(favitemsongs[index].id,context);
          },
          icon: const Icon(Icons.remove, color: Colors.white)),
    );
                          },
                          itemCount: favitemsongs.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            "You haven't liked any Songs",
                            style: TextStyle(color: Colors.white),
                          ),
                        ));
            },
          ),
        ]),
      ),
    );
  }
}
