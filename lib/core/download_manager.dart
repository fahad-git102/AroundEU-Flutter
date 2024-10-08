import 'dart:io';
import 'package:dio/dio.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class DownloadManager{

  Future<void> downloadFile(String url, String fileName) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = "${appDocDir.path}/$fileName";
      if (await File(filePath).exists()) {
        OpenFile.open(filePath);
        return;
      }
      Utilities().showCustomToast(message: "Downloading...", isError: false);
      Dio dio = Dio();
      await dio.download(url, filePath);
      OpenFile.open(filePath);
      Utilities().showCustomToast(message: "File downloaded to: $filePath", isError: false);
    } catch (e) {
      Utilities().showCustomToast(message: 'Error downloading file: $e', isError: true);
    }
  }


}