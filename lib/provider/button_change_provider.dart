import 'package:flutter/material.dart';
import 'package:music_application_1/function/dbfunctions.dart';
import 'package:music_application_1/models/fav_model.dart';
import 'package:music_application_1/models/songmodel.dart';

class Buttonchange extends ChangeNotifier {
  bool isRepeat = false;
  setIsRepeat(bool value) {
    if (isRepeat != value) {
      isRepeat = value;
      notifyListeners();
    }
  }

  repeatIcon() {
    return isRepeat
        ? const Icon(Icons.repeat_on, color: Colors.white)
        : const Icon(
            Icons.repeat,
            color: Colors.white,
          );
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

  icon(id) {
    if (isalready(id)) {
      return const Icon(
        Icons.favorite,
        color: Colors.red,
      );
    } else {
      return const Icon(
        Icons.favorite_border,
        color: Colors.white,
      );
    }
  }

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
    notifyListeners();
  }
}
