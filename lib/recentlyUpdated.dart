import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:memob/utilities.dart' as utilities;
import './NotesClass.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import './notes.dart';

class RecentlyUpdated extends StatefulWidget {
   final List<NotesClass> notes;

  RecentlyUpdated([this.notes = const []]);

  @override
  State<StatefulWidget> createState() {
    return _RecentlyUpdatedState();
  }
}

class _RecentlyUpdatedState extends State<RecentlyUpdated> {
List<NotesClass> _notes;
  @override
  void initState() {
    if(widget.notes!=null){
      _notes=widget.notes;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Notes(_notes),
        )
      ],
    );
  }
}
