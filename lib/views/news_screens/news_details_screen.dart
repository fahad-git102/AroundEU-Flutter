import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../component_library/app_bars/custom_app_bar.dart';
import '../../component_library/text_widgets/extra_large_medium_bold_text.dart';
import '../../core/app_colors.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';
import '../../data/news_model.dart';

class NewsDetailsScreen extends StatefulWidget{
  static const route = 'NewsDetailScreen';
  @override
  State<StatefulWidget> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen>{
  NewsModel? newsModel;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final args = ModalRoute.of(context)!.settings.arguments != null
        ? ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>
        : null;
    newsModel ??= args!['news'] != null ? NewsModel.fromMap(args['news']) : null;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.mainBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: newsModel?.title??'Details'.tr(),
              ),
              Expanded(child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0.sp),
                      child: CachedNetworkImage(
                        imageUrl: newsModel?.imageUrl ?? '',
                        imageBuilder: (context, imageProvider) => Container(
                          width: SizeConfig.screenWidth,
                          height: 280.sp,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(7.sp)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black87.withOpacity(0.34),
                                blurRadius: 4,
                                offset: const Offset(2, 1), // Shadow position
                              ),
                            ],
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.sp),
                                child: SizedBox(
                                  height: 16.0.sp,
                                  width: 16.0.sp,
                                  child: const CircularProgressIndicator(),
                                ),
                              )),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: Image.asset(
                            Images.noImagePlaceHolder,
                            height: SizeConfig.screenWidth,
                            width: 120.sp,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.sp,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                      child: ExtraLargeMediumBoldText(
                        title: newsModel?.title,
                        textColor: AppColors.lightBlack,
                      ),
                    ),
                    SizedBox(
                      height: 10.0.sp,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                      child: Linkify(
                        onOpen: (link) async {
                          if (!await launchUrl(Uri.parse(link.url))) {
                            throw Exception('Could not launch ${link.url}');
                          }
                        },
                        textAlign: TextAlign.start,
                        text: newsModel?.description ?? '',
                        style: TextStyle(
                            color: AppColors.lightBlack, fontSize: 13.5.sp),
                        linkStyle: TextStyle(color: AppColors.hyperLinkColor),
                      ),
                    ),
                    SizedBox(
                      height: 10.0.sp,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                      child: SmallLightText(
                        title: Utilities().convertTimeStampToString(newsModel?.timeStamp??0, format: 'dd MMM, yyyy hh:mm aa'),
                        textColor: AppColors.fadedTextColor2,
                      ),
                    ),
                    SizedBox(height: 40.0.sp,)
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

}