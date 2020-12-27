import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:todo/holder/todo.dart';
import 'package:todo/ui/todo/todo_project.dart';
import 'package:todo/util/utils.dart';
import 'package:todo/util/widget_utils.dart';

import '../../main.dart';

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
                  color: Colors.grey,
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
              color: Colors.indigoAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  isRightestTab
                      ? Icons.delete
                      : Icons.keyboard_arrow_right_outlined,
                  color: Colors.white54,
                ),
                Icon(
                  isLeftestTab ? Icons.delete : Icons.arrow_back_ios,
                  color: Colors.white54,
                ),
              ],
            ),
          ),
          onDismissed: tabDismissed,
          child: ListTile(
            trailing: customSorting
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: makeNonNull<Widget>([
                      IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.grey,
                          ),
                          onPressed: () => editTab(index)),
                      Icon(
                        Icons.menu,
                        color: Colors.grey,
                      )
                    ]),
                  )
                : null,
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
            onLongPress: customSorting ? null : () => editTab(index),
          ),
        ),
      );
    }
  }

  void tabDismissed(DismissDirection direction) {
    //move it to the next / previous tab
  }

  void editTab(int index) {
    TodoItem item = filteredItems[index];

    currentDeadline = item.deadline;
    var controller = TextEditingController(text: item.name);

    showAnimatedDialog(context,
        title: strings.rename_change_deadline,
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  maxLines: 1,
                  textAlign: TextAlign.justify,
                  controller: controller,
                  textInputAction: TextInputAction.go,
                  keyboardType: TextInputType.text,
                  autofocus: false,
                ),
              ),
              IconButton(
                tooltip: strings.deadline,
                icon: Icon(
                  Icons.date_range,
                  color: Colors.grey,
                ),
                onPressed: () => pickDeadline(true),
              )
            ],
          ),
        ], onDone: (value) {
      if (value == 'ok') {
        //edit with new state
        setState(() {
          item.deadline = currentDeadline;
          item.name = controller.text;
        });
        //reset current deadline
        currentDeadline = 0;
        //update the item in db
        item.update();
      }
    });
  }

  void pickDeadline([bool forceShow]) {
    int ms = 0;
    showAnimatedDialog(context, forceShow: forceShow ?? false, children: [
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

  bool get isRightestTab => tabs.indexOf(tab) == (tabs.length - 1);

  bool get isLeftestTab => tabs.indexOf(tab) == 0;
}
