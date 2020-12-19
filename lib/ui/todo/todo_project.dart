import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodoProject extends StatefulWidget {
  final DocumentReference proDoc;

  TodoProject({
    this.proDoc,
  });

  @override
  _TodoProjectState createState() => _TodoProjectState();
}

class _TodoProjectState extends State<TodoProject> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
