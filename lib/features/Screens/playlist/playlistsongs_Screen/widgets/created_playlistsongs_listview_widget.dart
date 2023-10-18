import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:music_application_1/features/Screens/home/home.dart';
import 'package:music_application_1/features/Screens/nowplaying/now_playing_screen.dart';
import 'package:music_application_1/domain/function/playerfunction.dart';
import 'package:on_audio_query/on_audio_query.dart';

ListView createdPlaylistSongsListview(
    List playlistelementsonglist, Function removefromplaylist) {
  return ListView.separated(
      itemBuilder: (context, index) {
        return ListTile(
          tileColor: Colors.grey,
          onTap: () {
            audioPlayer.stop();
            audioList.clear();
            for (var item in playlistelementsonglist) {
              audioList.add(Audio.file(item.songurl!,
                  metas: Metas(
                    title: item.songname,
                    artist: item.artist,
                    id: item.id.toString(),
                  )));
            }
            playingaudio(context, index);
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          leading: QueryArtworkWidget(
            id: playlistelementsonglist[index].id!,
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
              playlistelementsonglist[index].songname!,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          subtitle: Marquee(
            child: Text(playlistelementsonglist[index].artist!,
                style: const TextStyle(color: Colors.white)),
          ),
          trailing: PopupMenuButton(
            color: Colors.white,
            itemBuilder: (context) => [
              PopupMenuItem(
                  child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // removefromplaylist(index, element!.playlistName);
                  removefromplaylist(index);
                },
                child: const Text('Remove From Playlist'),
              )),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 5,
        );
      },
      itemCount: playlistelementsonglist.length);
}
