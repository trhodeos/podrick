import 'dart:async';

import 'package:json_object/json_object.dart';
import 'package:flutter/services.dart';
import 'package:uri/uri.dart';

abstract class SearchResult {
  String kind;
  String artistName;
  String collectionName;
  String feedUrl;
  String artworkUrl30;
  String artworkUrl60;
  String artworkUrl100;
  String artworkUrl600;
  int trackCount;
  Iterable<String> genres;
}

abstract class SearchResults {
  int resultsCount;
  Iterable<SearchResult> results;
}

class _SearchResultImpl extends JsonObject implements SearchResult {
  _SearchResultImpl();

  factory _SearchResultImpl.fromJsonString(string) {
    return new JsonObject.fromJsonString(string, new _SearchResultImpl());
  }
}

class _SearchResultsImpl extends JsonObject implements SearchResults {
  _SearchResultsImpl();

  factory _SearchResultsImpl.fromJsonString(string) {
    return new JsonObject.fromJsonString(string, new _SearchResultsImpl());
  }
}


final _template = new UriTemplate("https://itunes.apple.com/search{?term,entity}");

Future<SearchResults> queryItunes(String term) async {
   var client = createHttpClient();
   var url = _template.expand({'term': term, 'entity': 'podcast'});
   return client.get(url).then((response) {
      return _SearchResultImpl.fromJsonString(response.body);
   });
}