import 'dart:io';

import "package:test/test.dart";
import "package:xml/xml.dart" as xml;

import "package:flup/podcast_feed_reader.dart";

void main() {
  var file;
  setUp(() {
    file = new File('/Users/trhodes/IdeaProjects/flup/lib/podcast.xml').readAsStringSync();
  });
  test("Parses the file", () {
    var channel = createPodcastChannel(xml.parse(file));
    expect(channel.title, equals("Hidden Brain"));
    expect(channel.episodes, hasLength(102));
  });
}