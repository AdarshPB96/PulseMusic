import 'package:hive/hive.dart';
import 'package:music_application_1/domain/models/songmodel.dart';
part 'playlistmodel.g.dart';


@HiveType(typeId: 4)
class PlaylistSongs {
  @HiveField(0)
  String? playlistName;
  @HiveField(1)
  List<Songs>? playlistsSongs;

  PlaylistSongs({required this.playlistName, required this.playlistsSongs});

  // get playlistnamedup => null;
}

String boxnamePlaylist = 'Playlist';

class PlaylistSongsBox {
  static Box<PlaylistSongs>? _box;
  static Box<PlaylistSongs> getInstance() {
    return _box ??= Hive.box(boxnamePlaylist);
  }
}
