
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import '../../core/app_colors.dart';
import '../../core/size_config.dart';
import '../../core/utilities_class.dart';

class FullImageScreen extends StatefulWidget {
  final String imageUrl;

  const FullImageScreen({super.key, required this.imageUrl});

  @override
  State<StatefulWidget> createState() => _FullImageState();
}

class _FullImageState extends State<FullImageScreen>{
  bool loaded = false;
  double downloadProgress = 0.0;
  String urlPDFPath = "";
  bool exists = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: SizedBox(
              width: SizeConfig.screenWidth,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  InkWell(
                    onTap: () async {
                      _downloadImage(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5.0.sp),
                      child: Icon(
                        Icons.save_alt_rounded,
                        color: AppColors.white,
                        size: 20.0.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _downloadImage(BuildContext context) async {
    try {
      Utilities().showCustomToast(
        isError: false,
        message: "Downloading started...",
        title: "Downloading started",
      );

      // // ✅ Request Storage Permission for Android < 10
      // if (Platform.isAndroid) {
      //   var status = await Permission.storage.request();
      //   if (!status.isGranted) {
      //     Utilities().showCustomToast(
      //       isError: true,
      //       message: "Storage permission denied",
      //       title: "Error",
      //     );
      //     return;
      //   }
      // }

      // ✅ Fetch image bytes
      Response response = await Dio().get(
        widget.imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      Uint8List bytes = Uint8List.fromList(response.data);

      // ✅ Get Downloads directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download'); // Android Downloads folder
      } else {
        directory = await getApplicationDocumentsDirectory(); // iOS default directory
      }

      // ✅ Save file in Downloads
      String filePath = '${directory.path}/downloaded_image.jpg';
      File file = File(filePath);
      await file.writeAsBytes(bytes);
      Utilities().showCustomToast(
        isError: false,
        message: "Download completed! Check your Downloads folder.",
        title: "Success",
      );

    } catch (e) {
      Utilities().showCustomToast(
        isError: true,
        message: "Failed to download image",
        title: "Error",
      );
    }
  }
  // Future<void> _downloadImage(BuildContext context) async {
  //   try {
  //     // Show toast before download
  //     Utilities().showCustomToast(
  //       isError: false,
  //       message: "Downloading started...",
  //       title: "Downloading started",
  //     );
  //
  //     // Download image as bytes
  //     Response response = await Dio().get(
  //       widget.imageUrl,
  //       options: Options(responseType: ResponseType.bytes),
  //     );
  //
  //     Uint8List bytes = Uint8List.fromList(response.data);
  //
  //     // Save file using FileSaver
  //     String filePath = await FileSaver.instance.saveFile(
  //       name: "downloaded_image",
  //       bytes: bytes,
  //       ext: "jpg",
  //       mimeType: MimeType.jpeg,
  //     );
  //
  //     await MediaScanner.loadMedia(path: filePath);
  //
  //     // Show success message
  //     Utilities().showCustomToast(
  //       isError: false,
  //       message: "Download completed! Check your downloads.",
  //       title: "Success",
  //     );
  //
  //   } catch (e) {
  //     // Handle error
  //     Utilities().showCustomToast(
  //       isError: true,
  //       message: "Failed to download image",
  //       title: "Error",
  //     );
  //   }
  // }
  // Future<void> _downloadImage(BuildContext context) async {
  //   try {
  //     // Show toast before download
  //     Utilities().showCustomToast(
  //       isError: false,
  //       message: "Downloading started...",
  //       title: "Downloading started",
  //     );
  //
  //     // Download image as bytes
  //     Response response = await Dio().get(
  //       widget.imageUrl,
  //       options: Options(responseType: ResponseType.bytes),
  //     );
  //
  //     Uint8List bytes = Uint8List.fromList(response.data);
  //
  //     // Save the image to the gallery
  //     final result = await ImageGallerySaver.saveImage(bytes, quality: 100, name: "downloaded_image");
  //
  //     if (result['isSuccess']) {
  //       // Show success message
  //       Utilities().showCustomToast(
  //         isError: false,
  //         message: "Download completed! Check your gallery.",
  //         title: "Success",
  //       );
  //     } else {
  //       throw Exception('Failed to save image to gallery');
  //     }
  //
  //   } catch (e) {
  //     // Handle error
  //     Utilities().showCustomToast(
  //       isError: true,
  //       message: "Failed to download image",
  //       title: "Error",
  //     );
  //   }
  // }
}
