import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';
import '../text_widgets/small_light_text.dart';

class DocumentMessageWidget extends StatefulWidget {
  final String? documentUrl;
  final String? documentName;
  final String? messageId;

  const DocumentMessageWidget({super.key,
    this.documentUrl,
    this.documentName,
    this.messageId
  });

  @override
  State<StatefulWidget> createState() => _DocumentMessageWidgetState();
}

class _DocumentMessageWidgetState extends State<DocumentMessageWidget> {
  String? _thumbnailPath;
  String? _pdfPath;

  @override
  void initState() {
    super.initState();
    if(mounted){
      _downloadAndGenerateThumbnail();
    }
  }

  Future<void> _downloadAndGenerateThumbnail() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final thumbnailPath = '${cacheDir.path}/${widget.messageId}_thumbnail.png';

      if (await File(thumbnailPath).exists()) {
        if(mounted){
          setState(() {
            _thumbnailPath = thumbnailPath;
          });
        }
        return;
      }
      print('${cacheDir.path}/${widget.messageId}.pdf');
      final pdfFilePath = '${cacheDir.path}/${widget.messageId}.pdf';
      await Dio().download(widget.documentUrl??'', pdfFilePath);
      _pdfPath = pdfFilePath;
      final document = await PdfDocument.openFile(pdfFilePath);
      final page = await document.getPage(1);
      final pageImage = await page.render(
        width: page.width,
        height: page.height,
        format: PdfPageImageFormat.png,
      );
      final thumbnailFile = File(thumbnailPath);
      await thumbnailFile.writeAsBytes(pageImage!.bytes);
      await page.close();
      if(mounted){
        setState(() {
          _thumbnailPath = thumbnailPath;
        });
      }
    } catch (e) {
      print('Error generating thumbnail: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.extraLightFadedTextColor.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(7.sp))
      ),
      child: Column(
        children: [
          _thumbnailPath != null
              ? ClipRRect(
            borderRadius: BorderRadius.only(topRight: Radius.circular(7.0.sp), topLeft: Radius.circular(7.sp)),
                child: Image.file(
                            File(_thumbnailPath!),
                            fit: BoxFit.cover,
                            height: 100,
                          ),
              )
              : Container(),
          // Document Info
          Padding(
            padding: EdgeInsets.all(10.sp),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.file_copy_outlined, size: 16.sp, color: AppColors.lightBlack,),
                SizedBox(width: 4.sp,),
                SmallLightText(
                  title: widget.documentName??'Document'.tr(),
                  textColor: AppColors.lightBlack,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
