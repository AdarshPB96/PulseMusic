import 'package:flutter/material.dart';
import 'package:music_application_1/domain/function/dbfunctions.dart';
import 'package:music_application_1/domain/models/fav_model.dart';

class Favprovider extends ChangeNotifier {
  removeFav(int? songid, context) async {
    final boxremove = Favouritesbox.getInstance();
    List<FavModel> favsong = boxremove.values.toList();
    int currentindex = favsong.indexWhere((element) => element.id == songid);
    await favouritesdb.deleteAt(currentindex);
    showSnackbar("Removed from favourites", Colors.green, context);

    notifyListeners();
  }

  List<FavModel> getFavItemSongs() {
    return favouritesdb.values.toList().reversed.toList();
  }
}
