import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:uri/uri.dart';

class SearchResult {
  SearchResult(this.artistName, this.artworkUrl100, this.artworkUrl30,
      this.artworkUrl60, this.artworkUrl600, this.collectionName, this.feedUrl,
      this.genres, this.kind, this.trackCount);

  factory SearchResult.fromMap(object) {
    return new SearchResult(
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

  final String artistName;
  final String artworkUrl100;
  final String artworkUrl30;
  final String artworkUrl60;
  final String artworkUrl600;
  final String collectionName;
  final String feedUrl;
  final Iterable<String> genres;
  final String kind;
  final int trackCount;

  String getBestArtwork() {
    if (artworkUrl600 != null) {
      return artworkUrl600;
    } else if (artworkUrl100 != null) {
      return artworkUrl100;
    } else if (artworkUrl60 != null) {
      return artworkUrl60;
    } else if (artworkUrl30 != null) {
      return artworkUrl30;
    } else {
      return "";
    }
  }
}

class SearchResults {

  SearchResults(this.results, this.resultsCount);

  factory SearchResults.fromMap(object) {
    var resultsCount = object['resultCount'];
    var results = <SearchResult>[];
    for (var s in object['results']) {
      results.add(new SearchResult.fromMap(s));
    }

    return new SearchResults(results, resultsCount);
  }

  final Iterable<SearchResult> results;
  final int resultsCount;
}


final _template = new UriTemplate("https://itunes.apple.com/search{?term,entity}");

Future<SearchResults> queryItunes(String term) async {
   var client = createHttpClient();
   var url = _template.expand({'term': term, 'entity': 'podcast'});
   return client.read(url).then((body) {
     JsonCodec codec = new JsonCodec();
     Map<String, dynamic> object = codec.decode(body);
     SearchResults results = new SearchResults.fromMap(object);
     return results;
   });
}