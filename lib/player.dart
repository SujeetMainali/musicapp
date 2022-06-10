

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/Musics.dart';

class Player extends StatefulWidget {
  const Player({Key? key, required this.music}) : super(key: key);
  final Musics music;
  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  bool isPlaying = false;
  final audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    audioPlayer.onPlayerStateChanged.listen((audioState) {
      setState(() {
        isPlaying = audioState == PlayerState.PLAYING;
      });
    });

    audioPlayer.onDurationChanged.listen((audioDuration) {
      setState(() {
        duration = audioDuration;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((audioPosition) {
      setState(() {
        position = audioPosition;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.music.title),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                children: [
                  Container(
                    height: 270.0,
                    width: 270.0,
                    // color: Colors.purple.shade100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(180.0),
                      child: Image.network(
                        widget.music.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Slider(
                    activeColor: Colors.green,
                    inactiveColor: Colors.red.shade300,
                      min: 0,
                      max: duration.inSeconds.toDouble(),
                      value: position.inSeconds.toDouble(),
                      onChanged: (value) async {
                        position = Duration(seconds: value.toInt());
                        await audioPlayer.seek(position);
                      }),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          widget.music.title,
                          style: const TextStyle(
                              fontSize: 30.0, color: Colors.white),
                        ),
                        Text(
                          widget.music.singer,
                          style: const TextStyle(
                              fontSize: 20.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.skip_previous_rounded),
                        iconSize: 70,
                        color: Colors.white,
                      ),
                      IconButton(
                        onPressed: () async {
                          if (isPlaying == true) {
                            await audioPlayer.pause();
                          } else {
                            await audioPlayer.play(widget.music.url);
                          }
                        },
                        icon: Icon(
                            isPlaying ? Icons.pause_circle : Icons.play_circle),
                        iconSize: 70,
                        color: Colors.white,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.skip_next_rounded),
                        iconSize: 70,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
