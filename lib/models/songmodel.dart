import 'package:hive/hive.dart';
part 'songmodel.g.dart';

@HiveType(typeId: 0)
class Songs {
  @HiveField(0)
  String? songname;
  @HiveField(1)
  String? artist;
  @HiveField(2)
  int? duration;
  @HiveField(3)
  String? songurl;
  @HiveField(4)
  int? id;
  // @HiveField(5)
  // int? mostcount;
  Songs(
      {required this.songname,
      required this.artist,
      required this.duration,
      required this.songurl,
      required this.id,
       });
}

String boxname = 'Songs';

class SongBox {
  static Box<Songs>? _box;
  static Box<Songs> getInstance() {
    return _box ??= Hive.box(boxname);
  }

  // static listenable() {}
}
