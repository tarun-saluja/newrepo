import 'package:flutter/material.dart';
import 'package:memob/actionClass.dart';
import 'package:memob/actions.dart';

class ActionManager extends StatefulWidget{
  final List<ActionClass> allActions;
   ActionManager([this.allActions = const []]);
  @override
  State<StatefulWidget> createState() {
    return _ActionManagerState();
  }
}

class _ActionManagerState extends State<ActionManager> {
  List<ActionClass> _allActions;

  @override
  void initState() {
    if(widget.allActions !=null) {
      _allActions = widget.allActions;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        child: Actions(_allActions),
      )
    ],);
  } 
}