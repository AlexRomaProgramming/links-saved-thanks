import 'package:flutter/material.dart';

class FolderListItem extends StatelessWidget {
  final String text;

  const FolderListItem({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.indigo.shade900,
          borderRadius: BorderRadius.circular(10)),
    );
  }
}
