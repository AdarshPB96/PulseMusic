import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_application_1/domain/function/dbfunctions.dart';
import 'package:music_application_1/domain/models/fav_model.dart';
import 'package:music_application_1/domain/models/mostplayeddb.dart';
import 'package:music_application_1/domain/models/playlistmodel.dart';
import 'package:music_application_1/domain/models/recentplayed.dart';
import 'package:music_application_1/domain/models/songmodel.dart';
import 'package:music_application_1/features/Screens/splash/splash_screen.dart';
import 'package:music_application_1/features/provider/button_change_provider.dart';
import 'package:music_application_1/features/provider/fav_provider.dart';
import 'package:music_application_1/features/provider/search_provider.dart';
import 'package:provider/provider.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(SongsAdapter());

  await Hive.openBox<Songs>(boxname);
  Hive.registerAdapter(FavModelAdapter());

  Hive.registerAdapter(MostPlayedAdapter());
  Hive.registerAdapter(RecentlyPlayedAdapter());
  Hive.registerAdapter(PlaylistSongsAdapter());
  openfavouritesDB();
  openmostplayedDB();
  opemrecentplayedDB();
  openplaylistDb();

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SearchProvider(),),
        ChangeNotifierProvider(create: (context) => Buttonchange(),),
        ChangeNotifierProvider(create: (context) => Favprovider())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color(0xFF880E4F),
            scaffoldBackgroundColor: Colors.black,
            primarySwatch: Colors.red,
          ),
          home:  const SplashScreen()),
    );
  }
}
