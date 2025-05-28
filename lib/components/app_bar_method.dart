import 'package:flutter/material.dart';

Widget buildSliverAppBar({
  required String title,
  required BuildContext context,
}) {
  return SliverAppBar(
    expandedHeight: 120,
    floating: false,
    pinned: true,
    backgroundColor: Colors.teal,
    elevation: 0,
    leading: IconButton(
      icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ),
    flexibleSpace: FlexibleSpaceBar(
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
      background: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.teal, Color(0xFF00695C)],
          ),
        ),
      ),
    ),
  );
}
