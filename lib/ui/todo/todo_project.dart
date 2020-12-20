import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/holder/todo.dart';

class TodoProjectPage extends StatefulWidget {
  final DocumentReference proDoc;

  TodoProjectPage({
    this.proDoc,
  });

  @override
  _TodoProjectPageState createState() => _TodoProjectPageState();
}

class _TodoProjectPageState extends State<TodoProjectPage> {
  //sorting, search, move, add tab, add todo (deadline name), rename & change deadline
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool searching = false;
  List<int> selectedProjects = [];
  List<TodoTab> todos = [], filteredTodos = [];
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
    for (var tab in todos) sum += tab.items.length;
    return sum;
  }

  @override
  void initState() {
    super.initState();
    //load the root user doc
    proDoc = widget.proDoc;
    //load todos from firebase
    /*userDoc?.collection('pro')?.get()?.then((snapshot) {
      //set the state with future micro task
      Future.microtask(() => setState(() {
        //set the data list
        todos = snapshot?.docs?.map((e) {
          return Project(e.id, e.data()['name'], e.data()['lastAccessed']);
        })?.toList();

        //copy filtered to projects
        filteredTodos = [...todos];
      }));
    });*/
  }

  @override
  Widget build(BuildContext context) {
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
}
