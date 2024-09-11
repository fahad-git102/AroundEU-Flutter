import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/news_widgets/news_list_item.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/providers/news_provider.dart';
import 'package:groupchat/views/admin_screens/add_news_screen.dart';
import 'package:groupchat/views/news_screens/news_details_screen.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/app_bars/custom_app_bar.dart';
import '../../component_library/dialogs/custom_dialog.dart';
import '../../core/app_colors.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';
import '../../data/news_model.dart';
import '../../repositories/news_repository.dart';

class AllNewsScreen extends StatefulWidget {
  static const route = 'AllNewsScreen';
  @override
  State<StatefulWidget> createState() => _AllNewsScreenState();
}

class _AllNewsScreenState extends State<AllNewsScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Consumer(builder: (ctx, ref, child){
          var newsPro = ref.watch(newsProvider);
          newsPro.listenToAllNews();
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
                  title: 'All news'.tr(),
                ),
                Expanded(child: ListView.builder(
                    itemCount: newsPro.allNewsList?.length??0,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 13.0.sp, right: 13.0.sp, bottom: 10.0.sp),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, NewsDetailsScreen.route, arguments: {
                            'news': newsPro.allNewsList?[index].toMap()
                          });
                        },
                        child: NewsListItem(
                          showMenu: true,
                          countryName: newsPro.allNewsList?[index].country,
                          onOptionSelected: (value){
                            if (value == 0) {
                              Navigator.pushNamed(context, AddNewsScreen.route, arguments: {
                                "news": newsPro.allNewsList?[index].toMap(),
                                "isEdit": true
                              });
                            } else if (value == 1) {
                              showDeleteNewsDialog(newsPro.allNewsList![index]);
                            }
                          },
                          imageUrl: newsPro.allNewsList?[index].imageUrl,
                          title: newsPro.allNewsList?[index].title,
                          description: newsPro.allNewsList?[index].description,
                          dateTime: Utilities().convertTimeStampToString(newsPro.allNewsList?[index].timeStamp??0, format: 'dd MMM, yyyy hh:mm aa'),
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
  showDeleteNewsDialog(NewsModel newsModel){
    showDialog(context: context, builder: (ctx)=> CustomDialog(
      title2: "Are you sure you want to delete this news ?".tr(),
      btn1Text:'Delete'.tr(),
      btn2Text: 'Cancel'.tr(),
      btn1Outlined: true,
      icon: Images.deleteIcon,
      iconColor: AppColors.red,
      btn1Color: AppColors.red,
      onBtn2Tap: (){
        Navigator.pop(context);
      },
      onBtn1Tap: (){
        NewsRepository().deleteNews(ctx,
            newsModel.id??'', onComplete: (){
              Utilities().showCustomToast(isError: false, message: 'Deleted'.tr());
              Navigator.pop(context);
            }, onError: (p0){
              Utilities().showCustomToast(isError: true, message: p0.toString());
              Navigator.pop(context);
            });
      },
    ));
  }
}
