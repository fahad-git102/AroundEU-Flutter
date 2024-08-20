import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/news_widgets/news_list_item.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/providers/news_provider.dart';
import 'package:groupchat/views/news_screens/news_details_screen.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/app_bars/custom_app_bar.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';

class NewsScreen extends StatefulWidget {
  static const route = 'NewsScreen';
  @override
  State<StatefulWidget> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Consumer(builder: (ctx, ref, child){
          var newsPro = ref.watch(newsProvider);
          var appUserPro = ref.watch(appUserProvider);
          newsPro.listenToNews(appUserPro.currentUser?.selectedCountry??'');
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
                  title: 'Latest News'.tr(),
                ),
                Expanded(child: ListView.builder(
                    itemCount: newsPro.newsList?.length??0,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 13.0.sp, right: 13.0.sp, bottom: 10.0.sp),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, NewsDetailsScreen.route, arguments: {
                            'news': newsPro.newsList?[index].toMap()
                          });
                        },
                        child: NewsListItem(
                          imageUrl: newsPro.newsList?[index].imageUrl,
                          title: newsPro.newsList?[index].title,
                          description: newsPro.newsList?[index].description,
                          dateTime: Utilities().convertTimeStampToString(newsPro.newsList?[index].timeStamp??0, format: 'dd MMM, yyyy hh:mm aa'),
                        ),
                      );
                    }))
              ],
            ),
          );
        },),
      ),
    );
  }
}
