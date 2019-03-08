import 'package:flutter/material.dart';
import 'package:memob/actionClass.dart';

class Actions extends StatelessWidget {
  final List<ActionClass> allActions;

  Actions([this.allActions =const []]);


  Widget _buildActionItem(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white70,
        border: new Border.all(color: Colors.blue, width: 1.0),
        borderRadius: new BorderRadius.circular(5.0),
      ),
      margin: EdgeInsets.all(10.0),
      child: Card(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Text(allActions[index].assignedTo, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),),
            Text(allActions[index].note, style: TextStyle(color: Colors.black),)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget actionCard = Center(child: CircularProgressIndicator(),);
    if(allActions.length > 0) {
      actionCard = ListView.builder(
        itemBuilder: _buildActionItem,
        itemCount: allActions.length,
      );
    }

    return actionCard;
  }
  
}