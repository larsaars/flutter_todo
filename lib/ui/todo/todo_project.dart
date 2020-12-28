import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:todo/holder/todo.dart';
import 'package:todo/main.dart';
import 'package:todo/ui/todo/todo_tab.dart';
import 'package:todo/ui/widget/standard_widgets.dart';
import 'package:todo/util/utils.dart';
import 'package:todo/util/widget_utils.dart';

List<TodoTab> tabs = [];

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
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool searching = false;
  String appBarTitle = strings.loading_web;
  int sortingType = 0, curTabIdx = 0;
  TextEditingController searchController = TextEditingController();
  DocumentReference proDoc;
  bool _showing = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    //update the item count of project
    proDoc.update(<String, dynamic>{'itemCount': countItems});
    //dispose tab list
    tabs.clear();
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
          tabs.clear();
          //the data
          var data = snapshot.data();
          //the app bar title
          appBarTitle = data['name'];
          //sorting type
          sortingType = data['sortingType'];
        }
      });

      //after setting state load asynchronously all tabs and set state each time
      //first, for that the collection reference must be loaded
      proDoc.collection('tabs').get().then((querySnapshots) async {
        for (var queryDocSnapshot in querySnapshots.docs) {
          //create the new tab object
          var tab = TodoTab(proDoc.collection('tabs').doc(queryDocSnapshot.id));
          //and sorting type
          tab.sortingType = sortingType;
          //read the values from the db
          //when done reading add to tabs list and set state
          tab.read(queryDocSnapshot).then((value) => setState(() {
                tabs.add(tab);
                tabs.sort((a, b) => a.position.compareTo(b.position));
              }));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //return the widget
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
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
          title: AnimatedSwitcher(
            duration: Duration(milliseconds: 170),
            transitionBuilder: (child, animation) => ScaleTransition(
              child: child,
              scale: animation,
            ),
            child: searching
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
                      autofocus: true,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: Colors.white),
                      onChanged: (value) => setState(() {
                        //filter the projects titles
                        if (value.isEmpty)
                          //clone the projects list
                          curTab.copyFullToFiltered();
                        else
                          curTab.filteredItems = curTab.items
                              .where((element) => element.name
                                  .toLowerCase()
                                  .contains(
                                      searchController.text.toLowerCase()))
                              .toList();
                      }),
                    ),
                  ])
                : Text(appBarTitle),
          ),
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
              child: IconButton(
                tooltip: strings.edit_tabs,
                icon: Icon(
                  Icons.tab,
                  color: Colors.white54,
                ),
                onPressed: editTabs,
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
          bottom: TabBar(
            isScrollable: tabs.length > 4,
            tabs: tabs
                .map(
                  (tab) => Tab(
                    text: tab.name,
                  ),
                )
                .toList(),
          ),
        ),
        body: TabBarView(
          children: [
            for (final tab in tabs)
              TodoTabWidget(
                key: Key(tab.doc.id),
                tab: tab,
                scaffoldKey: scaffoldKey,
              )
          ],
        ),
      ),
    );
  }

  void editTabs() {
    if (_showing) return;
    _showing = true;

    List<TodoTab> tabsCopy = [...tabs];

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: StatefulBuilder(builder: (context, setState0) {
              var size = MediaQuery.of(context).size;

              return AlertDialog(
                  content: Container(
                    width: size.width,
                    height: size.height / 2.5,
                    child: Center(
                      child: ReorderableListView(
                        children: tabsCopy
                                .map(
                                  (tab) {
                                    var key = Key(tab.doc.id);
                                    return Card(
                                      key: key,
                                      child: Slidable(
                                        key: key,
                                        controller: SlidableController(),
                                        actionExtentRatio: 0.25,
                                        direction: Axis.horizontal,
                                        actionPane: SlidableStrechActionPane(),
                                        dismissal: SlidableDismissal(
                                          child: SlidableDrawerDismissal(),
                                          dismissThresholds: <SlideActionType,
                                              double>{
                                            SlideActionType.primary: 1,
                                            SlideActionType.secondary: 1,
                                          },
                                        ),
                                        child: ListTile(
                                          title: Text(tab.name),
                                          trailing: Icon(
                                            Icons.menu,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          IconSlideAction(
                                            caption: strings.delete,
                                            color: Colors.red[800],
                                            icon: Icons.delete,
                                            onTap: () => showAnimatedDialog(
                                              context,
                                              warningOnDoneButton: true,
                                              title: strings.delete,
                                              text: strings.delete_tab,
                                              onDone: (value) {
                                                if (value == 'ok') {
                                                  //since it is ok to delete this tab, remove it from both lists and from database
                                                  tabsCopy.remove(tab);
                                                  tabs.remove(tab);
                                                  tab.doc.delete();
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                        secondaryActions: [
                                          IconSlideAction(
                                            caption: strings.rename,
                                            color: Colors.indigoAccent,
                                            icon:
                                                Icons.drive_file_rename_outline,
                                            onTap: () async {
                                              var newName =
                                                  await showInputFieldDialog(
                                                      context,
                                                      hint: tab.name,
                                                      title: strings.rename);
                                              //rename the tab object and update
                                              setState0(() {
                                                tab.name = newName ?? '';
                                              });
                                              print(tab.name);
                                              tab.update();
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                                .whereType<Widget>()
                                .toList() +
                            <Widget>[
                              Card(
                                key: Key(tabsCopy.length.toString()),
                                child: ListTile(
                                  title: IconButton(
                                    tooltip: strings.add_tab,
                                    icon: Icon(
                                      Icons.add_circle_outlined,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () async {
                                      //new input field dialog for the name
                                      var name = await showInputFieldDialog(
                                          context,
                                          title: strings.add_tab);
                                      //create the new tab with name in db
                                      final tab = await TodoTab.addNew(
                                          proDoc,
                                          isEmpty(name) ? '' : name,
                                          (tabsCopy.last ??
                                                      (TodoTab()
                                                        ..position = -1))
                                                  .position +
                                              1);
                                      //set state by adding to list
                                      setState0(() {
                                        tabsCopy.add(tab);
                                        tabs.add(tab);
                                      });
                                    },
                                  ),
                                ),
                              )
                            ],
                        onReorder: (int start, int current) {
                          //ignore if is concerning last item
                          if (start == tabsCopy.length ||
                              current >= tabsCopy.length) return;
                          // dragging from top to bottom
                          if (start < current) {
                            int end = current - 1;
                            var startItem = tabsCopy[start];
                            int i = 0;
                            int local = start;
                            do {
                              tabsCopy[local] = tabsCopy[++local];
                              i++;
                            } while (i < end - start);
                            tabsCopy[end] = startItem;
                          }
                          // dragging from bottom to top
                          else if (start > current) {
                            var startItem = tabsCopy[start];
                            for (int i = start; i > current; i--) {
                              tabsCopy[i] = tabsCopy[i - 1];
                            }
                            tabsCopy[current] = startItem;
                          }
                          setState0(() {});
                        },
                      ),
                    ),
                  ),
                  actions: [
                    DefaultFilledButton(
                      text: strings.ok,
                      onPressed: () => Navigator.of(context).pop('ok'),
                    )
                  ]);
            }),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 300),
    ).then((value) {
      _showing = false;

      if (value == 'ok')
        setState(() {
          //set the positions and update to database
          for (int i = 0; i < tabsCopy.length; i++) {
            tabsCopy[i].position = i;
            tabsCopy[i].update();
          }

          //copy the list
          tabs = tabsCopy;
        });
    });
  }

  void showSnackBar(String msg) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(msg)));
  }

  void changeSorting() {
    List options = strings.sort_options.split(',');
    BuildContext ctx;

    showAnimatedDialog(context,
        title: strings.sort_by,
        setStateCallback: (ctx0, setState) {
          ctx = ctx0;
        },
        children: [
          RadioGroup.builder(
              direction: Axis.vertical,
              onChanged: (value) {
                //get diff int
                sortingType = options.indexOf(value);
                //save in the database online
                proDoc.update(<String, dynamic>{'sortingType': sortingType});
                //then pop the nav
                Navigator.of(ctx).pop('ok');
              },
              groupValue: options[sortingType],
              items: options,
              itemBuilder: (item) => RadioButtonBuilder(item,
                  textPosition: RadioButtonTextPosition.right))
        ],
        onDone: (value) {
          setState(() {
            //all tabs shall have new sorting type info
            for (var tab in tabs) tab.sortingType = sortingType;
          });
        });
  }

  int get countItems {
    int sum = 0;
    for (var tab in tabs) sum += tab.items.length;
    return sum;
  }

  TodoTab get curTab => tabs[curTabIdx];
}
