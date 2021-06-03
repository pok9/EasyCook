import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

class test2 extends StatefulWidget {
  test2({Key key}) : super(key: key);

  @override
  _test2State createState() => _test2State();
}

class _test2State extends State<test2> {
  List<Widget> _rows;

  @override
  void initState() {
    super.initState();
    _rows = List<Widget>.generate(
        10,
        (int index) => Text('This is row $index',
            key: ValueKey(index), textScaleFactor: 1.5));
  }

  @override
  Widget build(BuildContext context) {
    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        Widget row = _rows.removeAt(oldIndex);
        _rows.insert(newIndex, row);
      });
    }

    Widget reorderableColumn = IntrinsicWidth(
        child: ReorderableColumn(
      header: Text('List-like view but supports IntrinsicWidth'),
//        crossAxisAlignment: CrossAxisAlignment.start,
      children: _rows,
      onReorder: _onReorder,
    ));

    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: 50,
          ),
          Transform(
            transform: Matrix4.rotationZ(0),
            alignment: FractionalOffset.topLeft,
            child: Material(
              child: Card(child: reorderableColumn),
              elevation: 6.0,
              color: Colors.transparent,
              borderRadius: BorderRadius.zero,
            ),
          )
        ],
      ),
    );
  }
}
