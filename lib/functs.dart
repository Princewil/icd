import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:icd/api.dart';
import 'package:icd/icd.dart';

///for getting access token
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

///for querying the ICD Database
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

///enums that will enable refining the search results
enum ICDPropertiesSearch {
  title,
  synonym,
  narrowerTerm,
  fullySpecifiedName,
  definition,
  exclusion
}

///Class that holds the search results
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

///for getting the keyword as specified on the Doc
String getPropertiesToBeSearchedKeyWord(
    ICDPropertiesSearch icdPropertiesSearch) {
  if (icdPropertiesSearch == ICDPropertiesSearch.synonym) {
    return 'Synonym';
  } else if (icdPropertiesSearch == ICDPropertiesSearch.narrowerTerm) {
    return 'NarrowerTerm';
  } else if (icdPropertiesSearch == ICDPropertiesSearch.fullySpecifiedName) {
    return 'FullySpecifiedName';
  } else if (icdPropertiesSearch == ICDPropertiesSearch.definition) {
    return 'Definition';
  } else if (icdPropertiesSearch == ICDPropertiesSearch.exclusion) {
    return 'Exclusion';
  } else {
    return 'Title';
  }
}

const errk =
    'Initialize the ICD API. Call "ICD.initializeICDAPI()" and pass your clientID and ClientScretkey';
