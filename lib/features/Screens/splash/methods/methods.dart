  import 'dart:developer';

import 'package:music_application_1/domain/function/dbfunctions.dart';
import 'package:music_application_1/domain/models/mostplayeddb.dart';
import 'package:music_application_1/domain/models/songmodel.dart';
import 'package:music_application_1/features/Screens/splash/splash_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

Future<List<SongModel>> fetchSongs() async {
    try {
      final fetchedSongs = await audioQuery.querySongs();
      // ignore: unnecessary_null_comparison
      if (fetchedSongs != null) {
        return fetchedSongs;
      } else {
        // Handle the case when no songs are found
        return [];
      }
    } catch (e) {
      // Handle any errors that occur when querying songs
      print('Error querying songs: $e');
      return [];
    }
  }

  Future<void> addSongsToDatabase() async {
    List<SongModel>? tfetchedSongs = await fetchSongs();
    List<Songs> songsToAdd = [];
    if (tfetchedSongs.isEmpty) {
      log("No songs found");
    }
    for (var element in tfetchedSongs) {
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
        for (var song in songsToAdd) {
          box.put(
              element.id,
              Songs(
                  songname: song.songname,
                  artist: song.artist,
                  duration: song.duration,
                  songurl: song.songurl,
                  id: song.id));

          mostplayeddb.put(
              element.id,
              MostPlayed(
                  songname: song.songname,
                  artist: song.artist,
                  duration: song.duration,
                  songurl: song.songurl,
                  count: 0,
                  id: song.id));

        }
      }
    }
  }