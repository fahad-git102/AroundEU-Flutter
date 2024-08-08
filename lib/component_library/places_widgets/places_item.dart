import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:sizer/sizer.dart';

import '../../core/assets_names.dart';

class PlacesWidget extends StatelessWidget {
  final String? imageUrl;
  final String? createdBy;
  final String? category;
  final String? description;

  const PlacesWidget(
      {super.key,
      this.imageUrl,
      this.createdBy,
      this.category,
      this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 9.0.sp),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black87.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(1, 1), // Shadow position
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(4.sp))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 8.0.sp,
          ),
          CachedNetworkImage(
            imageUrl: imageUrl ?? '',
            imageBuilder: (context, imageProvider) => Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(3.sp)),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(
              child: Center(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.sp),
                child: SizedBox(
                  height: 12.0.sp,
                  width: 12.0.sp,
                  child: const CircularProgressIndicator(),
                ),
              )),
            ),
            errorWidget: (context, url, error) => Center(
              child: Image.asset(
                Images.noImagePlaceHolder,
                height: 45.sp,
                width: 45.sp,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding:
                  EdgeInsets.symmetric(vertical: 6.0.sp, horizontal: 10.0.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SmallLightText(
                          title: createdBy ?? '',
                          textColor: AppColors.fadedTextColor2,
                        ),
                      ),
                      SmallLightText(
                        title: category ?? '',
                        textColor: AppColors.fadedTextColor2,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3.0.sp,
                  ),
                  SmallLightText(
                    title: description ?? '',
                    maxLines: 2,
                    fontSize: 12.0.sp,
                    overflow: TextOverflow.ellipsis,
                    textColor: AppColors.lightBlack,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
