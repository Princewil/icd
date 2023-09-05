library icd;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:icd/functs.dart';

String accessToken = '';
String initializedClientID = '';
String initializedClientSecretKey = '';

class ICD {
  ///For Initializing the Plugin
  void initializeICDAPI(
      {required String clientID, required String clientSecretKey}) {
    initializedClientID = clientID;
    initializedClientSecretKey = clientSecretKey;
  }

  ///Searching ICD database callback
  Future<List<ICDResult>> searchICD({
    required String keyWord,
    List<String> icdDxURLS = const [],
    bool useFlexisearch = true,
    bool flatResults = false,
    bool highlightingEnabled = false,
    List<ICDPropertiesSearch> propertiesToBeSearched = const [
      ICDPropertiesSearch.title
    ],
  }) async {
    if (initializedClientID.isEmpty || initializedClientSecretKey.isEmpty) {
      throw Exception(errk);
    }
    final searchParams = propertiesToBeSearched
        .map(getPropertiesToBeSearchedKeyWord)
        .toList()
        .join(',');
    final url = Uri.https('id.who.int', '/icd/entity/search', {
      'q': keyWord,
      'subtreesFilter': icdDxURLS,
      'releaseId': '',
      'chapterFilter': '',
      'useFlexisearch': useFlexisearch.toString(),
      'flatResults': flatResults.toString(),
      'propertiesToBeSearched': searchParams,
      'highlightingEnabled': highlightingEnabled.toString(),
    });
    http.Response res = await request(url);
    if (res.statusCode == 401) {
      //Meaning token has expired
      await getToken(); //we get new token
      res = await request(url);
    }
    Map map = jsonDecode(res.body);
    return ICDResult().getResult(map);
  }
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
