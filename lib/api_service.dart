import 'dart:io';

import 'package:http/http.dart' as http;

class API_Service {
  getAllActions(String userToken) async {
    var respons = await http.get(
        Uri.encodeFull('https://app.meetnotes.co/api/v1/action-items/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Token ' + userToken,
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.cacheControlHeader: 'no-cache'
        });
    return respons;
  }

  getUser(String userToken) async {
    var respon = await http.get(
        Uri.encodeFull('https://app.meetnotes.co/api/v2/settings/account/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Token ' + userToken,
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.cacheControlHeader: 'no-cache'
        });
    return respon;
  }

  getRecentNotesDetails(String userToken) async {
    var respons = await http.get(
        Uri.encodeFull('https://app.meetnotes.co/api/v2/recent-notes/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Token ' + userToken,
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.cacheControlHeader: 'no-cache'
        });
    return respons;
  }

  getOpenActions(String userToken) async {
    var respons = await http.get(
        Uri.encodeFull(
            'https://app.meetnotes.co/api/v1/action-items/?status__in=pending,doing'),
        headers: {
          HttpHeaders.authorizationHeader: 'Token ' + userToken,
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.cacheControlHeader: 'no-cache'
        });
    return respons;
  }

  getRecentlyUpdatedActions(String userToken) async {
    var respons = await http.get(
        Uri.encodeFull(
            'https://app.meetnotes.co/api/v1/action-items/?ordering=-updated_at'),
        headers: {
          HttpHeaders.authorizationHeader: 'Token ' + userToken,
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.cacheControlHeader: 'no-cache'
        });
    return respons;
  }

  getRecentlyClosedActions(String userToken) async {
    var respons = await http.get(
        Uri.encodeFull(
            'https://app.meetnotes.co/api/v1/action-items/?ordering=-updated_at&status=done'),
        headers: {
          HttpHeaders.authorizationHeader: 'Token ' + userToken,
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.cacheControlHeader: 'no-cache'
        });
    return respons;
  }

  getAllTeams(String userToken1) async {
    var respons = await http.get(
        Uri.encodeFull('https://app.meetnotes.co/api/v2/teams/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Token ' + userToken1,
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.cacheControlHeader: 'no-cache'
        });
    return respons;
  }

  getTeamMembersDetails(String userToken) async {
    var respons = await http.get(
        Uri.encodeFull('https://app.meetnotes.co/api/v2/teams/detail/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Token ' + userToken,
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.cacheControlHeader: 'no-cache',
          HttpHeaders.cookieHeader:
              'sessionid=hqzl74coesky2o60rj58vwv618v7h8kn;'
        });
    return respons;
  }

  getMeeting(String userToken) async {
    var respons = await http.get(
        Uri.encodeFull('https://app.meetnotes.co/api/v2/meetings/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Token ' + userToken,
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.cacheControlHeader: 'no-cache',
        });
    return respons;
  }
}
