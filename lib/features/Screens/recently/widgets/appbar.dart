  import 'package:flutter/material.dart';

AppBar appBarRecently(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back)),
      title: const Text('Recently Played'),
      centerTitle: true,
    );
  }