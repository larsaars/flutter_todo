import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:todo/holder/todo.dart';
import 'package:todo/main.dart';
import 'package:todo/ui/widget/standard_widgets.dart';
import 'package:todo/util/widget_utils.dart';

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
                onPressed: changeSorting,
              ),
            ),
          ),
          Visibility(
            visible: !searching,
            child: PopupMenuButton(
              tooltip: strings.add_item_or_tab,
              child: DefaultIcon(Icons.add),
              itemBuilder: (context) => <PopupMenuEntry<int>>[
                PopupMenuItem<int>(
                  value: 0,
                  child: Text(strings.add_item),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text(strings.add_tab),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 0:
                    //add item
                    addItem();
                    break;
                  case 1:
                    //add tab
                    addTab();
                    break;
                  default:
                    break;
                }
              },
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
      body: Row(),
    );
  }

  Widget get addTabWidget {}

  void addTab() {}

  void addItem() {}

  void changeSorting() {
    List options = strings.sort_options.split(',');
    BuildContext ctx;

    showAnimatedDialog(context, title: strings.sort_by,
        setStateCallback: (ctx0, setState) {
      ctx = ctx0;
    }, children: [
      RadioGroup.builder(
          direction: Axis.vertical,
          onChanged: (value) {
            //get diff int
            sortingType = options.indexOf(value);
            //save in the database online
            proDoc.update(<String, dynamic>{'sortingType': sortingType});
            //then pop the nav
            Navigator.of(ctx).pop();
          },
          groupValue: options[sortingType],
          items: options,
          itemBuilder: (item) => RadioButtonBuilder(item,
              textPosition: RadioButtonTextPosition.right))
    ]);
  }

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
