import 'package:hive/hive.dart';
part 'mostplayeddb.g.dart';


@HiveType(typeId: 2)
class MostPlayed {
  @HiveField(0)
  String? songname;
  @HiveField(1)
  String? artist;
  @HiveField(2)
  int? duration;
  @HiveField(3)
  String? songurl;
  @HiveField(4)
  int count;
  @HiveField(5)
  int? id;

  MostPlayed(
      {required this.songname,
      required this.artist,
      required this.duration,
      required this.songurl,
      required this.count,
      required this.id});
}

class MostPlayedBox {
  static Box<MostPlayed>? _box;
  static Box<MostPlayed> getInstance() {
    return _box ??= Hive.box('MostPlayed');
  }
}
