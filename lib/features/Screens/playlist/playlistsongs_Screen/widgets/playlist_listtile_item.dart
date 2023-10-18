import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_application_1/domain/function/dbfunctions.dart';
import 'package:music_application_1/domain/models/songmodel.dart';
import 'package:music_application_1/features/Screens/splash/splash_screen.dart';

import 'package:on_audio_query/on_audio_query.dart';

// ignore: camel_case_types
class songlistForAddtoplaylist extends StatefulWidget {
 final String playlistname;
  final VoidCallback reloadCallback;
  const songlistForAddtoplaylist(
      {required this.playlistname, required this.reloadCallback, super.key});

  @override
  State<songlistForAddtoplaylist> createState() =>
      _songlistForAddtoplaylistState();
}

final TextEditingController _searchcontroller = TextEditingController();

// ignore: camel_case_types
class _songlistForAddtoplaylistState extends State<songlistForAddtoplaylist> {
  late List<Songs> songs = [];
  late List<Songs> filteredsongs = [];

  @override
  void initState() {
    final box = SongBox.getInstance();
    songs = box.values.toList();
    searchsong('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () {
                widget.reloadCallback();
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: TextField(
              controller: _searchcontroller,
              onChanged: (value) {
                searchsong(value);
              },
              decoration: InputDecoration(
                hintText: 'Search Song',
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchcontroller.clear();
                    // searchsong('');
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, value, child) {
                // List<Songs> songs = box.values.toList();
                return ListView.separated(
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          addtoPlaylist(
                            filteredsongs[index].id,
                            widget.playlistname,
                            context,
                          );
                        },
                        leading: QueryArtworkWidget(
                          id: filteredsongs[index].id!,
                          size: 3000,
                          artworkFit: BoxFit.cover,
                          type: ArtworkType.AUDIO,
                          artworkBorder: BorderRadius.circular(10),
                          artworkQuality: FilterQuality.high,
                          nullArtworkWidget: const Image(
                            width: 50,
                            height: 50,
                            image: AssetImage(
                              'assets/images/pulse-music-low-resolution-color-logo.png',
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: Text(
                          filteredsongs[index].songname.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(filteredsongs[index].artist.toString(),
                            style: const TextStyle(color: Colors.white)),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 15,
                        ),
                    itemCount: filteredsongs.length);
              },
            ),
          )
        ],
      )),
    );
  }

  searchsong(value) {
    setState(
      () {
        if (value.toString().isEmpty) {
          filteredsongs = List.from(songs);
        } else {
          filteredsongs = songs
              .where((element) => element.songname!
                  .toLowerCase()
                  .contains((value.toString().toLowerCase())))
              .toList();
        }
      },
    );
  }
}
