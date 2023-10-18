import 'package:flutter/material.dart';
import 'package:music_application_1/domain/models/songmodel.dart';

class SearchProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  List<Songs> searchlist = [];

  late List<Songs> nextlist;

  SearchProvider() {
    final box = SongBox.getInstance();
    nextlist = box.values.toList();
    searchsong('');
  }

  searchsong(value) {
    if (value.isEmpty) {
      searchlist = List.from(nextlist);
    } else {
      searchlist = nextlist
          .where((element) => element.songname!
              .toLowerCase()
              .contains((value.toString().toLowerCase())))
          .toList();
    }
    notifyListeners();
  }
}
