import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:groupchat/component_library/app_bars/custom_app_bar.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';
import '../../core/size_config.dart';

class PdfViewScreen extends StatefulWidget {
  static const route = 'PdfViewScreen';

  final String? url;
  final String? title;

  const PdfViewScreen({super.key, this.url, this.title});

  @override
  State<StatefulWidget> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  String urlPDFPath = "";
  bool exists = true;
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  PDFViewController? _pdfViewController;
  bool loaded = false;
  double downloadProgress = 0.0;

  Future<File> getFileFromUrl(String url, {String? name}) async {
    var fileName = name ?? 'testonline';
    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$fileName.pdf");

      if (await file.exists()) {
        setState(() {
          urlPDFPath = file.path;
          loaded = true;
          exists = true;
        });
        return file;
      } else {
        var response = await http.Client().send(http.Request('GET', Uri.parse(url)));
        var bytes = <int>[];
        var totalBytes = response.contentLength ?? 0;
        var receivedBytes = 0;

        response.stream.listen((chunk) {
          setState(() {
            bytes.addAll(chunk);
            receivedBytes += chunk.length;
            downloadProgress = receivedBytes / totalBytes;
          });
        }).onDone(() async {
          await file.writeAsBytes(bytes);
          setState(() {
            urlPDFPath = file.path;
            loaded = true;
            exists = true;
          });
        });

        return file;
      }
    } catch (e) {
      throw Exception("Error opening url file: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getFileFromUrl(widget.url ?? '', name: widget.title??'').catchError((error) {
      setState(() {
        exists = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          child: Column(
            children: [
              CustomAppBar(
                title: widget.title ?? '',
                trailingWidget: InkWell(
                  onTap: () async {
                    Utilities().showCustomToast(isError: false, message: '...', title: 'Downloading started'.tr());
                    await Utilities().downloadFile(await getFileFromUrl(widget.url ?? '', name: widget.title ?? ''),
                        widget.title ?? '', extension: '.pdf', context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(5.0.sp),
                    child: Icon(
                      Icons.save_alt_rounded,
                      color: AppColors.lightBlack,
                      size: 20.0.sp,
                    ),
                  ),
                ),
              ),
              loaded && exists
                  ? Expanded(
                child: PDFView(
                  filePath: urlPDFPath,
                  autoSpacing: true,
                  enableSwipe: true,
                  pageSnap: true,
                  preventLinkNavigation: false,
                  swipeHorizontal: false,
                  nightMode: false,
                  onError: (e) {
                    print("PDF View Error: $e");
                  },
                  onRender: (pages) {
                    setState(() {
                      _totalPages = pages!;
                      pdfReady = true;
                    });
                  },
                  onViewCreated: (PDFViewController vc) {
                    setState(() {
                      _pdfViewController = vc;
                    });
                  },
                  onPageChanged: (page, total) {
                    setState(() {
                      _currentPage = page!;
                    });
                  },
                  onPageError: (page, e) {
                    print("Page Error: $e");
                  },
                ),
              )
                  : Expanded(
                child: Center(
                  child: CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 8.0,
                    percent: downloadProgress,
                    center: Text(
                      "${(downloadProgress * 100).toInt()}%",
                      style: TextStyle(color: AppColors.mainColorDark),
                    ),
                    progressColor: AppColors.mainColorDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
