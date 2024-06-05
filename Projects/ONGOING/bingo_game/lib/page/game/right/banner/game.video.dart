import 'package:bingo_game/public/colors.dart';
import 'package:bingo_game/widget/myprogress_circular.dart';
import 'package:flutter/material.dart';
// Provides [Player], [Media], [Playlist] etc.
import 'package:video_player/video_player.dart'; // Provides [VideoController] & [Video] etc.
class GameVideoPage extends StatefulWidget {
  final double width;
  final double height;
  GameVideoPage({Key? key, required this.width, required this.height})
      : super(key: key);

  @override
  _GameVideoPageState createState() => _GameVideoPageState();
}

class _GameVideoPageState extends State<GameVideoPage> {
  late VideoPlayerController _controller;
  bool _isLoading = true;
  final url =  'https://user-images.githubusercontent.com/28951144/229373695-22f88f13-d18f-4288-9bf1-c3e078d83722.mp4';

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(url)..initialize().then((_) {
      setState(() {
        _isLoading = false;
      });
      _controller.play(); // Start playing automatically
    });
    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration) {
        _controller.seekTo(Duration.zero); // Seek back to the beginning
        _controller.play(); // Replay the video
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          color: Colors.black, // Background color to avoid transparency issues
          child: _isLoading
              ? Center(child: myprogress_circular_size())
              : FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: _controller.value.size.width ?? widget.width,
                    height:_controller.value.size.height?? widget.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
        ),
      ],
    );
  }
  
}