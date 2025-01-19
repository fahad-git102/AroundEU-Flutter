import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/app_bars/custom_app_bar.dart';
import 'package:groupchat/component_library/dialogs/custom_dialog.dart';
import 'package:groupchat/component_library/text_widgets/extra_large_medium_bold_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/data/places_model.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/repositories/places_repository.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../component_library/buttons/button.dart';
import '../../component_library/dialogs/report_content_dialog.dart';
import '../../core/assets_names.dart';
import '../../core/map_utils.dart';
import '../../core/size_config.dart';

class PlacesDetailScreen extends StatefulWidget {
  static const route = 'PlacesDetailScreen';

  @override
  State<StatefulWidget> createState() => _PlacesDetailScreenState();
}

class _PlacesDetailScreenState extends State<PlacesDetailScreen> {
  EUPlace? place;

  updateState(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final args = ModalRoute.of(context)!.settings.arguments != null
        ? ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>
        : null;
    place ??= args!['place'] != null ? EUPlace.fromMap(args['place']) : null;
    return Scaffold(
      body: SafeArea(
          child: Consumer(builder: (ctx, ref, child){
            var appUserPro = ref.watch(appUserProvider);
            return Container(
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Images.mainBackground),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  CustomAppBar(
                    title: 'Details'.tr(),
                    trailingWidget: InkWell(onTap: (){
                      showReportDialog(context, place?.key??'');
                    },child: Icon(Icons.flag_outlined, color: AppColors.lightBlack, size: 17.sp,)),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0.sp),
                            child: CachedNetworkImage(
                              imageUrl: place?.imageUrl ?? '',
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
                              title: place?.creatorName,
                              textColor: AppColors.lightBlack,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: SmallLightText(
                              title: place?.category,
                              textColor: AppColors.fadedTextColor2,
                            ),
                          ),
                          SizedBox(
                            height: 13.sp,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: Linkify(
                              onOpen: (link) async {
                                if (!await launchUrl(Uri.parse(link.url))) {
                                  throw Exception('Could not launch ${link.url}');
                                }
                              },
                              textAlign: TextAlign.center,
                              text: place?.description ?? '',
                              style: TextStyle(
                                  color: AppColors.lightBlack, fontSize: 13.5.sp),
                              linkStyle: TextStyle(color: AppColors.hyperLinkColor),
                            ),
                          ),
                          SizedBox(
                            height: 15.0.sp,
                          ),
                          place?.location != null
                              ? InkWell(
                            onTap: () {
                              MapUtils.openMap(place?.location?.latitude ?? 0,
                                  place?.location?.longitude ?? 0);
                            },
                            child: Padding(
                              padding:
                              EdgeInsets.symmetric(horizontal: 13.0.sp),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    Images.markerIcon,
                                    height: 25.0.sp,
                                    width: 25.0.sp,
                                  ),
                                  SizedBox(
                                    width: 6.sp,
                                  ),
                                  Expanded(
                                    child: Text(
                                      place?.location?.address ?? '',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 11.0.sp,
                                          color: AppColors.lightBlack),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                              : Container(),
                          SizedBox(
                            height: 20.0.sp,
                          ),
                          appUserPro.currentUser?.admin==true &&
                              place?.status=='pending'?Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: Button(
                              text: 'Approve'.tr(),
                              btnColor: AppColors.mainColor,
                              btnTxtColor: AppColors.lightBlack,
                              tapAction: () {
                                approvePlace();
                              },
                            ),
                          ):Container(),
                          SizedBox(
                            height: 10.0.sp,
                          ),
                          appUserPro.currentUser?.admin==true &&
                              place?.status=='pending'?Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: Button(
                              text: 'Disapprove'.tr(),
                              btnColor: AppColors.red,
                              btnTxtColor: AppColors.white,
                              tapAction: () {
                                disapprovePlace();
                              },
                            ),
                          ): Container(),
                          SizedBox(
                            height: 10.0.sp,
                          ),
                          appUserPro.currentUser?.admin==true?Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: Button(
                              text: 'Delete'.tr(),
                              btnColor: AppColors.red,
                              btnTxtColor: AppColors.white,
                              tapAction: () {deletePlace();},
                            ),
                          ): Container(),
                          SizedBox(
                            height: 40.0.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },)),
    );
  }

  approvePlace(){
    Map<String, dynamic> map = {
      "status": "approved"
    };
    PlacesRepository().updatePlace(map, place?.key??'', context, (){
      Utilities().showCustomToast(isError: false, title: "Approved".tr(), message: '');
      place?.status = 'approved';
      updateState();
    }, (p0){
      Utilities().showCustomToast(isError: true, message: p0.toString());
    });
  }

  disapprovePlace(){
    Map<String, dynamic> map = {
      "status": "disapproved"
    };
    PlacesRepository().updatePlace(map, place?.key??'', context, (){
      Utilities().showCustomToast(isError: false, title: "Disapproved".tr(), message: '');
      place?.status = 'disapproved';
      updateState();
    }, (p0){
      Utilities().showCustomToast(isError: true, message: p0.toString());
    });
  }

  deletePlace(){
    showDialog(context: context, builder: (ctx)=> CustomDialog(
      title2: "Are you sure you want to delete this place ?",
      btn1Text: "Delete".tr(),
      btn2Text: "Cancel".tr(),
      iconColor: AppColors.red,
      icon: Images.deleteIcon,
      btn1Color: AppColors.red,
      btn1Outlined: true,
      onBtn2Tap: (){
        Navigator.pop(context);
      },
      onBtn1Tap: (){
        PlacesRepository().deletePlace(context, place!.key??'', (){
          Utilities().showCustomToast(isError: false, title: "Deleted".tr(), message: '');
          Navigator.pop(context);
          Navigator.pop(context);
        }, (p0){
          Utilities().showCustomToast(isError: true, message: p0.toString());
        });
      },
    ));
  }

  void showReportDialog(BuildContext context, String contentId) {
    showDialog(
      context: context,
      builder: (context) {
        return ReportContentDialog(contentId: contentId, contentType: 'place',);
      },
    );
  }

}
