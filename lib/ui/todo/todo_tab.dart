import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:todo/holder/todo.dart';
import 'package:todo/util/utils.dart';

import '../../main.dart';

class TodoTabWidget extends StatefulWidget {
  final TodoTab tab;

  TodoTabWidget({this.tab});

  @override
  _TodoTabWidgetState createState() => _TodoTabWidgetState();
}

class _TodoTabWidgetState extends State<TodoTabWidget> {
  TextEditingController addController = TextEditingController();
  final listKey = GlobalKey<AnimatedListState>();
  int currentDeadline;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    addController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: listKey,
      itemCount: filteredItems.length + 1,
      itemBuilder: (context, index) {
        //the last item, the add item edit text
        if (index == filteredItems.length) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey, width: 0.7)),
            child: Row(
              children: [
                Icon(
                  Icons.add,
                  color: Colors.grey,
                ),
                Expanded(
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
                      contentPadding: EdgeInsets.all(2),
                    ),
                    textInputAction: TextInputAction.go,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: addItem,
                    autofocus: true,
                  ),
                ),
                Text(
                  isEmpty(currentDeadline)
                      ? ''
                      : timeago.format(
                          DateTime.fromMillisecondsSinceEpoch(currentDeadline)),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                IconButton(
                    tooltip: strings.deadline,
                    icon: Icon(
                      Icons.date_range,
                      color: Colors.grey,
                    ),
                    onPressed: () {})
              ],
            ),
          );
        } else {
          //every other item
          TodoItem item = filteredItems[index];
          return Dismissible(
            key: Key(item.doc.id ?? index),
            background: Container(
              color: Colors.indigoAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.keyboard_arrow_right_outlined,
                    color: Colors.white54,
                  ),
                  Icon(
                    Icons.keyboard_arrow_left_outlined,
                    color: Colors.white54,
                  ),
                ],
              ),
            ),
            onDismissed: (direction) {
              //move it to the next / previous tab
            },
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

  void addItem(final String name) {
    //clear the text
    addController.clear();
    //add the item to firebase and then set the state
    TodoItem.addNew(tab, name).then((item) {
      setState(() {
        //add to the lists
        tab.items.add(item);
        tab.filteredItems.add(item);
      });
    });
  }

  void tapListTile(TodoItem item) {}

  TodoTab get tab => widget.tab;

  List<TodoItem> get filteredItems => tab.filteredItems;

  void updateTabDoc() {}
}
