import 'package:flutter/material.dart';
import '../model/todo.dart';

class TaskScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TaskState();
  }
}

class TaskState extends State<TaskScreen> {
  TodoProvider prov = TodoProvider();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> appBarActions = [
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "/add");
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          setState(() {
            prov.delDone();
          });
        },
      )
    ];
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Todo"),
          actions: <Widget>[appBarActions[_index]],
        ),
        body: TabBarView(
          children: <Widget>[
            FutureBuilder(
              future: prov.open().then((r) {
                return prov.getnotDone();
              }),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
                if (snapshot.hasData && snapshot.data.length > 0) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Todo item = snapshot.data[index];
                      return CheckboxListTile(
                        title: Text("${item.title}"),
                        value: item.done,
                        onChanged: (bool value) {
                          setState(() {
                            item.done = true;
                            prov.update(item);
                          });
                        },
                      );
                    },
                  );
                } else {
                  return Center(child: Text("No data found.."));
                }
              },
            ),
            FutureBuilder(
              future: prov.open().then((r) {
                return prov.getaDone();
              }),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
                if (snapshot.hasData && snapshot.data.length > 0) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Todo item = snapshot.data[index];
                      return CheckboxListTile(
                        title: Text("${item.title}"),
                        value: item.done,
                        onChanged: (bool value) {
                          setState(() {
                            item.done = false;
                            prov.update(item);
                          });
                        },
                      );
                    },
                  );
                } else {
                  return Center(child: Text("No data found.."));
                }
              },
            ),
          ],
        ),
        bottomNavigationBar: TabBar(
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.blue,
          indicatorColor: Colors.blue,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.list),
              text: "Task",
            ),
            Tab(
              icon: Icon(Icons.done_all),
              text: "Completed",
            ),
          ],
          onTap: (index) {
            setState(() {
              _index = index;
            });
          },
        ),
      ),
    );
  }
}
