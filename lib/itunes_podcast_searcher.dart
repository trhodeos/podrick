import 'dart:async';
import 'dart:convert';

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

class _SearchResultImpl implements SearchResult {

  _SearchResultImpl(this.artistName, this.artworkUrl100, this.artworkUrl30,
      this.artworkUrl60, this.artworkUrl600, this.collectionName, this.feedUrl,
      this.genres, this.kind, this.trackCount);

  factory _SearchResultImpl.fromMap(object) {
    return new _SearchResultImpl(
        object['artistName'],
        object['artworkUrl100'],
        object['artworkUrl30'],
        object['artworkUrl60'],
        object['artworkUrl600'],
        object['collectionName'],
        object['feedUrl'],
        object['genres'],
        object['kind'],
        object['trackCount']);
  }
  @override
  String artistName;

  @override
  String artworkUrl100;

  @override
  String artworkUrl30;

  @override
  String artworkUrl60;

  @override
  String artworkUrl600;

  @override
  String collectionName;

  @override
  String feedUrl;

  @override
  Iterable<String> genres;

  @override
  String kind;

  @override
  int trackCount;
}

class _SearchResultsImpl  implements SearchResults {

  _SearchResultsImpl(this.results, this.resultsCount);

  factory _SearchResultsImpl.fromMap(object) {
    var resultsCount = object['resultCount'];
    var results = <_SearchResultImpl>[];
    for (var s in object['results']) {
      results.add(new _SearchResultImpl.fromMap(s));
    }

    return new _SearchResultsImpl(results, resultsCount);
  }

  @override
  Iterable<SearchResult> results;

  @override
  int resultsCount;
}


final _template = new UriTemplate("https://itunes.apple.com/search{?term,entity}");

Future<SearchResults> queryItunes(String term) async {
   var client = createHttpClient();
   var url = _template.expand({'term': term, 'entity': 'podcast'});
   print("Querying itunes for term: " + term);
   print(url);
   return client.read(url).then((body) {
     JsonCodec codec = new JsonCodec();
     Map<String, dynamic> object = codec.decode(body);
     SearchResults results = new _SearchResultsImpl.fromMap(object);
     return results;
   });
}