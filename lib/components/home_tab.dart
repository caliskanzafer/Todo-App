import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  final String text;
  HomeTab(this.text);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        '$text',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
