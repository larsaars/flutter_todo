import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:todo/holder/todo.dart';
import 'package:todo/ui/todo/todo_project.dart';
import 'package:todo/ui/widget/standard_widgets.dart';
import 'package:todo/util/utils.dart';
import 'package:todo/util/widget_utils.dart';

import '../../main.dart';
import '../style.dart';

class TodoTabWidget extends StatefulWidget {
  final TodoTab tab;

  TodoTabWidget({Key key, this.tab}) : super(key: key);

  @override
  _TodoTabWidgetState createState() => _TodoTabWidgetState();
}

class _TodoTabWidgetState extends State<TodoTabWidget> {
  TextEditingController addController = TextEditingController();
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
    //sort the tab
    tab.sort();
    //determine if is custom sorting
    bool customSorting = tab.sortingType == TodoItemSortingType.custom;
    //if is custom sorting, create list of children for reorderable list
    List<Widget> children = [];
    if (customSorting) {
      //<= because the list shall have one item too much for the edit text in the end
      for (int i = 0; i <= filteredItems.length; i++)
        children.add(buildListTile(i, true));
    }
    //build the widget with simple list view or in case of custom list make it reorderable
    return customSorting
        ? ReorderableListView(
            key: Key('list_view'),
            children: children,
            onReorder: (int oldIndex, int newIndex) {
              //if the old index is the last item, ignore
              if (oldIndex == filteredItems.length ||
                  newIndex >= filteredItems.length) return;
              //set the state newly
              setState(() {
                //set the changed item to the lower item + 1
                var item = filteredItems[oldIndex];
                if ((oldIndex + 1) < filteredItems.length) {
                  var lowerItem = filteredItems[oldIndex + 1].changed - 1;
                  filteredItems[oldIndex].changed = lowerItem;
                  tab.items[tab.items.indexOf(item)].changed = lowerItem;
                } else if ((oldIndex - 1) >= 0) {
                  var upperItem = filteredItems[oldIndex - 1].changed + 1;
                  filteredItems[oldIndex].changed = upperItem;
                  tab.items[tab.items.indexOf(item)].changed = upperItem;
                }
                //update in database
                tab.items[tab.items.indexOf(item)].update();
              });
            },
          )
        : ListView.builder(
            key: Key('list_view'),
            itemCount: filteredItems.length + 1,
            itemBuilder: (context, index) => buildListTile(index, false),
          );
  }

  Widget buildListTile(int index, bool customSorting) {
    //the last item, the add item edit text
    if (index == filteredItems.length) {
      return Padding(
        key: Key(filteredItems.length.toString()),
        padding: const EdgeInsets.all(4),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Styles.greyIconColor, width: 0.7)),
          child: Row(
            children: [
              Icon(
                Icons.add,
                color: Styles.greyIconColor,
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
                  autofocus: false,
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
                  color: Styles.greyIconColor,
                ),
                onPressed: pickDeadline,
              )
            ],
          ),
        ),
      );
    } else {
      //every other item
      TodoItem item = filteredItems[index];
      var key = Key(item.doc.id ?? index.toString());
      return Card(
        key: key,
        child: Dismissible(
          key: key,
          background: Container(
            decoration: BoxDecoration(
              color: Styles.indigoAccentColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  isRightestTab
                      ? Icons.delete
                      : Icons.keyboard_arrow_right_outlined,
                  color: Styles.white54IconColor,
                ),
                Icon(
                  isLeftestTab ? Icons.delete : Icons.arrow_back_ios,
                  color: Styles.white54IconColor,
                ),
              ],
            ),
          ),
          onDismissed: (direction) => tileDismissed(index, direction),
          child: ListTile(
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: makeNonNull<Widget>([
                item.focusNode.hasPrimaryFocus
                    ? IconButton(
                        icon: Icon(
                          Icons.date_range,
                          color: Styles.greyIconColor,
                        ),
                        onPressed: () => changeDeadline(item))
                    : null,
                customSorting
                    ? Icon(
                        Icons.menu,
                        color: Styles.greyIconColor,
                      )
                    : null,
              ]),
            ),
            title: TextFormField(
              maxLines: 1,
              textAlign: TextAlign.justify,
              controller: item.textController,
              focusNode: item.focusNode,
              decoration: InputDecoration(
                border: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.all(2),
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              onFieldSubmitted: (value) {
                //focus the next item
                setState(() {
                  item.focusNode.unfocus();
                  int idx = filteredItems.indexOf(item);
                  if ((idx + 1) < filteredItems.length)
                    filteredItems[idx + 1].focusNode.requestFocus();
                });
              },
              autofocus: false,
              onChanged: (value) => itemTextChanged(item, value),
            ),
            subtitle: Text(
              isEmpty(item.deadline)
                  ? strings.no_deadline
                  : formatTime(context,
                      DateTime.fromMillisecondsSinceEpoch(item.deadline)),
            ),
          ),
        ),
      );
    }
  }

  void itemTextChanged(final TodoItem item, String value) {
    const timeout = 4400;
    //last text change is now
    item.lastTextChange = DateTime.now().millisecondsSinceEpoch;
    //set the value to the item
    item.name = value;
    //delayed check last write, this must have been the last write if the check is true (estimated)
    Future.delayed(Duration(milliseconds: timeout)).then((value) {
      if ((DateTime.now().millisecondsSinceEpoch - item.lastTextChange) >= (timeout - 50))
        item.update();
    });
  }

  void tileDismissed(int index, DismissDirection direction) {
    //move it to the next / previous tab or delete
    //get the item
    TodoItem item = filteredItems[index];
    //get the index of this tab
    int tabIndex = tabs.indexOf(tab);
    //direction is to the right
    if (direction == DismissDirection.startToEnd) {
      //delete action since is the rightest tab
      if (tabIndex == (tabs.length - 1))
        deleteItem(item);
      else {
        //else move to tab to the right (index + 1)
        moveItem(item, tabs[tabIndex + 1]);
      }
      //direction is to the left
    } else if (direction == DismissDirection.endToStart) {
      //delete action since is the leftest tab
      if (tabIndex == 0)
        deleteItem(item);
      else {
        //else move to tab to the left (index - 1)
        moveItem(item, tabs[tabIndex - 1]);
      }
    }
  }

  void moveItem(TodoItem item, TodoTab newTab) {
    //remove the item from these lists
    filteredItems.remove(item);
    tab.items.remove(item);
    //delete item from database at this path
    item.doc.delete();
    //add the new item at the new tab
    TodoItem.addNew(newTab, item.name, item.deadline, item.changed)
        .then((recreatedItem) {
      //after moving the item add it to the new tabs lists
      newTab.items.add(recreatedItem);
      newTab.filteredItems.add(recreatedItem);
    });
  }

  void deleteItem(TodoItem item) {
    //update the state
    setState(() {
      //remove item from both lists
      tab.items.remove(item);
      filteredItems.remove(item);
    });
    //state of undone
    bool undone = false;
    //show a snackbar with undo button
    Scaffold.of(context)
        .showSnackBar(SnackBar(
            content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                child: Text(
              strings.deleted_project(item.name),
            )),
            DefaultFlatButton(
                text: strings.undo,
                onPressed: () {
                  //close the snack bar
                  Scaffold.of(context).hideCurrentSnackBar();
                  //has been undone
                  undone = true;
                  //set state
                  setState(() {
                    //add again
                    tab.items.add(item);
                    filteredItems.add(item);
                  });
                })
          ],
        )))
        .closed
        .then((value) {
      //remove project from database if not undone
      if (!undone) {
        item.doc.delete();
      }
    });
  }

  void changeDeadline(TodoItem item) async {
    //set the current deadline
    currentDeadline = item.deadline;
    //await the pick deadline dialog
    await pickDeadline();
    //when deadline is picked
    //edit with new state
    setState(() {
      item.deadline = currentDeadline;
    });
    //reset current deadline
    currentDeadline = 0;
    //update the item in db
    item.update();
  }

  Future<void> pickDeadline() async {
    int ms = 0;
    await showAnimatedDialog(context, children: [
      DateTimePicker(
        type: DateTimePickerType.dateTimeSeparate,
        initialValue: isEmpty(currentDeadline)
            ? DateTime.now().toString()
            : DateTime.fromMillisecondsSinceEpoch(currentDeadline).toString(),
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

  TodoTab get tab => widget.tab;

  List<TodoItem> get filteredItems => tab.filteredItems;

  bool get isRightestTab => tabs.indexOf(tab) == (tabs.length - 1);

  bool get isLeftestTab => tabs.indexOf(tab) == 0;
}
