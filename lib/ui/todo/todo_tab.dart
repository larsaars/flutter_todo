import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodoTab extends StatefulWidget {
  final DocumentReference proDoc;

  TodoTab({
    this.proDoc,
  });

  @override
  _TodoTabState createState() => _TodoTabState();
}

class _TodoTabState extends State<TodoTab> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
