import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:groupchat/component_library/app_bars/custom_app_bar.dart';
import 'package:sizer/sizer.dart';

class PlaceSearchScreen extends StatefulWidget {
  @override
  _PlaceSearchScreenState createState() => _PlaceSearchScreenState();
}

class _PlaceSearchScreenState extends State<PlaceSearchScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: "Search your location".tr(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0.sp),
              child: GooglePlaceAutoCompleteTextField(
                textEditingController: controller,
                googleAPIKey: "AIzaSyALZpIBW7NvdLPVAYaDRwBYfZUo9vregH0",
                inputDecoration: InputDecoration(
                  hintText: "Search your location".tr(),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
                debounceTime: 400,
                // countries: const ["in", "fr"],
                isLatLngRequired: true,
                getPlaceDetailWithLatLng: (Prediction prediction) {},
                itemClick: (Prediction prediction) {
                  controller.text = prediction.description ?? "";
                  controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: prediction.description?.length ?? 0));
                  Navigator.pop(context, prediction.description);
                },
                seperatedBuilder: const Divider(),
                containerHorizontalPadding: 10,
                itemBuilder: (context, index, Prediction prediction) {
                  return Container(
                    padding: EdgeInsets.all(10.sp),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on),
                        SizedBox(
                          width: 7.sp,
                        ),
                        Expanded(child: Text(prediction.description ?? ""))
                      ],
                    ),
                  );
                },
                isCrossBtnShown: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
