import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:icd/api.dart';
import 'package:icd/icd.dart';

Future getToken() async {
  if (initializedClientID.isEmpty || initializedClientSecretKey.isEmpty) {
    throw Exception(errk);
  }
  final data = {
    'client_id': initializedClientID,
    'client_secret': initializedClientSecretKey,
    'scope': ApiKeys.scope,
    'grant_type': ApiKeys.grantType,
  };
  final res = await http.post(Uri.parse(ApiKeys.tokenEndpoint), body: data);
  accessToken = json.decode(res.body)['access_token'];
}

Future<http.Response> request(Uri url) async {
  return await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Accept': 'application/json',
      'Accept-Language': 'en',
      'API-Version': 'v2'
    },
  );
}

enum ICDPropertiesSearch {
  title,
  synonym,
  narrowerTerm,
  fullySpecifiedName,
  definition,
  exclusion
}

class ICDResult {
  String? id;
  String? title;
  List? matchingPVs;
  List? descendants;
  ICDResult({this.title, this.id, this.descendants, this.matchingPVs});

  List<ICDResult> getResult(Map map) {
    List<ICDResult> list = [];
    List res = map['destinationEntities'];
    for (var e in res) {
      final r = ICDResult(
          id: e['id'],
          title: e['title'],
          descendants: e['descendants'],
          matchingPVs: e['matchingPVs']);
      list.add(r);
    }
    return list;
  }
}
