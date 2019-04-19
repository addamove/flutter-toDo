import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './item.dart';

void showSnackbar(text, context) {
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
}

Function looseFocus =
    (context) => FocusScope.of(context).requestFocus(new FocusNode());

class ToDo extends StatefulWidget {
  final String title;
  final String uuid;
  ToDo({Key key, this.title, this.uuid}) : super(key: key);

  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  final List<Map<String, dynamic>> items = [
    {'title': 'Clean my house', 'done': false}
  ];
  final inputCtrl = TextEditingController();
  final Firestore _db = Firestore.instance;

  void _updateItem(newItem, index) {
    setState(() {
      items[index] = newItem;
    });
    Navigator.pop(context);
  }

  Function _addToDo(context) => () {
        if (inputCtrl.text.trim().length > 5) {
          setState(() {
            items.add({'title': inputCtrl.text, 'done': false});
          });
          inputCtrl.text = '';
        } else {
          showSnackbar('Should be long then 5 characters!', context);
        }
      };

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    inputCtrl.dispose();
    super.dispose();
  }

  Widget _buildItem() {
    return StreamBuilder<QuerySnapshot>(
      stream: _db.collection('users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          default:
            print(widget.uuid);
            final userObject = snapshot.data.documents
                .where((DocumentSnapshot document) =>
                    document['uid'] == widget.uuid)
                .first;
            print(userObject.data);
            final items = userObject['items'];
            print(items);
            return ListView(
                children: items
                    .map<Widget>((item) => Dismissible(
                        background: Container(color: Colors.red),
                        // Each Dismissible must contain a Key. Keys allow Flutter to
                        // uniquely identify Widgets.
                        key: Key(item['title']),
                        // We also need to provide a function that will tell our app
                        // what to do after an item has been swiped away.
                        onDismissed: (direction) {
                          // Show a snackbar! This snackbar could also contain "Undo" actions.
                          showSnackbar("${item['title']} dismissed", context);

                          // Remove the item from our data source.
                          // setState(() {
                          //   items.removeAt(index);
                          // });
                        },
                        child: GestureDetector(
                          child: ListTile(
                            trailing: IconButton(
                              icon: Icon(item['done']
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank),
                              color: Colors.redAccent,
                              onPressed: () {
                                setState(() {
                                  item['done'] = !item['done'];
                                });
                              },
                            ),
                            title: Text(
                              item['title'],
                              style: TextStyle(
                                  decoration: item['done']
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Item(
                                        item: item,
                                        index: 0,
                                        onSaveButton: _updateItem,
                                      )),
                            );
                          },
                        )))
                    .toList());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GestureDetector(
        onTap: () => looseFocus(context),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: inputCtrl,
              ),
            ),
            Expanded(
              child: _buildItem(),
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (contextWithScaffold) => FloatingActionButton(
              onPressed: _addToDo(contextWithScaffold),
              tooltip: 'Increment',
              child: Icon(Icons.add),
            ),
      ),
    );
  }
}
