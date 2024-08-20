import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:sizer/sizer.dart';

import '../../core/assets_names.dart';

class NewsListItem extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final String? description;
  final String? dateTime;

  const NewsListItem({super.key, this.imageUrl, this.title, this.description, this.dateTime});

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
          SizedBox(width: 5.0.sp,),
          CachedNetworkImage(
            imageUrl: imageUrl ?? '',
            imageBuilder: (context, imageProvider) => Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(3.sp)),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(
              child: Center(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 23.sp),
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
                height: 80.sp,
                width: 80.sp,
                fit: BoxFit.cover,
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
                    ExtraMediumText(
                      title: title,
                      textColor: AppColors.lightBlack,
                    ),
                    SizedBox(height: 3.0.sp,),
                    ExtraMediumText(
                      title: description,
                      textColor: AppColors.lightBlack,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      decrease: 2,
                    ),
                    SizedBox(height: 3.0.sp,),
                    SmallLightText(
                      title: dateTime,
                      textColor: AppColors.fadedTextColor,
                    )
                  ],
                ),
          ))
        ],
      ),
    );
  }
}
