import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_saver/file_saver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as text_direction;
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/firebase/auth.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

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
         firstDate: firstDate ?? DateTime(1950),

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

  String getDeviceType() {
    final data = MediaQueryData.fromView(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600 ? 'phone' :'tablet';
  }

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Account Deletion'.tr()),
          content: Text('Are you sure you want to delete your account? This action cannot be undone.'.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancel
              child: Text('Cancel'.tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Auth().deleteAccount(context);
              },
              child: ExtraMediumText(
                title: 'Delete'.tr(),
                textColor: AppColors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> showReauthenticateDialog(BuildContext context) async {
    final TextEditingController passwordController = TextEditingController();
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) {
      Utilities().showCustomToast(message: 'No user is currently signed in.'.tr(), isError: true);
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reauthenticate'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please enter your password to delete your account.'.tr()),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password'.tr(),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: Text('Cancel'.tr()),
            ),
            ElevatedButton(
              onPressed: () async {
                final String password = passwordController.text.trim();
                Navigator.of(context).pop(); // Close the dialog

                if (password.isNotEmpty) {
                  await Auth().reauthenticateUser(user.email!, password, context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Password cannot be empty.'.tr())),
                  );
                }
              },
              child: Text('Confirm'.tr()),
            ),
          ],
        );
      },
    );
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

  void showCustomToast({String? title, required String? message, required bool? isError}){
    toastification.show(
      type: isError==true?ToastificationType.error:ToastificationType.success,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text(title ?? (isError==true?'Oops':'Success'.tr())),
      description: RichText(
          text: TextSpan(
              text:
              message??'')),
      alignment: Alignment.bottomCenter,
      direction: text_direction.TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      icon: isError==true ? Icon(Icons.error_outline) : Icon(Icons.check),
      showIcon: true,
      primaryColor: isError==true? Colors.red:Colors.green,
      backgroundColor: Colors.white,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(
          horizontal: 12.sp, vertical: 16.sp),
      margin:  EdgeInsets.symmetric(
          horizontal: 12.sp, vertical: 20.sp),
      borderRadius: BorderRadius.circular(12.sp),
      closeButtonShowType:
      CloseButtonShowType.always,
      showProgressBar: false,
      closeOnClick: true,
      dragToClose: true,
      callbacks: ToastificationCallbacks(
        onCloseButtonTap: (toastItem) {
          Toastification().dismiss(toastItem);
        },
      ),
    );
  }

  void launchDialer(String phoneNumber) async {
    String sanitizedPhoneNumber = phoneNumber.replaceAll(' ', '');
    try {
      final Uri phoneUri = Uri(
        scheme: 'tel',
        path: sanitizedPhoneNumber,
      );

      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      }
    } catch (e) {
      print('Error launching dialer: $e');
    }
  }

  String parseHtmlToPlainText(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  String formatTimestamp(int timestamp) {
    DateTime now = DateTime.now();
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

    if (date.isAfter(today)) {
      return DateFormat('hh:mm aa').format(date);
    } else if (date.isAfter(yesterday)) {
      return 'Yesterday ${DateFormat('hh:mm aa').format(date)}';
    } else {
      return DateFormat('MMM d hh:mm aa').format(date);
    }
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

  String getFileNameFromStorageUrl(String url) {
    Uri uri = Uri.parse(url);
    String decodedPath = Uri.decodeFull(uri.path);
    return decodedPath.split('/').last;
  }

  Future<String> downloadFileIfNotExists(String url, String fileName) async {
    try {
      var dir = await getApplicationDocumentsDirectory();
      String filePath = "${dir.path}/$fileName";
      File file = File(filePath);
      if (await file.exists()) {
        print("File already exists at: $filePath");
        return filePath;
      }
      Dio dio = Dio();
      await dio.download(url, filePath);
      print("File downloaded to: $filePath");

      return filePath;
    } catch (e) {
      print("Error: $e");
      return "";
    }
  }

  Future<void> saveMap(String key, Map<String, dynamic> mapData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(mapData);
    await prefs.setString(key, jsonString);
  }

  Future<Map<String, dynamic>?> getMap(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(key);
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  String getMimeTypeFromExtension(String extension) {
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'ppt':
        return 'application/vnd.ms-powerpoint';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case 'txt':
        return 'text/plain';
      default:
        return 'application/octet-stream';
    }
  }

  Future<String>? handleFileDownload(String url, String fileName) async {
    String filePath = await downloadFileIfNotExists(url, fileName);

    if (filePath.isNotEmpty) {
      return filePath;
    } else {
      print("Failed to download or find the file");
      return '';
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
