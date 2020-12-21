import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/holder/todo.dart';
import 'package:todo/util/utils.dart';
import 'package:timeago/timeago.dart' as timeago;

class TodoTabWidget extends StatefulWidget {
  final DocumentReference proDoc;
  final TodoTab tab;

  TodoTabWidget({this.proDoc, this.tab});

  @override
  _TodoTabWidgetState createState() => _TodoTabWidgetState();
}

class _TodoTabWidgetState extends State<TodoTabWidget> {
  var tempTabId;

  @override
  void initState() {
    super.initState();

    tempTabId = uuid.v4();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.tab.filteredItems.length,
      itemBuilder: (context, index) {
        TodoItem item = filteredItems[index];
        return Dismissible(
          key: Key(index.toString() + tempTabId),
          child: ListTile(
            title: Text(
              '${item.title}',
            ),
            subtitle: Text(
              timeago.format(
                  DateTime.fromMillisecondsSinceEpoch(item.deadline)),
            ),
            onTap: () => tapListTile(item),
          ),
        );
      },
    );
  }

  void tapListTile(TodoItem item) {

  }

  TodoTab get tab => widget.tab;

  List<TodoItem> get filteredItems => tab.filteredItems;
}
