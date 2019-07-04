import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListPage();
  }
}

class _ListPage extends State<ListPage> {
  List<String> _items = [];

  @override
  Widget build(BuildContext context) {
    print(_items);
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return Dismissible(
          key: Key(item),
          onDismissed: (direction) {
            setState(() {
              _items.removeAt(index);
            });

            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("$item dismissed"),
            ));
          },
          background: Container(
            color: Colors.redAccent,
          ),
          child: ListTile(
            title: Text('$item'),
          ),
        );
      },
    );
  }
}
