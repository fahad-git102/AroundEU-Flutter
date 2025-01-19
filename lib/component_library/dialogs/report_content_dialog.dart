import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/component_library/text_fields/simple_text_field.dart';
import 'package:groupchat/component_library/text_widgets/extra_large_medium_bold_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/firebase/auth.dart';
import 'package:sizer/sizer.dart';

import '../../core/static_keys.dart';
import '../../firebase/firebase_crud.dart';

class ReportContentDialog extends StatelessWidget {
  final String contentId;
  final String contentType;

  const ReportContentDialog(
      {Key? key, required this.contentId, required this.contentType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      // Dismiss dialog when tapping outside
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ReportContentForm(
            contentId: contentId,
            contentType: contentType,
          ),
        ),
      ),
    );
  }
}

class ReportContentForm extends StatefulWidget {
  final String contentId;
  final String contentType;

  const ReportContentForm(
      {Key? key, required this.contentId, required this.contentType})
      : super(key: key);

  @override
  State<ReportContentForm> createState() => _ReportContentFormState();
}

class _ReportContentFormState extends State<ReportContentForm> {
  String? selectedReason;
  final TextEditingController additionalDetailsController =
      TextEditingController();

  final List<String> reportReasons = [
    "Spam".tr(),
    "Hate Speech".tr(),
    "Harassment or Bullying".tr(),
    "Misinformation".tr(),
    "Explicit Content".tr(),
    "Other".tr(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExtraLargeMediumBoldText(
          title: 'Report Content'.tr(),
          fontSize: 18.sp,
        ),
        SizedBox(height: 16.sp),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: "Reason for reporting".tr(),
            labelStyle: TextStyle(fontSize: 10.sp)
          ),
          value: selectedReason,
          items: reportReasons.map((reason) {
            return DropdownMenuItem(
              value: reason,
              child: Text(reason),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedReason = value;
            });
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: additionalDetailsController,
          maxLines: 3,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: "Additional details (optional)".tr(),
              labelStyle: TextStyle(fontSize: 10.sp)
          ),
        ),
        SizedBox(height: 16.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel".tr()),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // text color
                  backgroundColor: Colors.black),
              onPressed: () {
                if (selectedReason != null) {
                  _submitReport(context);
                } else {
                  Utilities().showCustomToast(
                      message: 'Please select a reason.'.tr(), isError: true);
                }
              },
              child: Text("Submit".tr()),
            ),
          ],
        ),
      ],
    );
  }

  void _submitReport(BuildContext context) {
    final reportData = {
      "contentId": widget.contentId,
      "contentType": widget.contentType,
      "reason": selectedReason,
      "details": additionalDetailsController.text.trim(),
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "uid": Auth().currentUser?.uid
    };

    String? key = FirebaseDatabase.instance.ref(reports).push().key;
    FirebaseCrud().setData(
      key: "$reports/$key",
      context: context,
      data: reportData,
      onComplete: (){
        Utilities().showCustomToast(
            message: 'Thank you for your report.'.tr(), isError: false);
        Navigator.pop(context);
      },
      onCatchError: (p0){
        Utilities().showCustomToast(
            message: 'Failed: ${p0.toString()}'.tr(), isError: false);
      },
    );
  }
}
