import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_application_1/features/Screens/home/home.dart';
import 'package:music_application_1/features/Screens/playlist/playlist_screen.dart';
import 'package:music_application_1/features/Screens/search/search_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}
class _BottomNavBarState extends State<BottomNavBar> {
  int _currentindex = 0;
  final screens = [
     HomeScreen(),
     SearchScreen(),
     PlaylistScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _currentindex,
          children: screens,
        ),
        bottomNavigationBar: FluidNavBar(
            icons: [
              FluidNavBarIcon(
                  icon: Icons.home,
                  extras: {'label': 'Home'},
                  backgroundColor: Colors.red),
              FluidNavBarIcon(
                  icon: Icons.search,
                  extras: {
                    "label": "Search",
                  },
                  backgroundColor: Colors.red),
              FluidNavBarIcon(
                  icon: Icons.library_music,
                  extras: {'label': 'Playlist'},
                  backgroundColor: Colors.red),
            ],
            onChange: (int index) {
              setState(() {
                _currentindex = index;
              });
            },
            style: const FluidNavBarStyle(
                iconUnselectedForegroundColor: Colors.white),
            scaleFactor: 1.5,
            // defaultIndex: _currentindex,
            itemBuilder: (icon, item) => Semantics(
                  label: icon.extras!["label"],
                  child: item,
                )));
  }
}
