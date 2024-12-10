// import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'package:organizer_app/Screens/ListEvent/HelperWidget/video_player.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class VideoThumbnailPlayer extends StatelessWidget {
//   final String videoUrl;

//   const VideoThumbnailPlayer({super.key, required this.videoUrl});

//   @override
//   Widget build(BuildContext context) {
//     final videoId = YoutubePlayer.convertUrlToId(videoUrl);
//     return Stack(
//       children: [
//         Container(
//           height: 100,
//           width: 100,
//           margin: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.shade300,
//                 offset: const Offset(0.5, 0.5),
//                 blurRadius: 0.5,
//                 spreadRadius: 0.5,
//               ),
//               const BoxShadow(
//                 color: Colors.white,
//                 offset: Offset(0.0, 0.0),
//                 blurRadius: 0.0,
//                 spreadRadius: 0.0,
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(15),
//             child: videoId != null
//                 ? FadeInImage.assetNetwork(
//                     placeholder: 'assets/ezgif.com-crop.gif',
//                     placeholderCacheHeight: 100,
//                     placeholderCacheWidth: 100,
//                     placeholderFit: BoxFit.cover,
//                     image: YoutubePlayer.getThumbnail(
//                         videoId: YoutubePlayer.convertUrlToId(videoUrl)!),
//                     fit: BoxFit.cover,
//                   )
//                 : const SizedBox.shrink(),
//           ),
//         ),
//         Positioned(
//           top: 35,
//           left: 35,
//           child: IconButton(
//             icon: const Icon(
//               Icons.play_arrow,
//               color: Colors.white,
//               size: 35,
//             ),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => YoutubeVideoPlayerWidget(
//                     videoUrl: videoUrl, eventData: null,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
