import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/static_keys.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/providers/contacts_provider.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/app_bars/custom_app_bar.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';

class ContactsInfoScreen extends StatefulWidget {
  static const route = 'ContactsInfoScreen';

  @override
  State<StatefulWidget> createState() => _ContactsInfoScreenState();
}

class _ContactsInfoScreenState extends State<ContactsInfoScreen> {
  String? contactsType;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments != null
        ? ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>
        : null;
    contactsType = args!['type'] != null ? args['type'] as String : '';
    return Scaffold(
      body: SafeArea(child: Consumer(builder: (ctx, ref, child) {
        var contactsPro = ref.watch(contactsProvider);
        getData(contactsPro);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: contactsType == coordinators
                    ? 'Coordinators'.tr()
                    : contactsType == emergency
                        ? 'Emergency Contacts'.tr()
                        : contactsType == office
                            ? 'Office Contacts'.tr()
                            : '',
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      top: 10.sp,
                      left: 25.0.sp,
                      right: 25.0.sp,
                      bottom: 35.0.sp),
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
                  child: contactsType == coordinators
                      ? coordinatorsList(contactsPro)
                      : contactsType == emergency
                          ? emergencyContactsList(contactsPro)
                          : contactsType == office
                              ? officeWidget()
                              : Container(),
                ),
              )
            ],
          ),
        );
      })),
    );
  }

  Widget? coordinatorsList(ContactsProvider contactsPro) {
    return ListView.separated(
      itemCount: contactsPro.coordinatorsContactsList?.length ?? 0,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 13.0.sp, vertical: 10.0.sp),
      itemBuilder: (BuildContext context, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.0.sp,
            ),
            ExtraMediumText(
              title: contactsPro.coordinatorsContactsList?[index].text,
              textColor: AppColors.lightBlack,
            ),
            SizedBox(
              height: 4.0.sp,
            ),
            GestureDetector(
              onTap: () {
                Utilities().launchDialer(
                    contactsPro.coordinatorsContactsList?[index].phone ?? '');
              },
              child: Text(
                contactsPro.coordinatorsContactsList?[index].phone ?? '',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 11.0.sp,
                    color: AppColors.fadedTextColor),
              ),
            ),
            SizedBox(
              height: 10.0.sp,
            ),
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 0.5.sp,
          color: AppColors.fadedTextColor2,
        );
      },
    );
  }

  getData(ContactsProvider contactsPro) {
    if (contactsType == coordinators) {
      contactsPro.listenToCoordinators();
    } else if (contactsType == emergency) {
      contactsPro.listenToEmergencyContacts();
    }
  }

  Widget? emergencyContactsList(ContactsProvider contactsPro) {
    return ListView.builder(
        itemCount: contactsPro.emergencyContactsList?.length ?? 0,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 15.0.sp, vertical: 20.0.sp),
        itemBuilder: (BuildContext context, int index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ExtraMediumText(
                decrease: 2,
                textColor: AppColors.lightBlack,
                title: '${contactsPro.emergencyContactsList?[index].name} - ',
              ),
              GestureDetector(
                onTap: () {
                  Utilities().launchDialer(
                      contactsPro.emergencyContactsList?[index].number ?? '');
                },
                child: Text(
                  contactsPro.emergencyContactsList?[index].number ?? '',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 14.0.sp,
                      color: AppColors.hyperLinkColor),
                ),
              ),
            ],
          );
        });
  }

  Widget? officeWidget() {
    return Padding(
      padding: EdgeInsets.all(16.0.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.sp,),
          ExtraMediumText(
            title: 'Address:'.tr(),
            textColor: AppColors.lightBlack,
          ),
          SizedBox(height: 5.sp,),
          SmallLightText(
            fontSize: 12.sp,
            title: 'Via T.C.P Arcodaci 48- Barcellona Pozzo di Gotto (ME)- 98051 Italy\n\nVia Naumachia 6-8 - Catania- 95121 Italy'.tr(),
            textColor: AppColors.hyperLinkColor,
          ),
          SizedBox(height: 13.sp),
          ExtraMediumText(
            title: 'Tel:',
            textColor: AppColors.lightBlack,
          ),
          SizedBox(height: 5.sp),
          GestureDetector(
            onTap: () {
              Utilities().launchDialer('+39 0902130696');
            },
            child: Text(
              '+39 0902130696',
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 12.0.sp,
                  color: AppColors.hyperLinkColor),
            ),
          ),
          SizedBox(height: 13.sp),
          ExtraMediumText(
            title: 'Email:'.tr(),
            textColor: AppColors.lightBlack,
          ),
          SizedBox(height: 5.sp,),
          SmallLightText(
            fontSize: 12.sp,
            title: 'info@eprojectconsult.com',
            textColor: AppColors.hyperLinkColor,
          ),
          SizedBox(height: 13.sp),
          ExtraMediumText(
            title: 'WhatsApp no:'.tr(),
            textColor: AppColors.lightBlack,
          ),
          SizedBox(height: 5.sp,),
          SmallLightText(
            title: '+39 3899012051',
            fontSize: 12.sp,
            textColor: AppColors.hyperLinkColor,
          ),
          SizedBox(height: 15.sp),
          ExtraMediumText(
            title: 'Timings:'.tr(),
            textColor: AppColors.lightBlack,
          ),
          SizedBox(height: 5.sp,),
          SmallLightText(
            title: '9:30am - 1:00pm',
            fontSize: 12.sp,
            textColor: AppColors.hyperLinkColor,
          ),
          SmallLightText(
            title: '3:00pm - 6:00pm',
            fontSize: 12.sp,
            textColor: AppColors.hyperLinkColor,
          ),
        ],
      ),
    );
  }
}
