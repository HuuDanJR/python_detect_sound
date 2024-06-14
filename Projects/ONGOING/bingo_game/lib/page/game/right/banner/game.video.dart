import 'package:bingo_game/page/game/left/export.dart';
import 'package:bingo_game/page/game/right/export.dart';
// Provides [Player], [Media], [Playlist] etc.
import 'package:video_player/video_player.dart'; // Provides [VideoController] & [Video] etc.

class GameVideoPlay extends StatefulWidget {
  final double width;
  final double height;
  final String url;
  const GameVideoPlay({super.key, required this.width, required this.height,required this.url});

  @override
  _GameVideoPlayState createState() => _GameVideoPlayState();
}

class _GameVideoPlayState extends State<GameVideoPlay> {
  late VideoPlayerController _controller;
  // final url =  'https://private-user-images.githubusercontent.com/40542971/337220670-af5935d1-db1a-431b-938d-dd41e16c1f9e.mov?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MTc2Njg4MjcsIm5iZiI6MTcxNzY2ODUyNywicGF0aCI6Ii80MDU0Mjk3MS8zMzcyMjA2NzAtYWY1OTM1ZDEtZGIxYS00MzFiLTkzOGQtZGQ0MWUxNmMxZjllLm1vdj9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNDA2MDYlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjQwNjA2VDEwMDg0N1omWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTJmMTgzM2M5ZDAxYTM5Mjc5YTJkZWIzN2FmMGEzZGI3N2Y1NjZkZTNmODY5N2YxNjU4M2QyYTg1MThhMTQ1NjYmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JmFjdG9yX2lkPTAma2V5X2lkPTAmcmVwb19pZD0wIn0.VW8ENdjucemmYCMFwXVdodfCWvTGQLMbL0AUF9wJ2X0';
  final bool _isLoading = true;
  final bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        // setState(() {
        //   _isLoading = false;
        // });
        _controller.play(); // Replay the video
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

  void _togglePlayPause() {
    // setState(() {
    //   if (_controller.value.isPlaying) {
    //     _controller.pause();
    //     _isPlaying = false;
    //   } else {
    //     _controller.play();
    //     _isPlaying = true;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(StringFactory.padding56),
          child: FittedBox(
            fit: BoxFit.cover,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(StringFactory.padding56),
                  color: MyColor.black_absulute),
              width: widget.width,
              height: widget.height,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
        // if (!_isPlaying)
        //   Positioned.fill(
        //     child: Center(
        //       child: IconButton(
        //         icon: const Icon(Icons.play_arrow,
        //             color: Colors.white, size: StringFactory.padding22),
        //         onPressed: _togglePlayPause,
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}
