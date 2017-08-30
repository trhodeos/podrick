import 'dart:async';

import 'package:flutter/material.dart';
import 'itunes_podcast_searcher.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

final googleSignIn = new GoogleSignIn();
final auth = FirebaseAuth.instance;
final libraryReference = FirebaseDatabase.instance.reference().child('library');

Future<Null> _ensureLoggedIn() async {
  GoogleSignInAccount user = googleSignIn.currentUser;
  if (user == null) user = await googleSignIn.signInSilently();
  if (user == null) {
    await googleSignIn.signIn();
  }
  if (auth.currentUser == null) {
    GoogleSignInAuthentication credentials =
        await googleSignIn.currentUser.authentication;
    await auth.signInWithGoogle(
      idToken: credentials.idToken,
      accessToken: credentials.accessToken,
    );
  }
}

class FlupHomePage extends StatefulWidget {
  FlupHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FlupHomePageState createState() => new _FlupHomePageState();
}

class TabChoice {
  final String title;
  final IconData icon;

  const TabChoice({this.title, this.icon});
}

const List<TabChoice> choices = const <TabChoice>[
  const TabChoice(title: "Library", icon: Icons.library_music),
  const TabChoice(title: "Find", icon: Icons.search)
];

final Image placeholder = new Image.network("placeholder");

class PodcastChannelWidget extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String rssUrl;

  PodcastChannelWidget(
      {this.title,
      this.imageUrl = "http://via.placeholder.com/100x100",
      this.rssUrl});

  factory PodcastChannelWidget.createForSnapshot(snapshot) {
    return new PodcastChannelWidget(
        title: snapshot.value['title'],
        imageUrl: snapshot.value['imageUrl'],
        rssUrl: snapshot.value['rssUrl']);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: 80.0,
        child: new InkWell(
          child: new Container(
              height: 56.0,
              child: new Row(children: [
                new Hero(
                    tag: title,
                    child: new Image.network(imageUrl, fit: BoxFit.contain)),
                new Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    child: new Text(title)),
              ])),
          onTap: () => Navigator.pushNamed(
              context, '/channel:${Uri.encodeQueryComponent(rssUrl)}'),
        ));
  }
}

class LibraryWidget extends StatefulWidget {
  @override
  _LibraryWidgetState createState() => new _LibraryWidgetState();
}

class _LibraryWidgetState extends State<LibraryWidget> {
  @override
  Widget build(BuildContext context) {
    _ensureLoggedIn();
    return new Column(
      children: <Widget>[
        new Flexible(
            child: new FirebaseAnimatedList(
          query: libraryReference,
          sort: (a, b) => b.key.compareTo(a.key),
          padding: new EdgeInsets.all(8.0),
          itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation) {
            return new PodcastChannelWidget.createForSnapshot(snapshot);
          },
        )),
      ],
    );
  }
}

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => new _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  SearchResults results;

  _updateSearch(s) async {
    var local = await queryItunes(s);
    setState(() {
      results = local;
    });
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      new TextField(
          maxLines: 1,
          autocorrect: false,
          keyboardType: TextInputType.text,
          decoration: new InputDecoration(icon: new Icon(Icons.search)),
          onChanged: (s) {
            _updateSearch(s);
          })
    ];

    if (results != null) {
      for (var result in results.results) {
        children.add(new PodcastChannelWidget(
            title: result.collectionName,
            imageUrl: result.getBestArtwork(),
            rssUrl: result.feedUrl));
      }
    }

    return new Container(child: new ListView(children: children));
  }
}

class _FlupHomePageState extends State<FlupHomePage> {
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: choices.length,
        child: new Scaffold(
            appBar: new AppBar(
                title: new Text(widget.title),
                bottom: new TabBar(
                  isScrollable: false,
                  tabs: choices.map((choice) {
                    return new Tab(
                        text: choice.title, icon: new Icon(choice.icon));
                  }).toList(),
                )),
            body: new TabBarView(
                children: choices.map((choice) {
              if (choice.title == "Library") {
                return new LibraryWidget();
              } else if (choice.title == "Find") {
                return new SearchWidget();
              }
            }).toList())));
  }
}
