import 'package:flutter/material.dart';
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
              ? _card(snapshot, value)
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
              ? _card(snapshot, value)
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
            Tab(
              child: Text(
                'Tasks',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Tab(
              child: Text(
                'Done',
                style: TextStyle(color: Colors.black),
              ),
            ),
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
                      TextField(
                        controller: taskName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Task Name',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: taskDescripton,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'Description',
                        ),
                      ),
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

Card _card(AsyncSnapshot snapshot, int value) {
  return Card(
    child: ListTile(
      title: Text(snapshot.data[value].task),
      subtitle: Text(snapshot.data[value].description),
    ),
  );
}

get _circularProgressIndicator => CircularProgressIndicator();
