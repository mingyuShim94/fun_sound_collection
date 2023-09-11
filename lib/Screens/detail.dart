import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final String imagePath, name;
  final num id;

  const DetailScreen(
      {super.key,
      required this.imagePath,
      required this.id,
      required this.name});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late AudioPlayer audioPlayer;
  late num id = widget.id;
  late String name = widget.name;
  // String audioPath = 'sounds/sound1.mp3';

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    // _initializeAudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  // Future<void> _initializeAudioPlayer() async {
  //   await audioPlayer.setSource(AssetSource(audioPath));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () async {
            // 다른 화면에서 이미지를 클릭하면 이전 화면으로 이동
            String audioPath = 'sounds/sound${id + 1}.mp3';
            // AudioPlayer audioPlayer = AudioPlayer();

            await audioPlayer.setSource(AssetSource(audioPath));
            await audioPlayer.setVolume(1);
            await audioPlayer.resume();
          },
          child: Hero(
            tag: widget.imagePath, // 이전 화면과 동일한 Hero 태그 사용
            child: Container(
              width: 300.0,
              height: 300.0,
              color: Colors.blue,
              child: Image.asset(widget.imagePath, fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }
}
