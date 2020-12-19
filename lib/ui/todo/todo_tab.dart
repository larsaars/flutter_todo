import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodoTabWidget extends StatefulWidget {
  final DocumentReference proDoc;

  TodoTabWidget({
    this.proDoc,
  });

  @override
  _TodoTabWidgetState createState() => _TodoTabWidgetState();
}

class _TodoTabWidgetState extends State<TodoTabWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
