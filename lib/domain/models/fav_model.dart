import 'package:hive/hive.dart';
part 'fav_model.g.dart';


@HiveType(typeId: 1)
class FavModel {
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
  FavModel(
      {required this.songname,
      required this.artist,
      required this.duration,
      required this.songurl,
      required this.id});
}

String boxname1 = 'favourites';

class Favouritesbox {
  static Box<FavModel>? _box;
  static Box<FavModel> getInstance() {
    return _box ??= Hive.box(boxname1);
  }
}
