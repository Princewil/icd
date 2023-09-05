library icd;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:icd/functs.dart';

String accessToken = '';
String initializedClientID = '';
String initializedClientSecretKey = '';

class ICD {
  void initializeICDAPI(
      {required String clientID, required String clientSecretKey}) {
    initializedClientID = clientID;
    initializedClientSecretKey = clientSecretKey;
  }

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
        .map((e) {
          final firstLetter = e.toString().substring(0, 1);
          final otherLetter = e.toString().substring(1);
          return '${firstLetter.toUpperCase()}$otherLetter';
        })
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
    return ICDResult().getResult(json.decode(res.body));
  }
}

const errk =
    'Initialize the ICD API. Call "ICD.initializeICDAPI()" and pass your clientID and ClientScretkey';
