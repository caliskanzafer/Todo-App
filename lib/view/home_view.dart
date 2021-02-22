import 'package:flutter/material.dart';
import 'package:todo_app/components/home_card.dart';
import 'package:todo_app/components/home_tab.dart';
import 'package:todo_app/components/home_text_field.dart';
import 'package:todo_app/core/services/services.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  FirebaseService service;
  final formKey = GlobalKey<FormState>();
  TextEditingController taskName = TextEditingController();
  TextEditingController taskDescripton = TextEditingController();
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    service = FirebaseService();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: tabBarView(),
        bottomNavigationBar: bottomAppBar(),
        floatingActionButton: fabButton(context),
      ),
    );
  }

  TabBarView tabBarView() {
    return TabBarView(
      children: [
        FutureBuilder(
          future: service.getTask(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (snapshot.hasData) {
                  return _taskListViewBuilder(snapshot);
                } else
                  return Center(
                    child: _circularProgressIndicator,
                  );
                break;
              default:
                return Center(
                  child: _circularProgressIndicator,
                );
            }
          },
        ),
        FutureBuilder(
          future: service.getTask(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (snapshot.hasData) {
                  return _doneListViewBuilder(snapshot);
                } else
                  return Center(
                    child: _circularProgressIndicator,
                  );
                break;
              default:
                return Center(
                  child: _circularProgressIndicator,
                );
            }
          },
        ),
      ],
    );
  }

  ListView _taskListViewBuilder(AsyncSnapshot snapshot) {
    return ListView.builder(
      itemBuilder: (context, value) {
        return Dismissible(
          key: Key(snapshot.data[value].task),
          direction: DismissDirection.horizontal,
          onDismissed: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              setState(() {
                service.updateTask(snapshot.data[value]);
              });
              Scaffold.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 2),
                  content: Container(
                    height: 20,
                    child: Row(
                      children: [
                        Text('Task done'),
                        Spacer(),
                        FlatButton(
                            onPressed: () {
                              setState(() {
                                service.undoUpdateTask(snapshot.data[value]);
                              });
                            },
                            child: Text('UNDO')),
                      ],
                    ),
                  )));
            } else {
              setState(() {
                service.deleteTask(snapshot.data[value].key);
              });
              Scaffold.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 2),
                  content: Container(
                    height: 20,
                    child: Row(
                      children: [
                        Text('Task deleted'),
                        Spacer(),
                        FlatButton(
                            onPressed: () {
                              setState(() {
                                service.undoDeletedTask(snapshot.data[value]);
                              });
                            },
                            child: Text('UNDO')),
                      ],
                    ),
                  )));
            }
          },
          child: !snapshot.data[value].done
              ? HomeCard(snapshot, value)
              : SizedBox.shrink(),
        );
      },
      itemCount: snapshot.data.length,
    );
  }

  ListView _doneListViewBuilder(AsyncSnapshot snapshot) {
    return ListView.builder(
      itemBuilder: (context, value) {
        return Dismissible(
          key: Key(snapshot.data[value].task),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              setState(() {
                service.undoUpdateTask(snapshot.data[value]);
              });

              /// Extension olabilir burasi
              /// Yada Component
              /// Kod tekrari var
              /// TODO:
              Scaffold.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 2),
                  content: Container(
                    height: 20,
                    child: Row(
                      children: [
                        Text('Task status changed'),
                        Spacer(),
                        FlatButton(
                            onPressed: () {
                              setState(() {
                                service.updateTask(snapshot.data[value]);
                              });
                            },
                            child: Text('UNDO')),
                      ],
                    ),
                  )));
            }
          },
          child: snapshot.data[value].done
              ? HomeCard(snapshot, value)
              : SizedBox.shrink(),
        );
      },
      itemCount: snapshot.data.length,
    );
  }

  BottomAppBar bottomAppBar() {
    return BottomAppBar(
      child: TabBar(
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          tabs: [
            HomeTab('Tasks'),
            HomeTab('Done'),
          ]),
    );
  }

  FloatingActionButton fabButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Container(
                width: 100,
                height: 200,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      HomeTextField(taskName, 'Task Name'),
                      SizedBox(height: 10),
                      HomeTextField(taskDescripton, 'Description'),
                      FlatButton(
                          onPressed: () {
                            setState(() {
                              service.addTask(
                                  taskName.text, taskDescripton.text);
                              taskName.clear();
                              taskDescripton.clear();
                            });
                          },
                          child: Text('Kaydet')),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Icon(Icons.add),
    );
  }
}

get _circularProgressIndicator => CircularProgressIndicator();
