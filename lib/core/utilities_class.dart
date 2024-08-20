import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:groupchat/core/size_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:sizer/sizer.dart';

import '../component_library/dialogs/custom_dialog.dart';
import '../component_library/dialogs/pick_image_dialog.dart';
import '../component_library/dialogs/simple_error_dialog.dart';
import 'app_colors.dart';

class Utilities {
  Future<DateTime?> datePicker(BuildContext context, Color? color,
      {lastDate, firstDate, initialDate}) async {
    return showDatePicker(
            context: context,
            initialDate: initialDate ?? DateTime.now(),

            /// initial date from which user can select date
            firstDate: firstDate ?? DateTime(1950),

            ///initial value of date
            lastDate: lastDate ?? DateTime.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary:
                        color ?? Theme.of(context).primaryColor, // <-- SEE HERE
                    onPrimary: AppColors.white, // <-- SEE HERE
                    onSurface:
                        color ?? Theme.of(context).primaryColor, // <-- SEE HERE
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: color ??
                          Theme.of(context).primaryColor, // button text color
                    ),
                  ),
                ),
                child: child!,
              );
            })

        ///last date till user can select date
        .then((pickedDate) {
      ///future jobs after user action
      if (pickedDate == null) {
        //if user tap cancel then this function will stop and return null
        return null;
      } else {
        return pickedDate;
      }
    });
  }

  void showSnackbar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void showErrorMessage(BuildContext context,
      {String? message, Function()? onBtnTap, bool? barrierDismissible}) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible??true,
      builder: (context) {
        return SimpleErrorDialog(
          title: message ?? 'Some error occurred'.tr(),
          btnText: 'OK'.tr(),
          onBtnTap: onBtnTap ??
              () {
                Navigator.of(context).pop();
              },
        );
      },
    );
  }

  showSuccessDialog(BuildContext context,
      {String? message, Function()? onBtnTap, bool? barrierDismissle}) {
    showDialog(
        context: context,
        barrierDismissible: barrierDismissle ?? true,
        builder: (ctx) => CustomDialog(
              title1: "Success".tr(),
              title2: message ??
                  "All preferences has been saved successfully.".tr(),
              showBtn2: false,
              btn1Text: "OK".tr(),
              onBtn1Tap: onBtnTap ??
                  () {
                    Navigator.of(context).pop();
                  },
            ));
  }

  showImagePickerDialog(BuildContext context,
      {Function()? onCameraTap, Function()? onGalleryTap}) {
    showDialog(
      context: context,
      builder: (context) {
        return PickImageDialog(
            onCameraTap: onCameraTap, onGalleryTap: onGalleryTap);
      },
    );
  }

  static Future<XFile?> pickImage({String? imageSource}) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedImage = await imagePicker.pickImage(
        source: imageSource == "gallery"
            ? ImageSource.gallery
            : ImageSource.camera);
    if (pickedImage != null) {
      return pickedImage;
    } else {
      return null;
    }
  }

  String getMonthShortName(int val) {
    switch (val) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return val.toString();
    }
  }

  // Future<void> downloadFile(String url, String fileName, BuildContext context) async {
  //   try {
  //     Directory? downloadsDirectory = await getExternalStorageDirectory();
  //     if (downloadsDirectory != null) {
  //       String appDocPath = "${downloadsDirectory.path}/Download";
  //       await Directory(appDocPath).create(recursive: true);
  //       String filePath = "$appDocPath/$fileName";
  //       Dio dio = Dio();
  //       await dio.download(url, filePath, onReceiveProgress: (received, total) {
  //         if (total != -1) {
  //           print("Download progress: ${(received / total * 100).toStringAsFixed(0)}%");
  //         }
  //       });
  //       showSuccessDialog(context, message: '$fileName downloaded successfully');
  //     }
  //   } catch (e) {
  //     showErrorMessage(context, message: "Error downloading file: $e");
  //   }
  // }

  Future<Uint8List> fileToUint8List(File file) async {
    try {
      Uint8List fileBytes = await file.readAsBytes();
      return fileBytes;
    } catch (e) {
      print("Error converting file to Uint8List: $e");
      rethrow;
    }
  }

  Future<void> downloadFile(File fileObj, String fileName, context,
      {String? extension}) async {
    try {
      Uint8List bytes = await fileToUint8List(fileObj);
      final mimeType = lookupMimeType('$fileName$extension');
      String? path = await FileSaver.instance.saveAs(
          name: fileName,
          bytes: Uint8List.fromList(bytes),
          ext: extension ?? 'pdf',
          customMimeType: mimeType,
          mimeType: MimeType.custom);
      showSuccessDialog(context,
          message: '$fileName downloaded successfully in $path');
    } catch (e) {
      showErrorMessage(context, message: 'Download Failed: $e');
    }
  }

  void showTimePicker(BuildContext context, TimeOfDay selectedTime,
      Function(DateTime) onTimeChanged) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        DateTime now = DateTime.now();
        DateTime initialDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        return SizedBox(
          height: 280.0.sp,
          child: CupertinoDatePicker(
            initialDateTime: initialDateTime,
            mode: CupertinoDatePickerMode.time,
            use24hFormat: false,
            onDateTimeChanged: onTimeChanged,
          ),
        );
      },
    );
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat('hh:mm a'); // Format as '02:30 PM'
    return format.format(dt);
  }

  String convertTimeStampToString(int millis, {String? format}) {
    var dt = DateTime.fromMillisecondsSinceEpoch(millis);
    String d12 = DateFormat(format ?? 'dd MMM, yyyy').format(dt);
    return d12;
  }
}
