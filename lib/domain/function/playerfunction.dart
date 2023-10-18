import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_application_1/features/Screens/home/home.dart';
import 'package:music_application_1/features/Screens/nowplaying/now_playing_screen.dart';

playingaudio(context, int index) async {
  await audioPlayer
      .open(
        Playlist(audios: audioList, startIndex: index),loopMode: LoopMode.playlist,showNotification: true);
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) =>  ScreenNowPlaying()));
}
