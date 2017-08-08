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

class SearchResultImpl extends JsonObject implements SearchResult {
  SearchResultImpl();

  factory SearchResultImpl.fromJsonString(string) {
    return new JsonObject.fromJsonString(string, new SearchResultImpl());
  }
}

class SearchResultsImpl extends JsonObject implements SearchResults {
  SearchResultsImpl();

  factory SearchResultsImpl.fromJsonString(string) {
    return new JsonObject.fromJsonString(string, new SearchResultsImpl());
  }
}


class ItunesPodcastSearcher {
  final template = new UriTemplate("https://itunes.apple.com/search{?term,entity}");

  Future<SearchResults> query(String term) async {
     var client = createHttpClient();
     var url = template.expand({'term': term, 'entity': 'podcast'});
     return client.get(url).then((response) {
        return SearchResultImpl.fromJsonString(response.body);
     });
  }
}