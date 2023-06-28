import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'now_playing_screen.dart';
import 'package:music_application_1/Screens/home.dart';
import 'package:music_application_1/Screens/miniplayer.dart';
import 'package:music_application_1/widget/playerfunction.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../function/dbfunctions.dart';
import '../models/playlistmodel.dart';
import '../widget/functions.dart';  


class CreatedPlaylistSongs extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final playlistname;
  // final int songindex;
  const CreatedPlaylistSongs({required this.playlistname, super.key});

  @override
  State<CreatedPlaylistSongs> createState() => _CreatedPlaylistSongsState();
}

class _CreatedPlaylistSongsState extends State<CreatedPlaylistSongs> {
  late PlaylistSongs? element;
  late ValueNotifier<List<dynamic>> playlistelementsonglistNotifier;
  bool shouldReload = false;
  final playbox = PlaylistSongsBox.getInstance();

  @override
  void initState() {
    element = playlistDb.get(widget.playlistname);
    final List playlistelementsonglist = element!.playlistsSongs!;
    playlistelementsonglistNotifier =
        ValueNotifier<List<dynamic>>(playlistelementsonglist);
    super.initState();
  }

  removeSongFromPlaylist(int index) {
    element!.playlistsSongs!.removeAt(index);
    playlistDb.put(element!.playlistName, element!);

    setState(() {});
    showSnackbar('Removed from playlist', Colors.green, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.playlistname),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => songlistForAddtoplaylist(
                          playlistname: widget.playlistname,
                          reloadCallback: () {
                            setState(() {
                              shouldReload = true;
                            });
                          }),
                    ));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black38, Color(0xFF880E4F)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Builder(builder: (context) {
          return ValueListenableBuilder<List<dynamic>>(
              valueListenable: playlistelementsonglistNotifier,
              builder: (context, value, child) {
                return element!.playlistsSongs!.isNotEmpty
                    ? ListView.separated(
                        itemBuilder: (context, index) {
                          return ListTile(
                            tileColor: Colors.grey,
                            onTap: () {
                              audioPlayer.stop();
                              audioList.clear();
                              for (var item in element!.playlistsSongs!) {
                                audioList.add(Audio.file(item.songurl!,
                                    metas: Metas(
                                      title: item.songname,
                                      artist: item.artist,
                                      id: item.id.toString(),
                                    )));
                              }
                              playingaudio(context, index);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            leading: QueryArtworkWidget(
                              id: element!.playlistsSongs![index].id!,
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
                                element!.playlistsSongs![index].songname!,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            subtitle: Marquee(
                              child: Text(
                                  element!.playlistsSongs![index].artist!,
                                  style: const TextStyle(color: Colors.white)),
                            ),
                            trailing: PopupMenuButton(
                              color: Colors.white,
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // removefromplaylist(index, element!.playlistName);
                                    removeSongFromPlaylist(index);
                                  },
                                  child: const Text('Remove From Playlist'),
                                )),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 5,
                          );
                        },
                        itemCount: element!.playlistsSongs!.length)
                    : const Center(
                        child: Text(
                        "No Songs",
                        style: TextStyle(color: Colors.white),
                      ));
              });
        }),
      ),
      bottomSheet: const MiniPlayer(),
    );
  }

  playlistDialogue(BuildContext context) {
    return AlertDialog(
      title: const Text('Add to Playlist'),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () {
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
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              String name = playlistcontroller.text;
              createplaylist(name, context);
              Navigator.of(context).pop();
            },
            child: const Text('Create'))
      ],
    );
  }
}
