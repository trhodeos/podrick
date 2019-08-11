import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:audioplayer/audioplayer.dart';

const kUrl = "http://www.rxlabz.com/labz/audio2.mp3";
enum _PlayerState { stopped, playing, paused }

class PodcastPlayer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _PodcastPlayerState();
  }
}

class _PodcastPlayerState extends State<PodcastPlayer> {
  Duration duration;
  Duration position;

  AudioPlayer audioPlayer;

  _PlayerState playerState = _PlayerState.stopped;

  get isPlaying => playerState == _PlayerState.playing;

  get isPaused => playerState == _PlayerState.paused;

  get durationText =>
      duration != null ? duration
          .toString()
          .split(".")
          .first : '';

  get positionText =>
      position != null ? position
          .toString()
          .split(".")
          .first : '';

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();
    audioPlayer.setDurationHandler((d) =>
        setState(() {
          print('_PodcastPlayerState.setDurationHandler => d $d');
          duration = d;
        }));
    audioPlayer.setPositionHandler((p) =>
        setState(() {
          print('_PodcastPlayerState.setPositionHandler => p $p');
          position = p;
        }));
    audioPlayer.setCompletionHandler(() {
      onComplete();
      setState(() {
        position = duration;
      });
    });

    audioPlayer.setErrorHandler((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        playerState = _PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

  Future play() async {
    final result = await audioPlayer.play(kUrl);
    if (result == 1) setState(() => playerState = _PlayerState.playing);
  }

  Future pause() async {
    final result = await audioPlayer.pause();
    if (result == 1) setState(() => playerState = _PlayerState.paused);
  }

  Future stop() async {
    final result = await audioPlayer.stop();
    if (result == 1)
      setState(() {
        playerState = _PlayerState.stopped;
        duration = new Duration();
      });
  }

  void onComplete() {
    setState(() => playerState = _PlayerState.stopped);
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Material(
            elevation: 2.0,
            color: Colors.grey[200],
            child: new Column(children: <Widget>[
              new Material(
                  child:
                  new Container(
                      padding: new EdgeInsets.all(16.0),
                      child: new Column(
                        mainAxisSize: MainAxisSize.min, children: <Widget>[
                        new Row(
                          mainAxisSize: MainAxisSize.min, children: <Widget>[
                          new IconButton(icon: new Icon(Icons.play_arrow),
                              onPressed: isPlaying ? null : () => play(),
                              iconSize: 64.0),
                          new IconButton(icon: new Icon(Icons.pause),
                            onPressed: isPlaying ? () => pause() : null,
                            iconSize: 64.0,),
                          new IconButton(icon: new Icon(Icons.stop),
                            onPressed: isPlaying || isPaused
                                ? () => stop()
                                : null,
                            iconSize: 64.0,)
                        ],)
                      ],)
                  )
              )

            ],)
        )
    );
  }
}
