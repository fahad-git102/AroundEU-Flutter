import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../../core/app_colors.dart';

class VideoMessageWidget extends StatefulWidget {
  final String videoUrl;

  const VideoMessageWidget({super.key, required this.videoUrl});

  @override
  State<StatefulWidget> createState() => _CachedVideoThumbnailWidgetState();
}

class _CachedVideoThumbnailWidgetState extends State<VideoMessageWidget> {
  String? _thumbnailPath;

  @override
  void initState() {
    super.initState();
    if(mounted){
      _generateAndCacheThumbnail();
    }
  }

  Future<void> _generateAndCacheThumbnail() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final videoFileName = basename(widget.videoUrl); // Get the base name of the video
      final cachedThumbnailPath = '${tempDir.path}/$videoFileName-thumbnail.png';
      final cachedThumbnailFile = File(cachedThumbnailPath);
      if (await cachedThumbnailFile.exists()) {
        if(mounted){
          setState(() {
            _thumbnailPath = cachedThumbnailPath;
          });
        }
      } else {
        final thumbnailPath = await VideoThumbnail.thumbnailFile(
          video: widget.videoUrl,
          thumbnailPath: cachedThumbnailPath,
          imageFormat: ImageFormat.PNG,
          maxHeight: 100,
          quality: 60,
        );

        if (thumbnailPath != null) {
          if(mounted){
            setState(() {
              _thumbnailPath = thumbnailPath;
            });
          }
        }
      }
    } catch (e) {
      print('Error generating video thumbnail: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.sp,
      width: 135.sp,
      decoration: BoxDecoration(
        color: AppColors.lightBlack,
        borderRadius: BorderRadius.all(Radius.circular(7.0.sp))
      ),
      child: Stack(
        children: [
          _thumbnailPath!=null? ClipRRect(borderRadius: BorderRadius.all(Radius.circular(7.0.sp)), child: Image.file(File(_thumbnailPath??''), height: 100.sp, width: 135.sp, fit: BoxFit.cover,)):
              Container(),
          Container(
            decoration: BoxDecoration(
                color: AppColors.lightBlack.withOpacity(0.35),
                borderRadius: BorderRadius.all(Radius.circular(7.0.sp))
            ),
          ),
          Center(
            child: Icon(Icons.play_arrow, size: 48.sp, color: AppColors.white,),
          )
        ],
      ),
    );
  }
}