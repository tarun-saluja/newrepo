import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:memob/memberCard.dart';

class InviteMembers extends StatefulWidget {
  final String userToken;

  InviteMembers([this.userToken]);

  @override
  State<StatefulWidget> createState() {
    return _InviteMembers();
  }
}


class _InviteMembers extends State<InviteMembers> {

  String _userToken;
  List<dynamic> teamMembers = new List(); 
  @override
  void initState() {
    _userToken = widget.userToken;
    getTeamMembers();
    super.initState();
  }

  Future<Null> getTeamMembers() async {
    final response = await http.get(
        Uri.encodeFull('https://app.meetnotes.co/api/v2/teams/detail/'),
        headers: {
          HttpHeaders.AUTHORIZATION: 'Token $_userToken',
          HttpHeaders.CONTENT_TYPE: 'application/json',
          HttpHeaders.ACCEPT: 'application/json',
          HttpHeaders.CACHE_CONTROL: 'no-cache',
          HttpHeaders.COOKIE: 'sessionid=hqzl74coesky2o60rj58vwv618v7h8kn;'
        });
        print(response.statusCode);
    if (response.statusCode == 200) {
      this.setState(() {
        teamMembers.clear();
        Map<String, dynamic> mData = json.decode(response.body);

        List<dynamic> list = mData['members'];

        for(int i=0;i< list.length;i++) {
          teamMembers.add(list[i]);
        }
        });
      return null;
    } else {
      // If that response was not OK, throw an error.
      return null;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      child: MemberCard(teamMembers),
    );
  }
  
}