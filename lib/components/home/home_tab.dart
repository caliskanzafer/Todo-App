import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  final String text;

  const HomeTab({Key key, @required this.text}) : super(key: key);

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
