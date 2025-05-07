import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/buttons/tile_item.dart';
import 'package:groupchat/component_library/dialogs/sign_out_dialog.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/static_keys.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/firebase/fcm_service.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/providers/categories_provider.dart';
import 'package:groupchat/providers/companies_provider.dart';
import 'package:groupchat/providers/groups_provider.dart';
import 'package:groupchat/repositories/users_repository.dart';
import 'package:groupchat/views/auth/login_screen.dart';
import 'package:groupchat/views/home_screens/contacts_info_screen.dart';
import 'package:groupchat/views/home_screens/privacy_policy_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/assets_names.dart';
import '../../data/social_media_links.dart';
import '../../firebase/auth.dart';

class HomeDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {

  final List<SocialMediaLink> socialMediaLinks = [
    SocialMediaLink(
      name: 'Facebook',
      appUrl: 'fb://page/eprojectconsult',
      webUrl: 'https://www.facebook.com/eprojectconsult/',
    ),
    SocialMediaLink(
      name: 'Instagram',
      appUrl: 'instagram://user?username=eprojectconsult',
      webUrl: 'https://www.instagram.com/eprojectconsult/',
    ),
    SocialMediaLink(
      name: 'LinkedIn',
      appUrl: 'linkedin://company/eprojectconsult-office',
      webUrl: 'https://www.linkedin.com/company/eprojectconsult-office',
    ),
    SocialMediaLink(
      name: 'Twitter',
      appUrl: 'twitter://user?screen_name=EprojectConsult',
      webUrl: 'https://twitter.com/EprojectConsult',
    ),
    SocialMediaLink(
      name: 'YouTube',
      appUrl: 'youtube://user/eprojectconsult',
      webUrl: 'https://www.youtube.com/user/eprojectconsult/videos',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250.sp,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.darkWhite,
            ),
            child: Center(
              child: Image.asset(
                Images.logoAroundEU, // Replace with your image asset
                width: 120.0.sp,
                height: 120.0.sp,
              ),
            ),
          ),
          TileItem(
            icon: Images.globeIcon,
            title: 'Website'.tr(),
            onTap: () async {
              final Uri url = Uri.parse('https://eprojectconsult.com/');
              if (!await launchUrl(url)) {
                throw Exception('Could not launch $url');
              }
            },
          ),
          Container(
            height: 0.7.sp,
            color: AppColors.extraLightFadedTextColor,
          ),
          SizedBox(
            height: 13.0.sp,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0.sp),
            child: SmallLightText(
              title: 'Follow us on'.tr(),
              textColor: AppColors.lightFadedTextColor,
            ),
          ),
          SizedBox(
            height: 5.0.sp,
          ),
          TileItem(
            icon: Images.facebookMiniIcon,
            title: 'Facebook'.tr(),
            onTap: () async {
              _openSocialMediaLink(socialMediaLinks[0]);
            },
          ),
          TileItem(
            icon: Images.instagramMiniIcon,
            title: 'Instagram'.tr(),
            onTap: () async {
              _openSocialMediaLink(socialMediaLinks[1]);
            },
          ),
          TileItem(
            icon: Images.linkedinMiniIcon,
            title: 'LinkedIn'.tr(),
            onTap: () async{
              _openSocialMediaLink(socialMediaLinks[2]);
            },
          ),
          TileItem(
            icon: Images.twitterMiniIcon,
            title: 'Twitter/X'.tr(),
            onTap: () async{
              _openSocialMediaLink(socialMediaLinks[3]);
            },
          ),
          TileItem(
            icon: Images.youtubeMiniIcon,
            title: 'Youtube'.tr(),
            onTap: () async{
              _openSocialMediaLink(socialMediaLinks[4]);
            },
          ),
          SizedBox(
            height: 4.0.sp,
          ),
          Container(
            height: 0.7.sp,
            color: AppColors.extraLightFadedTextColor,
          ),
          SizedBox(
            height: 13.0.sp,
          ),
          TileItem(
            icon: Images.coordinatorsIcon,
            title: 'Coordinators contact'.tr(),
            onTap: () {
              Navigator.pushNamed(context, ContactsInfoScreen.route, arguments: {
                'type': coordinators
              });
            },
          ),
          TileItem(
            icon: Images.emergencyContactIcon,
            title: 'Emergency contact'.tr(),
            onTap: () {
              Navigator.pushNamed(context, ContactsInfoScreen.route, arguments: {
                'type': emergency
              });
            },
          ),
          TileItem(
            icon: Images.officeContactIcon,
            title: 'Office contact'.tr(),
            onTap: () {
              Navigator.pushNamed(context, ContactsInfoScreen.route, arguments: {
                'type': office
              });
            },
          ),
          TileItem(
            icon: Images.privacyPolicyIcon,
            title: 'Privacy Policy'.tr(),
            onTap: () {
              Navigator.pushNamed(context, PrivacyPolicyScreen.route);
            },
          ),
          TileItem(
            icon: Images.deleteIcon,
            title: 'Delete Account'.tr(),
            onTap: () {
              Utilities()
                  .showDeleteConfirmationDialog(context);
            },
          ),
          Consumer(builder: (ctx, ref, child) {
            var appUserPro = ref.watch(appUserProvider);
            var companyPro = ref.watch(companiesProvider);
            var groupsPro = ref.watch(groupsProvider);
            var categoriesPro = ref.watch(categoriesProvider);
            return TileItem(
              icon: Images.signOutIcon,
              title: 'Sign out'.tr(),
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (ctx) => SignOutDialog(
                          onLogout: () async {
                            appUserPro.clearPro();
                            categoriesPro.clearPro();
                            groupsPro.clearPro();
                            companyPro.clearPro();
                            await removeFcmToken();
                          },
                        ));
              },
            );
          }),
          SizedBox(
            height: 40.0.sp,
          ),
        ],
      ),
    );
  }

  Future<void> removeFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(fcmToken);
    print(token);
    UsersRepository().removeUserToken(token??'', (){
      Auth().signOut();
      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.route, (route) => false);
    }, (p0){
      Utilities().showCustomToast(message: p0, isError: true);
    });
  }

  void _openSocialMediaLink(SocialMediaLink link) async {
    Uri appUri = Uri.parse(link.appUrl??'');
    Uri webUri = Uri.parse(link.webUrl??'');

    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri);
    } else {
      await launchUrl(webUri);
    }
  }
}
