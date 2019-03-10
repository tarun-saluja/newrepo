import 'package:flutter/material.dart';
import 'package:memob/actionClass.dart';
import 'package:memob/actions.dart';

class ActionManager extends StatefulWidget{
  final List<ActionClass> allActions;
  final List<dynamic> meetings;
  final List<dynamic> assignees;
   ActionManager([this.allActions = const [], this.meetings =const [], this.assignees = const []]);
  @override
  State<StatefulWidget> createState() {
    return _ActionManagerState();
  }
}

class _ActionManagerState extends State<ActionManager> {
  List<ActionClass> _allActions;
  List<dynamic> _meetings;
  List<dynamic> _assignees;

  @override
  void initState() {
    if(widget.allActions != null || widget.assignees != null || widget.meetings != null) 
    {
      _allActions = widget.allActions;
      _assignees = widget.assignees;
      _meetings = widget.meetings;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        child: Actions(_allActions, _meetings, _assignees),
      )
    ],);
  } 
}