import 'package:flutter/material.dart';
import 'package:music_application_1/domain/function/dbfunctions.dart';
import 'package:music_application_1/domain/models/fav_model.dart';
import 'package:music_application_1/domain/models/songmodel.dart';

addfav(int? id, context) {
  final box = SongBox.getInstance();
  List<Songs> dbsongs = box.values.toList();
  List<FavModel> favouritesongs = [];
  favouritesongs = favouritesdb.values.toList();
  bool isalready = favouritesongs.any((element) => element.id == id);

  if (!isalready) {
    Songs song = dbsongs.firstWhere((element) => element.id == id);
    favouritesdb.add(FavModel(
        songname: song.songname,
        artist: song.artist,
        duration: song.duration,
        songurl: song.songurl,
        id: song.id));
    showSnackbar('Added to favourites', Colors.green, context);
  } else {
    int favIndex = favouritesongs.indexWhere((element) => element.id == id);
    favouritesdb.deleteAt(favIndex);
    showSnackbar('Removed from favourites', Colors.green, context);
  }
}

removeFav(int? songid) async {

  final boxremove = Favouritesbox.getInstance();
  List<FavModel> favsong = boxremove.values.toList();
  int currentindex = favsong.indexWhere((element) => element.id == songid);
  await favouritesdb.deleteAt(currentindex);
}

bool isalready(id) {
  List<FavModel> favouritesongs = [];
  favouritesongs = favouritesdb.values.toList();

  if (favouritesongs.any((element) => element.id == id)) {
    return true;
  } else {
    return false;
  }
}
