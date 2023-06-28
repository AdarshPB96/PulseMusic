import 'package:hive/hive.dart';
part 'recentplayed.g.dart';


@HiveType(typeId: 3)
class RecentlyPlayed {
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

  RecentlyPlayed(
      {required this.songname,
      required this.artist,
      required this.duration,
      required this.songurl,
      required this.id});
}

class RecentplayedBox {
  static Box<RecentlyPlayed>? _box;
  static Box<RecentlyPlayed> getinstance() {
    return _box ??= Hive.box('Recently');
  }
}
