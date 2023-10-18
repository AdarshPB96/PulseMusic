import 'package:flutter/material.dart';
import 'package:music_application_1/domain/function/dbfunctions.dart';
import 'package:music_application_1/domain/models/playlistmodel.dart';
import 'package:music_application_1/features/Screens/miniplayer/miniplayer.dart';
import 'package:music_application_1/features/Screens/playlist/playlistsongs_Screen/widgets/created_playlistsongs_listview_widget.dart';
import 'package:music_application_1/features/Screens/playlist/playlistsongs_Screen/widgets/playlist_listtile_item.dart';

class CreatedPlaylistSongs extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final playlistname;
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
                    ? createdPlaylistSongsListview(element!.playlistsSongs!,
                        (index) {
                        removeSongFromPlaylist(index);
                      })
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
}
