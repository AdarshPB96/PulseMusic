import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_application_1/domain/models/fav_model.dart';
import 'package:music_application_1/domain/models/mostplayeddb.dart';
import 'package:music_application_1/domain/models/playlistmodel.dart';
import 'package:music_application_1/domain/models/recentplayed.dart';
import 'package:music_application_1/domain/models/songmodel.dart';

late Box<FavModel> favouritesdb;
openfavouritesDB() async {
  favouritesdb = await Hive.openBox<FavModel>(boxname1);
}

late Box<MostPlayed> mostplayeddb;
openmostplayedDB() async {
  mostplayeddb = await Hive.openBox<MostPlayed>('mostplayed');
}

late Box<RecentlyPlayed> recentplayeddb;
opemrecentplayedDB() async {
  recentplayeddb = await Hive.openBox<RecentlyPlayed>('Recently');
}

late Box<PlaylistSongs> playlistDb;
openplaylistDb() async {
  playlistDb = await Hive.openBox<PlaylistSongs>(boxnamePlaylist);
}


addRecently(id) {
  final box = SongBox.getInstance();

  // // Songs key = box.get(id)!;
  // List<RecentlyPlayed> recentlist = recentplayeddb.values.toList();
  List<Songs> songlist = box.values.toList();
  List<RecentlyPlayed> recentlist = recentplayeddb.values.toList();
  bool isalready = false;
  int? rindex;
  for (int i = 0; i < recentlist.length; i++) {
    if (id == recentlist[i].id) {
      isalready = true;
      rindex = i;
      break;
    }
  }
  final index = songlist.indexWhere((element) => element.id == id);
  // final Rindex = recentlist.indexWhere((element) => element.id == id);

  if (isalready && rindex != null) {
    recentplayeddb.deleteAt(rindex);
    recentplayeddb.add(RecentlyPlayed(
        songname: songlist[index].songname,
        artist: songlist[index].artist,
        duration: songlist[index].duration,
        songurl: songlist[index].songurl,
        id: songlist[index].id));
  } else {
    recentplayeddb.add(RecentlyPlayed(
        songname: songlist[index].songname,
        artist: songlist[index].artist,
        duration: songlist[index].duration,
        songurl: songlist[index].songurl,
        id: songlist[index].id));
  }
}



createplaylist(String name, BuildContext context) async {
  final playsbox = PlaylistSongsBox.getInstance();
  List<Songs> songsplaylist = [];

  List<PlaylistSongs> list = playsbox.values.toList();
  bool isnotpresent =
      list.where((element) => element.playlistName == name).isEmpty;

  if (name.isEmpty) {
    showSnackbar("Playlist name can't be empty", Colors.red, context);
  } else if (isnotpresent) {
    playsbox.put(
        name, PlaylistSongs(playlistName: name, playlistsSongs: songsplaylist));
    showSnackbar('Playlist Created', Colors.green, context);
  } else {
    showSnackbar('That playlist alredy exists', Colors.red, context);
  }
}


editPlaylist(String playlistName, BuildContext context) {
  TextEditingController editingController = TextEditingController();
  editingController.text = playlistName;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Playlist Name'),
          content: SizedBox(
            child: TextField(
              controller: editingController,
              decoration: const InputDecoration(
                hintText: 'Enter new name',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                final playlistElement = playlistDb.get(playlistName);

                if (playlistElement != null) {
                  final newPlaylistName = editingController.text;

                  // Remove old key-value pair
                  playlistDb.delete(playlistName);

                  // Update playlist name in the playlist element
                  playlistElement.playlistName = newPlaylistName;

                  // Add new key-value pair with updated playlist name
                  playlistDb.put(newPlaylistName, playlistElement);
                  showSnackbar(
                      'Playlist name $playlistName changed as $newPlaylistName',
                      Colors.green,
                      context);
                } else {
                  showSnackbar(
                      "Playlist name can't be empty", Colors.red, context);
                }
              },
              child: const Text('Change'),
            ),
          ],
        );
      });
}

addtoPlaylist( id, playlistname, BuildContext context) {
  var plylstelement = playlistDb.get(playlistname);
  final songboxplylst = SongBox.getInstance();

  Songs songplylst = songboxplylst.get(id)!;
  // bool isalreadyinSameplylst =
  //     plylstelement!.playlistsSongs!.contains(songplylst);
    bool isalreadyinSameplylst = plylstelement!.playlistsSongs!.any((song) => song.id == songplylst.id);
  if (!isalreadyinSameplylst) {
    plylstelement.playlistsSongs!.add(songplylst);
    playlistDb.put(playlistname, plylstelement);
    // plylstelement.save();
    showSnackbar("Added to playlist ", Colors.green, context);
  } else {
    showSnackbar("Song already added to playlist", Colors.red, context);
  }
}

deleteplaylist(playlistname, BuildContext context) {
  playlistDb.delete(playlistname);
  showSnackbar("Playlist '$playlistname' deleted ", Colors.green, context);
}

removefromplaylist(index, playlistname) {
  var playlistelement = playlistDb.get(playlistname);
  playlistelement!.playlistsSongs?.removeAt(index);
  playlistDb.put(playlistname, playlistelement);
}


deletePlylstWithAlert(BuildContext context, playlistname) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Do you want to delete playlist $playlistname'),
        actions: [
          TextButton(
              onPressed: () {
                 playlistDb.delete(playlistname);
                showSnackbar(
                    'Playlist $playlistname Deleted', Colors.green, context);
                Navigator.pop(context);
              },
              child: const Text('Yes')),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'))
        ],
      );
    },
  );
}

void showSnackbar(String message, Color color, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
      dismissDirection: DismissDirection.down,
      behavior: SnackBarBehavior.floating,
      elevation: 70,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.white,
    ),
  );
}

addPlayedSongsCount(id) {
  final mostbox = MostPlayedBox.getInstance();
  MostPlayed temp = mostbox.get(id)!;
  temp.count += 1;

  mostplayeddb.put(id, temp);
}


 


 
