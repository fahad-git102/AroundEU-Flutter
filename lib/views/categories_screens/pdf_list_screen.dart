import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:groupchat/component_library/loaders/full_screen_loader.dart';
import 'package:groupchat/core/static_keys.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/providers/categories_provider.dart';
import 'package:groupchat/views/categories_screens/pdf_view_screen.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/app_bars/custom_app_bar.dart';
import '../../component_library/text_widgets/extra_medium_text.dart';
import '../../core/app_colors.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';

class PdfListScreen extends StatefulWidget {
  static const route = 'PdfListScreen';

  @override
  State<StatefulWidget> createState() => _PdfListScreenState();
}

class _PdfListScreenState extends State<PdfListScreen> {
  String? type;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments != null
        ? ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>
        : null;
    type ??= args!['type'] != null ? args['type'] : null;
    return Scaffold(
      body: SafeArea(
        child: Consumer(
          builder: (ctx, ref, child) {
            var categoriesPro = ref.watch(categoriesProvider);
            var appUserPro = ref.watch(appUserProvider);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              categoriesPro.listenToCategories(type ?? '', appUserPro.currentUser?.selectedCountry ?? '');
            });
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
                    title: type ?? '',
                  ),
                  SizedBox(
                    height: 14.0.sp,
                  ),
                  categoriesPro.filteredCategoriesList == null ||
                          categoriesPro.categoriesList == null
                      ? Expanded(
                        child: SizedBox(
                          height: SizeConfig.screenHeight,
                          width: SizeConfig.screenWidth,
                          child: Center(
                            child: SpinKitPulse(
                              color: AppColors.mainColorDark,
                            ),
                          ),
                        )
                      )
                      : Expanded(
                          child: ListView.builder(
                              itemCount:
                                  categoriesPro.filteredCategoriesList?.length,
                              shrinkWrap: true,
                              padding:
                                  EdgeInsets.symmetric(horizontal: 13.0.sp),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                // categoriesPro.filterCategories(type??'');
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PdfViewScreen(
                                                title: categoriesPro
                                                    .filteredCategoriesList?[
                                                        index]
                                                    .name,
                                                url: categoriesPro
                                                    .filteredCategoriesList?[
                                                        index]
                                                    .fileUrl,
                                              )),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 9.0.sp),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black87
                                                .withOpacity(0.25),
                                            blurRadius: 4,
                                            offset: const Offset(
                                                1, 1), // Shadow position
                                          ),
                                        ],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.sp))),
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0.sp),
                                      child: ExtraMediumText(
                                        textColor: AppColors.lightBlack,
                                        title: categoriesPro
                                            .filteredCategoriesList?[index]
                                            .name,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
