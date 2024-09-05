import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/app_bars/custom_app_bar.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/providers/categories_provider.dart';
import 'package:groupchat/views/categories_screens/pdf_list_screen.dart';
import 'package:sizer/sizer.dart';

import '../../core/assets_names.dart';
import '../../core/size_config.dart';

class CategoriesScreen extends StatelessWidget {
  static const route = 'CategoriesScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer(
          builder: (ctx, ref, child) {
            var categoriesPro = ref.watch(categoriesProvider);
            var appUserPro = ref.watch(appUserProvider);
            categoriesPro.getCategoriesList();

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
                    title: 'Categories'.tr(),
                  ),
                  SizedBox(
                    height: 14.0.sp,
                  ),
                  ListView.builder(
                      itemCount: categoriesPro.categoriesTitles?.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, PdfListScreen.route, arguments: {
                              'type': categoriesPro.categoriesTitles?[index]
                            });
                          },
                          child: Container(
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
                            child: Padding(
                              padding: EdgeInsets.all(10.0.sp),
                              child: ExtraMediumText(
                                textColor: AppColors.lightBlack,
                                title: categoriesPro.categoriesTitles?[index],
                              ),
                            ),
                          ),
                        );
                      })
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
