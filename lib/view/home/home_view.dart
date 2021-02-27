import 'package:flutter/material.dart';
import '../../components/home/home_card.dart';
import '../../components/home/home_tab.dart';
import '../../components/home/home_text_field.dart';
import '../../core/services/services.dart';

part 'home_string_values.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  _HomeStringValues texts = _HomeStringValues();
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
                } else {
                  return Center(
                    child: _circularProgressIndicator,
                  );
                }
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
                } else {
                  return Center(
                    child: _circularProgressIndicator,
                  );
                }
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
                        Text('${texts.taskDeleted}'),
                        Spacer(),
                        FlatButton(
                            onPressed: () {
                              setState(() {
                                service.undoDeletedTask(snapshot.data[value]);
                              });
                            },
                            child: Text('${texts.undo}')),
                      ],
                    ),
                  )));
            }
          },
          child: !snapshot.data[value].done
              ? HomeCard(snapshot: snapshot, value: value)
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
                        Text('${texts.taskStatusChanged}'),
                        Spacer(),
                        FlatButton(
                            onPressed: () {
                              setState(() {
                                service.updateTask(snapshot.data[value]);
                              });
                            },
                            child: Text('${texts.undo}')),
                      ],
                    ),
                  )));
            }
          },
          child: snapshot.data[value].done
              ? HomeCard(snapshot: snapshot, value: value)
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
            HomeTab(text: '${texts.tabTasks}'),
            HomeTab(text: '${texts.tabDone}'),
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
                      HomeTextField(
                          controller: taskName, labelText: '${texts.taskName}'),
                      SizedBox(height: 10),
                      HomeTextField(
                          controller: taskDescripton,
                          labelText: '${texts.description}'),
                      FlatButton(
                          onPressed: () {
                            setState(() {
                              service.addTask(
                                  taskName.text, taskDescripton.text);
                              taskName.clear();
                              taskDescripton.clear();
                            });
                          },
                          child: Text('${texts.save}')),
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

CircularProgressIndicator get _circularProgressIndicator =>
    CircularProgressIndicator();
