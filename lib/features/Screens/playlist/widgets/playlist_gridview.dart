  import 'package:flutter/material.dart';
import 'package:music_application_1/domain/function/dbfunctions.dart';
import 'package:music_application_1/domain/models/playlistmodel.dart';
import 'package:music_application_1/features/Screens/playlist/playlistsongs_Screen/created_playlistsongs_screen.dart';

GridView playlistGridview(List<PlaylistSongs> playlistitems, double rhight, double rwidth,final List<Image> imageslist) {
    return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CreatedPlaylistSongs(
                                            // songindex: index,
                                            playlistname: playlistitems[index]
                                                .playlistName,
                                          ),
                                        ));
                                    //
                                  },
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                            "Do you want to delete/edit playlist '${playlistitems[index].playlistName}'"),
                                        actions: [
                                          IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                deleteplaylist(
                                                    playlistitems[index]
                                                        .playlistName,
                                                    context);
                                              },
                                              icon: const Icon(Icons.delete)),
                                          IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                editPlaylist(
                                                    playlistitems[index]
                                                        .playlistName
                                                        .toString(),
                                                    context);
                                              },
                                              icon: const Icon(Icons.edit)),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    // color: Colors.white,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    child: Column(children: [
                                      ClipRRect(

                                        child: Image(
                                          image: imageslist[
                                                  index % imageslist.length]
                                              .image,
                                          fit: BoxFit.cover,
                                          height: rhight * 0.15,
                                          width: rwidth * 0.45,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        playlistitems[index]
                                            .playlistName
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        '${playlistitems[index].playlistsSongs?.length} Songs',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ]),
                                  ),
                                );
                              },
                              itemCount: playlistitems.length,
                            );
  }