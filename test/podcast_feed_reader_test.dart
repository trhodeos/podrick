import 'dart:io';

import "package:test/test.dart";
import "package:xml/xml.dart" as xml;

import "package:flup/feed_reader.dart";

void main() {
  var file;
  setUp(() {
    file = new File('test/podcast.xml').readAsStringSync();
  });
  test("Parses the file", () {
    var channel = decodePodcast(xml.parse(file));
    expect(channel.title, equals("Hidden Brain"));
    expect(channel.episodes, hasLength(102));
  });
}