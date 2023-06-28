// ignore_for_file: sort_child_properties_last

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:music_application_1/Screens/now_playing_screen.dart';
import 'package:music_application_1/Screens/home.dart';
import 'package:music_application_1/Screens/splash_screen.dart';
import 'package:music_application_1/function/add_to_favourites.dart';
import 'package:music_application_1/function/dbfunctions.dart';
import 'package:music_application_1/models/fav_model.dart';
import 'package:music_application_1/models/playlistmodel.dart';
import 'package:music_application_1/models/songmodel.dart';

import 'package:music_application_1/widget/playerfunction.dart';
import 'package:on_audio_query/on_audio_query.dart';

// ignore: must_be_immutable
class SongsList extends StatelessWidget {
  final Songs song;
  List<Songs> songlist;
  final Color? color;
  final int index;
  SongsList(
      {super.key,
      required this.song,
      required this.songlist,
      this.color,
      required this.index});


  bool isfav = false;
  final playbox = PlaylistSongsBox.getInstance();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // tileColor: widget.color ?? Colors.black,

      onTap: () {
        audioPlayer.stop();
        audioList.clear();
        for (Songs item in songlist) {
          audioList.add(Audio.file(item.songurl!,
              metas: Metas(
                title: item.songname,
                artist: item.artist,
                id: item.id.toString(),
              )));
        }
        playingaudio(context, index);
        addPlayedSongsCount(song.id);
        addRecently(song.id);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      leading: QueryArtworkWidget(
        id: song.id!,
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
      title: Marquee(
        child: Text(
          song.songname!,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      subtitle: Marquee(
        child: Text(song.artist.toString(),
            style: const TextStyle(color: Colors.white)),
      ),
      trailing: PopupMenuButton(
        color: Colors.white,
        itemBuilder: (ctx) => [
          PopupMenuItem(
              child: TextButton(
            onPressed: () {
              addfav(song.id, context);
              Navigator.of(context).pop();
            },
            child: Text(isalready(song.id)
                ? 'Remove from favourites'
                : 'Add to favourites'),
          )),
          PopupMenuItem(
              child: TextButton(
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    playlistDialogue(context, index),
              );
            },
            child: const Text('Add to Playlist'),
          )),
        ],
      ),
    );
  }

  playlistDialogue(BuildContext context, int songindex) {
    return AlertDialog(
      title: const Text('Add to Playlist'),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context) => createPlaylistTextfield(context),
              );
            },
            child: const Text('Create New Playlist'),
          ),
        ),
        Center(
          child: SizedBox(
            width: 200,
            height: 200,
            child: ValueListenableBuilder<Box<PlaylistSongs>>(
              valueListenable: playbox.listenable(),
              builder: (context, value, child) {
                List<PlaylistSongs> playlistitems = playlistDb.values.toList();
                return ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        playlistitems[index].playlistName.toString(),
                        textAlign: TextAlign.center,
                      ),
                      tileColor: Colors.amber[100],
                      focusColor: Colors.black26,
                      onTap: () {
                        Navigator.pop(context);
                        addtoPlaylist(
                          song.id!,
                          playlistitems[index].playlistName,
                          context,
                        );
                      },
                    );
                  },
                  itemCount: playlistitems.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 5,
                    );
                  },
                );
              },
            ),
          ),
        )
      ],
    );
  }

  createPlaylistTextfield(BuildContext context) {
    TextEditingController playlistcontroller = TextEditingController();
    return AlertDialog(
      title: const Text('Create Playlist'),
      actions: [
        SizedBox(
          child: TextField(
            controller: playlistcontroller,
            decoration: const InputDecoration(
              hintText: 'Playlist Name',
              border: InputBorder.none,
            ),
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              String name = playlistcontroller.text;
              createplaylist(name, context);
              Navigator.of(context).pop();
              addtoPlaylist(song.id, name, context);
            },
            child: const Text('Create'))
      ],
    );
  }
}

// favourites list
// ..................

// ignore: must_be_immutable
class Favouritelist extends StatelessWidget {
  final FavModel song;
  List<FavModel> songlist;
  final Color? color;
  final int index;
  Favouritelist(
      {super.key,
      required this.song,
      required this.songlist,
      this.color,
      required this.index});


  bool isfav = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: color ?? Colors.black,
      onTap: () {
        audioPlayer.stop();
        audioList.clear();
        for (FavModel item in songlist) {
          audioList.add(Audio.file(item.songurl!,
              metas: Metas(
                title: item.songname,
                artist: item.artist,
                id: item.id.toString(),
              )));
        }
        playingaudio(context, index);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      leading: QueryArtworkWidget(
        id: song.id!,
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
      title: Marquee(
        child: Text(
          song.songname!,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      subtitle: Marquee(
        child: Text(song.artist.toString(),
            style: const TextStyle(color: Colors.white)),
      ),
      trailing: IconButton(
          onPressed: () {
            addfav(song.id, context);
          },
          icon: const Icon(Icons.remove, color: Colors.white)),
    );
  }
}

// playlist songs screen

// add songs from playlist

// ignore: camel_case_types, must_be_immutable
class songlistForAddtoplaylist extends StatefulWidget {
  String playlistname;
  final VoidCallback reloadCallback;
  songlistForAddtoplaylist(
      {required this.playlistname, required this.reloadCallback, super.key});

  @override
  State<songlistForAddtoplaylist> createState() =>
      _songlistForAddtoplaylistState();
}

TextEditingController _searchcontroller = TextEditingController();

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
