import 'package:flutter/material.dart';
import 'package:organizer_app/Model/event_data_model.dart';
import 'package:organizer_app/Screens/ListEvent/HelperWidget/event_details.dart';
import 'package:organizer_app/Utils/const_color.dart';
import 'package:organizer_app/CommonWidgets/text_style.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final EventDataModel eventData;

  const YoutubeVideoPlayerWidget(
      {super.key, required this.videoUrl, required this.eventData});

  @override
  _YoutubeVideoPlayerWidgetState createState() =>
      _YoutubeVideoPlayerWidgetState();
}

class _YoutubeVideoPlayerWidgetState extends State<YoutubeVideoPlayerWidget> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    String? videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? "",
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: YoutubePlayerBuilder(
        player: YoutubePlayer(
          aspectRatio: 16 / 9,
          bufferIndicator: const CircularProgressIndicator(
            color: Colors.red,
          ),
          controller: _controller!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.red,
          progressColors: const ProgressBarColors(
            playedColor: Colors.red,
            handleColor: Colors.redAccent,
          ),
        ),
        builder: (context, player) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: primaryColor,
              elevation: 0,
              title: Text(
                "Video Player",
                style: textStyle(22, Colors.white, FontWeight.w500),
              ),
              leading: BackButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) =>
                  //           EventDetailsScreen(eventData: widget.eventData)),
                  // ); // Navigate back
                },
                color: Colors.black,
              ),
            ),
            body: Center(
              child: player,
            ),
          );
        },
      ),
    );
  }
}
