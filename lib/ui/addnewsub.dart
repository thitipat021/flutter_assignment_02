import 'package:flutter/material.dart';
import '../model/todo.dart';

class Addthenew extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddthenewState();
  }
}

class AddthenewState extends State<Addthenew> {
  final _key = GlobalKey<FormState>();
  TodoProvider prov = TodoProvider();
  TextEditingController title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Subject"),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _key,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: title,
                decoration: InputDecoration(
                  labelText: "Subject",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill subject";
                  }
                },
              ),
              RaisedButton(
                child: Text("Save"),
                onPressed: () async {
                  if (_key.currentState.validate()) {
                    await prov.open().then((r) {
                      prov.insert(Todo.data(title.text, false));
                    });
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
