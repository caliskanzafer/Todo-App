import 'package:flutter/material.dart';

class HomeTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const HomeTextField(
      {Key key, @required this.controller, @required this.labelText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: '$labelText',
      ),
    );
  }
}
