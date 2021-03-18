import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final AsyncSnapshot snapshot;
  final int value;

  const HomeCard({Key key, @required this.snapshot, @required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(snapshot.data[value].task),
        subtitle: Text(snapshot.data[value].description),
      ),
    );
  }
}
