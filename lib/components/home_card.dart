import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final AsyncSnapshot snapshot;
  final int value;
  HomeCard(this.snapshot, this.value);

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
