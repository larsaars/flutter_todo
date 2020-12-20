import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/holder/todo.dart';
import 'package:todo/main.dart';

class TodoProjectPage extends StatefulWidget {
  final DocumentReference proDoc;

  TodoProjectPage({
    this.proDoc,
  });

  @override
  _TodoProjectPageState createState() => _TodoProjectPageState();
}

class _TodoProjectPageState extends State<TodoProjectPage> {
  //sorting, search, move, add tab, add to do (deadline name), rename & change deadline
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool searching = false;
  List<TodoTab> tabs = [];
  String appBarTitle = app_name;
  int sortingType = 0;
  TextEditingController searchController = TextEditingController();
  DocumentReference proDoc;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    //update the item count of project
    proDoc.update(<String, dynamic>{'itemCount': countItems});
  }

  int get countItems {
    int sum = 0;
    for (var tab in tabs) sum += tab.items.length;
    return sum;
  }

  @override
  void initState() {
    super.initState();
    //load the root user doc
    proDoc = widget.proDoc;
    //load todos from firebase
    proDoc?.get()?.then((snapshot) {
      //set the task with with new to do tabs element
      setState(() {
        if (snapshot.exists) {
          //clear the init list
          tabs = [];
          //the data
          var data = snapshot.data();
          //the app bar title
          appBarTitle = data['name'];
          //sorting type
          sortingType = data['sortingType'];
          //set the data list
          for (var tab in data['tabs']) {
            //get the items
            var items = [];
            for (var item in tab['items'])
              items.add(
                  TodoItem(item['title'], item['deadline'], item['created']));
            //add to to do tabs the title and items
            tabs.add(TodoTab(tab['title'], items));
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //sort the lists every time before building
    sort();
    //return the widget
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
      ),
      body: Column(
        children: [],
      ),
    );
  }

  void sort() {
    for(var tab in tabs)
      tab.sort(sortingType);
  }
}
