import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:music_application_1/domain/models/fav_model.dart';
import 'package:music_application_1/features/Screens/home/home.dart';
import 'package:music_application_1/features/Screens/nowplaying/now_playing_screen.dart';
import 'package:music_application_1/features/provider/fav_provider.dart';
import 'package:music_application_1/domain/function/playerfunction.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class Favouritelist extends StatelessWidget {
  final FavModel song;
 final List<FavModel> songlist;
  final Color? color;
  final int index;
  const Favouritelist(
      {super.key,
      required this.song,
      required this.songlist,
      this.color,
      required this.index});

 final bool isfav = false;
  @override
  Widget build(BuildContext context) {
    final vv = Provider.of<Favprovider>(context);

    return ListTile(
      tileColor: color ?? Colors.black,
      onTap: () {
        audioPlayer.stop();
        audioList.clear();
        for (FavModel item in songlist) {
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
        id: song.id!,
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
          song.songname!,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      subtitle: Marquee(
        child: Text(song.artist.toString(),
            style: const TextStyle(color: Colors.white)),
      ),
      trailing: IconButton(
          onPressed: () {
            vv.removeFav(song.id, context);
          },
          icon: const Icon(Icons.delete, color: Colors.white)),
    );
  }
}