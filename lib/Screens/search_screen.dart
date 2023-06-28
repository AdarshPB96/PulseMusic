// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:music_application_1/Screens/miniplayer.dart';
import 'package:music_application_1/provider/search_provider.dart';
import 'package:music_application_1/widget/functions.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  TextEditingController searchController = TextEditingController();

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchPro = Provider.of<SearchProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Search',
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black38, Color(0xFF880E4F)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  searchPro.searchsong(value);
                },
                decoration: InputDecoration(
                  hintText: 'Find your music',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      searchPro.searchsong('');
                    },
                  ),
                ),
              ),
            ),
            Expanded(child: Consumer<SearchProvider>(
              builder: (context, value, child) {
                return ListView.separated(
                    itemBuilder: (context, index) {
                      return SongsList(
                          song: value.searchlist[index],
                          songlist: value.searchlist,
                          index: index);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 5,
                      );
                    },
                    itemCount: value.searchlist.length);
              },
            ))
          ],
        ),
      ),
      bottomSheet: const MiniPlayer(),
    );
  }

  // searchsong(value) {
  //   setState(
  //     () {
  //       if (value.isEmpty) {
  //         searchlist = List.from(nextlist);
  //       } else {
  //         searchlist = nextlist
  //             .where((element) => element.songname!
  //                 .toLowerCase()
  //                 .contains((value.toString().toLowerCase())))
  //             .toList();
  //       }
  //     },
  //   );
  // }
}
