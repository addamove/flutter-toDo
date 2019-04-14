import 'package:flutter/material.dart';

class Item extends StatefulWidget {
  final Map<String, dynamic> item;
  final int index;
  final Function onSaveButton;

  Item(
      {@required this.item, @required this.onSaveButton, @required this.index});

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  final TextEditingController _titleController = new TextEditingController();
  // final TextEditingController desc = new TextEditingController();

  @override
  void initState() {
    _titleController.text = widget.item['title'];
    return super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.item['title']),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(children: <Widget>[
            TextField(
              controller: _titleController,
            ),
            RaisedButton(
              child: Text('Save'),
              onPressed: () {
                widget.onSaveButton({
                  'title': _titleController.text,
                  'done': widget.item['done']
                }, widget.index);
              },
            )
          ]),
        ));
  }
}
