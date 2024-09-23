import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:groupchat/component_library/dialogs/add_category_pdf_dialog.dart';
import 'package:groupchat/component_library/dialogs/custom_dialog.dart';
import 'package:groupchat/data/category_model.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/providers/categories_provider.dart';
import 'package:groupchat/repositories/categories_repository.dart';
import 'package:groupchat/views/categories_screens/pdf_view_screen.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/app_bars/custom_app_bar.dart';
import '../../component_library/text_widgets/extra_medium_text.dart';
import '../../component_library/text_widgets/small_light_text.dart';
import '../../core/app_colors.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';
import '../../core/utilities_class.dart';

class PdfListScreen extends StatefulWidget {
  static const route = 'PdfListScreen';

  @override
  State<StatefulWidget> createState() => _PdfListScreenState();
}

class _PdfListScreenState extends State<PdfListScreen> {
  String? type;
  bool? pageStarted = true;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments != null
        ? ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>
        : null;
    type ??= args!['type'] != null ? args['type'] : null;
    return Consumer(builder: (ctx, ref, child){
      var appUserPro = ref.watch(appUserProvider);
      return Scaffold(
        floatingActionButton: appUserPro.currentUser?.admin==true?FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            showDialog(context: context, builder: (context) => AddCategoryPdfDialog(
              type: type,
            ));
          },
          child: Icon(
            Icons.add,
            color: AppColors.lightBlack,
          ),
        ):Container(),
        body: SafeArea(
          child: Consumer(
            builder: (ctx, ref, child) {
              var categoriesPro = ref.watch(categoriesProvider);
              var appUserPro = ref.watch(appUserProvider);
              if(pageStarted == true){
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if(appUserPro.currentUser?.admin == true){
                    categoriesPro.clearPro();
                    categoriesPro.listenToAllCategoriesForAdmin(type??'');
                  }else{
                    categoriesPro.listenToCategories(
                        type ?? '', appUserPro.currentUser?.selectedCountry ?? '');
                  }
                  pageStarted = false;
                });
              }
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
                        ))
                        : Expanded(
                      child: ListView.builder(
                          itemCount:
                          categoriesPro.filteredCategoriesList?.length,
                          shrinkWrap: true,
                          padding:
                          EdgeInsets.only(left: 13.0.sp, right: 13.0.sp, bottom: 50.sp),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
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
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        Images.filePdfIcon,
                                        height: 23.sp,
                                        width: 23.sp,
                                        color: AppColors.lightBlack,
                                      ),
                                      SizedBox(
                                        width: 6.0.sp,
                                      ),
                                      Expanded(
                                        child: ExtraMediumText(
                                          textColor: AppColors.lightBlack,
                                          title: categoriesPro
                                              .filteredCategoriesList?[
                                          index]
                                              .name,
                                        ),
                                      ),
                                      appUserPro.currentUser?.admin==true?PopupMenuButton<int>(
                                        onSelected: (value){
                                          if (value == 0) {
                                            showEditDialog(categoriesPro
                                                .filteredCategoriesList![
                                            index]);
                                          } else if (value == 1) {
                                            showDeleteItemDialog(categoriesPro
                                                .filteredCategoriesList![
                                            index].categoryId);
                                          }
                                        },
                                        itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<int>>[
                                          PopupMenuItem<int>(
                                            value: 0,
                                            child: ListTile(
                                              leading: const Icon(Icons.edit),
                                              title: SmallLightText(title: 'Edit'.tr()),
                                            ),
                                          ),
                                          PopupMenuItem<int>(
                                            value: 1,
                                            child: ListTile(
                                              leading: const Icon(Icons.delete),
                                              title: SmallLightText(title: 'Delete'.tr()),
                                            ),
                                          ),
                                        ],
                                        icon: const Icon(Icons.more_vert),
                                      ):Container()
                                    ],
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
    });
  }

  showDeleteItemDialog(String? id){
    showDialog(context: context, builder: (ctx)=> CustomDialog(
      title2: "Are you sure you want to delete this category ?".tr(),
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
        CategoriesRepository().deleteCategories(context, id??'',
            onComplete: (){
              Utilities().showCustomToast(isError: false, message: 'Deleted'.tr());
              Navigator.pop(context);
            },
            onError: (p0){
              Utilities().showCustomToast(isError: true, message: p0.toString());
            });
      },
    ));
  }

  showEditDialog(CategoryModel categoryModel){
    showDialog(context: context, builder: (context)=> AddCategoryPdfDialog(
      type: type,
      categoryModel: categoryModel,
      isEdit: true,
    ));
  }
}
