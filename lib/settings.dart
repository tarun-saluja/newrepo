import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Settings();
  }
}

class _Settings extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        child: Form(
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name'
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email'
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
