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
  String appBarTitle = strings.loading_web;
  int sortingType = 0, curTabIdx = 0;
  TextEditingController searchController = TextEditingController();
  DocumentReference proDoc;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    //update the item count of project
    proDoc.update(<String, dynamic>{'itemCount': countItems});
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
            var items = <TodoItem>[];
            for (var item in tab['items'])
              items.add(
                  TodoItem(item['title'], item['deadline'], item['created']));
            //add to to do tabs the title and items, with filtered items as a copy
            tabs.add(TodoTab(tab['title'], items, [...items]));
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
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Colors.white54,
          ),
          onPressed: () => searching
              ? setState(() {
                  //not searching anymore
                  searching = false;
                  //also clear the search controller
                  searchController.clear();
                  //copy back the filtered items to normal
                  curTab.copyFullToFiltered();
                })
              : Navigator.of(context).pop(),
        ),
        title: searching
            ? Stack(alignment: Alignment.centerRight, children: [
                Icon(
                  Icons.search,
                  color: Colors.white54,
                ),
                TextFormField(
                  textAlign: TextAlign.justify,
                  controller: searchController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                  ),
                  keyboardType: TextInputType.text,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Colors.white),
                  onChanged: (value) => setState(() {
                    //filter the projects titles
                    if (value.length == 0)
                      //clone the projects list
                      curTab.copyFullToFiltered();
                    else
                      curTab.filteredItems = curTab.items
                          .where((element) => element.title
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase()))
                          .toList();
                  }),
                ),
              ])
            : Text(appBarTitle),
        actions: <Widget>[
          Visibility(
            visible: !searching,
            child: Tooltip(
              message: strings.sorting,
              child: IconButton(
                icon: Icon(
                  Icons.sort,
                  color: Colors.white54,
                ),
                onPressed: addItem,
              ),
            ),
          ),
          Visibility(
            visible: !searching,
            child: Tooltip(
              message: strings.add_item,
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white54,
                ),
                onPressed: addItem,
              ),
            ),
          ),
          Tooltip(
            message: searching ? strings.clear : strings.search,
            child: IconButton(
              icon: Icon(
                searching ? Icons.clear : Icons.search,
                color: Colors.white54,
              ),
              onPressed: () => setState(() {
                if (searching) {
                  //clear the search
                  searchController.clear();
                  //copy back the filtered items to normal
                  curTab.copyFullToFiltered();
                } else
                  searching = true;
              }),
            ),
          ),
        ],
      ),
      body: Column(
        children: [],
      ),
    );
  }

  void addItem() {}

  void sort() {
    for (var tab in tabs) tab.sort(sortingType);
  }

  int get countItems {
    int sum = 0;
    for (var tab in tabs) sum += tab.items.length;
    return sum;
  }

  TodoTab get curTab => tabs[curTabIdx];
}
