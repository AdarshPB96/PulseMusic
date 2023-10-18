  import 'package:flutter/material.dart';

AppBar appBarWidget({required String text}) {
    return AppBar(
      backgroundColor: Colors.black,
      title:  Text(
        text,
      ),
      centerTitle: true,
    );
  }