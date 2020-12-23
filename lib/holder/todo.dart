import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/ui/todo/todo_tab.dart';

class TodoItem {
  String name;
  int deadline, changed;
  DocumentReference doc;

  TodoItem([this.doc]);

  static Future<TodoItem> addNew(TodoTab tab, String name) async {
    //current time
    int time = DateTime.now().millisecondsSinceEpoch;
    //create database object
    Map<String, dynamic> data = {
      'n': name,
      'c': time,
      'dl': time,
    };
    //add to list database
    var thisDoc = await tab.doc.collection('items').add(data);
    //then generate local object
    return TodoItem(thisDoc)
      ..changed = time
      ..deadline = time
      ..name = name;
  }

  Future<void> update() async {
    //update in database
    await doc
        .update(<String, dynamic>{'n': name, 'dl': deadline, 'c': changed});
  }

  Future<void> read([var snapshot]) async {
    //load the snapshot from database if is null
    snapshot ??= await doc.get();
    //set values locally
    name = snapshot.get('n');
    deadline = snapshot.get('dl');
    changed = snapshot.get('c');
  }
}

class TodoTab {
  String name;
  List<TodoItem> items = [], filteredItems = [];
  TodoTabWidget widget;
  int position = 0;

  DocumentReference doc;

  TodoTab([this.doc]);

  void update() async {
    //update the database
    await doc.update(<String, dynamic>{'n': name, 'p': position});
  }

  static Future<TodoTab> addNew(
      DocumentReference proDoc, String name, int position) async {
    //create database object
    Map<String, dynamic> data = {'n': name, 'p': position};
    //add to list database
    var thisDoc = await proDoc.collection('tabs').add(data);
    //then generate local object
    return TodoTab(thisDoc)..name = name;
  }

  Future<void> read([var docSnapshot]) async {
    //load the snapshot from database if is not null
    docSnapshot ??= await doc.get();
    //set values locally
    name = docSnapshot.get('n');
    position = docSnapshot.get('p');
    //load items collection snapshot
    QuerySnapshot querySnapshots = await doc.collection('items').get();
    //loop through all the query snapshots and make them to items
    for (var snapshot in querySnapshots.docs) {
      TodoItem todoItem = TodoItem(doc.collection('items').doc(snapshot.id));
      await todoItem.read(snapshot);
      //add the to do item to the list
      items.add(todoItem);
    }

    //and create a copy in filtered list
    filteredItems = [...items];
  }

  void copyFullToFiltered() => filteredItems = [...items];

  void sort(int sortingType) {
    _sort0(items, sortingType);
    _sort0(filteredItems, sortingType);
  }

  void _sort0(List<TodoItem> items, int sortingType) {
    items.sort((a, b) {
      int name = a.name.compareTo(a.name);
      int deadline = b.deadline.compareTo(a.deadline);
      int changed = b.changed.compareTo(a.changed);

      if (sortingType == TodoItemSortingType.custom) {
        if (changed == 0) {
          if (deadline == 0)
            return name;
          else
            return deadline;
        } else
          return changed;
      } else if (sortingType == TodoItemSortingType.deadline) {
        if (deadline == 0) {
          if (changed == 0)
            return name;
          else
            return changed;
        } else
          return deadline;
      } else if (sortingType == TodoItemSortingType.name) {
        if (name == 0) {
          if (changed == 0)
            return deadline;
          else
            return changed;
        } else
          return name;
      } else
        return 0;
    });
  }
}

class TodoItemSortingType {
  static const int deadline = 2, name = 1, custom = 0;
}
