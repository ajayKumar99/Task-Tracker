import 'package:flutter/material.dart';


class TextAlert extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();

  _displayDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter task to add'),
          content: TextField(
            controller: _textController,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return _displayDialog(context);
  }
}