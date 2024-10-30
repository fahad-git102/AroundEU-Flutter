import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:groupchat/component_library/buttons/button.dart';
import 'package:groupchat/component_library/drop_downs/countries_dropdown.dart';
import 'package:groupchat/component_library/text_fields/white_back_textfield.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/data/category_model.dart';
import 'package:groupchat/data/country_model.dart';
import 'package:groupchat/repositories/categories_repository.dart';
import 'package:sizer/sizer.dart';

import '../../core/validation.dart';
import '../../firebase/firebase_crud.dart';
import '../../providers/app_user_provider.dart';

class AddCategoryPdfDialog extends StatefulWidget {
  String? type;
  CategoryModel? categoryModel;
  bool? isEdit;

  @override
  State<StatefulWidget> createState() => _AddCategoryPdfDialogState();

  AddCategoryPdfDialog({this.type, this.categoryModel, this.isEdit = false});
}

class _AddCategoryPdfDialogState extends State<AddCategoryPdfDialog> {
  TextEditingController nameController = TextEditingController();
  CountryModel? selectedCountry;
  bool? isLoading = false;
  bool? pageStarted = true;
  String? filePath;

  File? pickedFile;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        pickedFile = File(result.files.single.path!);
      });
    } else {
      print("No file selected.");
    }
  }

  updateState() {
    setState(() {});
  }

  String getFileNameFromUrl(String url) {
    Uri uri = Uri.parse(url);
    return uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (ctx, ref, child) {
      var appUserPro = ref.watch(appUserProvider);
      appUserPro.listenToCountries();
      if (pageStarted == true) {
        if (widget.isEdit == true && widget.categoryModel != null) {
          nameController.text = widget.categoryModel!.name ?? '';
          selectedCountry = appUserPro.countriesList?.firstWhere((element) =>
              element.countryName == widget.categoryModel?.country);
          filePath = getFileNameFromUrl(widget.categoryModel?.fileUrl ?? '');
        }
        pageStarted = false;
      }
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          padding: EdgeInsets.all(13.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExtraMediumText(
                title: widget.isEdit == true && widget.categoryModel != null
                    ? 'Edit File'.tr()
                    : 'Add new File'.tr(),
                textColor: AppColors.lightBlack,
              ),
              SizedBox(
                height: 15.sp,
              ),
              WhiteBackTextField(
                controller: nameController,
                hintText: 'Name'.tr(),
                validator: (value) {
                  return Validation()
                      .validateEmptyField(value, message: 'Name required'.tr());
                },
              ),
              SizedBox(
                height: 8.sp,
              ),
              Consumer(builder: (ctx, ref, child) {
                var appUserPro = ref.watch(appUserProvider);
                appUserPro.listenToCountries();
                selectedCountry ??= appUserPro.countriesList?[0];
                return CountriesDropDown(
                  selectedCountry: selectedCountry,
                  onChanged: (newValue) {
                    selectedCountry = newValue;
                    updateState();
                  },
                );
              }),
              SizedBox(
                height: 8.sp,
              ),
              InkWell(
                onTap: () {
                  pickPdfFile();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 7.0.sp, horizontal: 10.0.sp),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: AppColors.lightFadedTextColor, width: 0.4.sp),
                      borderRadius: BorderRadius.all(Radius.circular(4.sp))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.picture_as_pdf_outlined,
                        color: AppColors.lightFadedTextColor,
                        size: 15.sp,
                      ),
                      SizedBox(
                        width: 10.sp,
                      ),
                      Expanded(
                        child: SmallLightText(
                          title: pickedFile != null
                              ? pickedFile?.path
                              : filePath ?? 'Pick file'.tr(),
                          textColor: AppColors.lightFadedTextColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15.sp,
              ),
              isLoading == true
                  ? Center(
                      child: SpinKitPulse(
                        color: AppColors.mainColorDark,
                      ),
                    )
                  : Button(
                      text: 'Save'.tr(),
                      tapAction: () {
                        if(widget.isEdit == true && widget.categoryModel != null){
                          if(nameController.text.isEmpty == true ||
                              selectedCountry == null){
                            Utilities().showErrorMessage(context,
                                message: 'All fields required'.tr());
                          }else{
                            updateCategory();
                          }
                        }else if (nameController.text.isEmpty == true ||
                            selectedCountry == null ||
                            pickedFile == null) {
                          Utilities().showErrorMessage(context,
                              message: 'All fields required'.tr());
                        } else {
                          saveCategories();
                        }
                      })
            ],
          ),
        ),
      );
    });
  }

  updateCategory() async {
    isLoading = true;
    updateState();
    widget.categoryModel?.name = nameController.text;
    widget.categoryModel?.country = selectedCountry?.countryName;
    if (pickedFile != null) {
      String? fileUrl = await FirebaseCrud()
          .uploadImage(context: context, file: File(pickedFile!.path));
      widget.categoryModel?.fileUrl = fileUrl;
    }
    CategoriesRepository().updateCategory(widget.categoryModel!, context, (){
      isLoading = false;
      updateState();
      Navigator.pop(context);
    }, (p0){
      isLoading = false;
      updateState();
      Utilities().showErrorMessage(context, message: 'Error: ${p0.toString()}');
    });
  }

  saveCategories() async {
    isLoading = true;
    updateState();
    CategoryModel categoryModel = CategoryModel(
        name: nameController.text,
        country: selectedCountry?.countryName,
        category: widget.type,
        timeStamp: DateTime.now().millisecondsSinceEpoch);
    if (pickedFile != null) {
      String? fileUrl = await FirebaseCrud()
          .uploadImage(context: context, file: File(pickedFile!.path));
      categoryModel.fileUrl = fileUrl;
    }
    CategoriesRepository().addCategory(categoryModel, context, () {
      isLoading = false;
      updateState();
      Navigator.pop(context);
    }, (p0) {
      isLoading = false;
      updateState();
      Utilities().showErrorMessage(context, message: 'Error: ${p0.toString()}');
    });
  }
}
