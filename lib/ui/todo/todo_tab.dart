import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:todo/holder/todo.dart';
import 'package:todo/util/utils.dart';

class TodoTabWidget extends StatefulWidget {
  final DocumentReference proDoc;
  final TodoTab tab;

  TodoTabWidget({this.proDoc, this.tab});

  @override
  _TodoTabWidgetState createState() => _TodoTabWidgetState();
}

class _TodoTabWidgetState extends State<TodoTabWidget> {
  var tempTabId;
  TextEditingController addController = TextEditingController();
  final listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();

    tempTabId = uuid.v4();
  }

  @override
  void dispose() {
    super.dispose();
    addController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: listKey,
      initialItemCount: filteredItems.length + 1,
      itemBuilder: (context, index, animation) {
        //the last item, the add item edit text
        if (index == filteredItems.length) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white54,
                width: 8,
              ),
            ),
            child: TextFormField(
              maxLines: 1,
              textAlign: TextAlign.justify,
              controller: addController,
              decoration: InputDecoration(
                border: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              ),
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.text,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.white),
              onFieldSubmitted: addItem,
            ),
          );
        } else {
          //every other item
          TodoItem item = filteredItems[index];
          return Dismissible(
            key: Key(index.toString() + tempTabId),
            background: Container(
              color: Colors.indigoAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.keyboard_arrow_left_outlined,
                    color: Colors.white54,
                  ),
                  Icon(
                    Icons.keyboard_arrow_right_outlined,
                    color: Colors.white54,
                  ),
                ],
              ),
            ),
            child: ListTile(
              title: Text(
                '${item.name}',
              ),
              subtitle: Text(
                timeago
                    .format(DateTime.fromMillisecondsSinceEpoch(item.deadline)),
              ),
              onTap: () => tapListTile(item),
            ),
          );
        }
      },
    );
  }

  void addItem(String value) {
    //add the item to firebase and then set the state
    setState(() {

    });
  }

  void tapListTile(TodoItem item) {}

  TodoTab get tab => widget.tab;

  List<TodoItem> get filteredItems => tab.filteredItems;

  void updateTabDoc() {

  }
}
