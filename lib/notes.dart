import 'package:flutter/material.dart';

import './Detail.dart';
import './NotesClass.dart';
import './constants.dart';
import './duration.dart';

class Notes extends StatelessWidget {
  final List<NotesClass> notes;

  Notes([this.notes = const []]);

  @override
  Widget build(BuildContext context) {
    Widget noteCard = Center(child: CircularProgressIndicator());
    if (notes.length > 0) {
      noteCard = Container(
          padding: EdgeInsets.only(top: 20),
          child:ListView.builder(
            itemBuilder: _buildNoteItem,
            itemCount: notes.length,
          ));
    }
    else{noteCard = Container(
    color: Color(0XFFeaf0f5),
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    child: Center(
    child:
    Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    Container(
    child: Image.asset('assets/empty.png',
    fit: BoxFit.cover,
    height: 150,
    width: 180,
    ),
    ),
    Padding(
    padding: const EdgeInsets.only(top:18.0),
    child: Text('No Notes Created',style: TextStyle(fontFamily: 'Roboto',color: Color.fromRGBO(188, 196, 209, 1), fontSize: 20),),
    )])));
//    child:Text('Tarun'))),

    }

    return noteCard;
  }

  Widget _buildNoteItem(BuildContext context, int index) {
    var updatedAt;
    Duration diff =
    DateTime.now().difference(DateTime.parse(notes[index].updatedAt));
    updatedAt = duration(diff);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var open = notes[index].actionItems;
    return  Container(
        height: 90,
        margin: new EdgeInsets.fromLTRB(20.0,3.0,20.0,0.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Detail(notes[index].meetingUuid,
                        notes[index].meetingTitle, notes[index].eventUuid)));
          },
          child: Card(
            elevation: 100.0,
            color: Colors.white,
            child: Container(
              margin: EdgeInsets.fromLTRB(15,15,0,15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            width:screenHeight*0.25,
                            child:
                            Text(
                              notes[index].meetingTitle,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: 'RobotoBold',
                                  color: Color(0XFF5A6278)),
                              overflow: TextOverflow.ellipsis,
                            )),
                        Text(
                          'Last Modified $updatedAt',
       style: TextStyle(color: Color(0XFFBCC4D1), fontSize: 13,
                            fontFamily: 'Roboto',),
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            (open != 0)
                                ? Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0XFFF0F5F8)),
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 8.0, 11.0, 8.0),
                              child: Text(
                                '$open Open',
                                style: TextStyle(
                                    color: Color(0XFF1DBC6F), fontSize: 12, fontFamily: 'RobotoMedium'),
                              ),
                            )
                                : Text(''),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'arrow.png',
                              height: 15,
                              width: 15,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
