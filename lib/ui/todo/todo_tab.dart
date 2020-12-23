import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:todo/holder/todo.dart';
import 'package:todo/util/utils.dart';
import 'package:todo/util/widget_utils.dart';

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
            padding: EdgeInsets.all(2),
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
                  ),
                ),
                Text(
                  isEmpty(currentDeadline)
                      ? ''
                      : formatTime(context,
                          DateTime.fromMillisecondsSinceEpoch(currentDeadline)),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                IconButton(
                  tooltip: strings.deadline,
                  icon: Icon(
                    Icons.date_range,
                    color: Colors.grey,
                  ),
                  onPressed: pickDeadline,
                )
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
                isEmpty(item.deadline)
                    ? strings.no_deadline
                    : formatTime(context,
                        DateTime.fromMillisecondsSinceEpoch(item.deadline)),
              ),
              onTap: () => tapListTile(item),
            ),
          );
        }
      },
    );
  }

  void pickDeadline() {
    int ms = 0;
    showAnimatedDialog(context, children: [
      DateTimePicker(
        type: DateTimePickerType.dateTimeSeparate,
        initialValue: DateTime.now().toString(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        icon: Icon(Icons.event),
        dateLabelText: strings.date,
        timeLabelText: strings.time,
        onChanged: (value) => ms = DateTime.parse(value).millisecondsSinceEpoch,
      ),
    ], onDone: (value) {
      if (value == 'ok' && ms != 0) {
        setState(() {
          currentDeadline = ms;
        });
      }
    });
  }

  void addItem(final String name) {
    //clear the text
    addController.clear();

    //add the item to firebase and then set the state
    TodoItem.addNew(tab, name, isEmpty(currentDeadline) ? 0 : currentDeadline)
        .then((item) {
      setState(() {
        //add to the lists
        tab.items.add(item);
        tab.filteredItems.add(item);
        //clear current deadline
        currentDeadline = 0;
      });
    });
  }

  void tapListTile(TodoItem item) {}

  TodoTab get tab => widget.tab;

  List<TodoItem> get filteredItems => tab.filteredItems;

  void updateTabDoc() {}
}
