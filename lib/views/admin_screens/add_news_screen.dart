import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/app_bars/custom_app_bar.dart';
import 'package:groupchat/component_library/buttons/button.dart';
import 'package:groupchat/component_library/drop_downs/countries_dropdown.dart';
import 'package:groupchat/component_library/image_widgets/pick_image_widget.dart';
import 'package:groupchat/component_library/loaders/full_screen_loader.dart';
import 'package:groupchat/component_library/text_fields/white_back_textfield.dart';
import 'package:groupchat/data/news_model.dart';
import 'package:groupchat/firebase/auth.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/repositories/news_repository.dart';
import 'package:groupchat/views/admin_screens/all_news_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/assets_names.dart';
import '../../core/size_config.dart';
import '../../core/utilities_class.dart';
import '../../core/validation.dart';
import '../../data/country_model.dart';
import '../../firebase/firebase_crud.dart';

class AddNewsScreen extends StatefulWidget {
  static const route = 'AddNewsScreen';

  @override
  State<StatefulWidget> createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends State<AddNewsScreen> {
  XFile? pickedFile;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  CountryModel? selectedCountry;
  bool? isLoading = false;
  bool? isEdit = false;
  final _formKey = GlobalKey<FormState>();
  NewsModel? newsToEdit;
  bool? pageStarted = true;

  updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final args = ModalRoute.of(context)!.settings.arguments != null
        ? ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>
        : null;
    if (args != null && pageStarted == true) {
      newsToEdit ??=
          args['news'] != null ? NewsModel.fromMap(args['news']) : null;
      isEdit = args['isEdit'] != null ? args['isEdit'] as bool : false;
      titleController.text = newsToEdit?.title ?? '';
      descriptionController.text = newsToEdit?.description ?? '';
      pageStarted = false;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Stack(
        children: [
          Container(
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
                  title: isEdit == true
                      ? "Edit News".tr() : "Add News".tr(),
                ),
                SizedBox(
                  height: 10.sp,
                ),
                Expanded(
                    child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PickImageWidget(
                          pickedFile: pickedFile,
                          imageAvailableUrl: isEdit != null &&
                                  newsToEdit?.imageUrl != null &&
                                  newsToEdit?.imageUrl?.isNotEmpty == true
                              ? newsToEdit?.imageUrl ?? ''
                              : null,
                          onTap: () {
                            Utilities().showImagePickerDialog(context,
                                onCameraTap: () async {
                              Navigator.of(context).pop();
                              pickedFile = await Utilities.pickImage(
                                  imageSource: 'camera');
                              updateState();
                            }, onGalleryTap: () async {
                              Navigator.of(context).pop();
                              pickedFile = await Utilities.pickImage(
                                  imageSource: 'gallery');
                              updateState();
                            });
                          },
                        ),
                        SizedBox(
                          height: 25.sp,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 13.sp),
                          child: WhiteBackTextField(
                            controller: titleController,
                            hintText: 'Title'.tr(),
                            validator: (value) {
                              return Validation().validateEmptyField(value,
                                  message: 'Title required'.tr());
                            },
                          ),
                        ),
                        SizedBox(
                          height: 8.sp,
                        ),
                        Consumer(builder: (ctx, ref, child) {
                          var appUserPro = ref.watch(appUserProvider);
                          appUserPro.listenToCountries();
                          selectedCountry ??= appUserPro.countriesList?[0];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.sp),
                            child: CountriesDropDown(
                              selectedCountry: selectedCountry,
                              onChanged: (newValue) {
                                selectedCountry = newValue;
                                updateState();
                              },
                            ),
                          );
                        }),
                        SizedBox(
                          height: 8.sp,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 13.sp),
                          child: WhiteBackTextField(
                            controller: descriptionController,
                            hintText: 'Description'.tr(),
                            maxLines: 4,
                            validator: (value) {
                              return Validation().validateEmptyField(value,
                                  message: 'Description required'.tr());
                            },
                          ),
                        ),
                        SizedBox(
                          height: 25.sp,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 13.sp),
                          child: Button(
                              text: "Save".tr(),
                              tapAction: () {
                                if (_formKey.currentState!.validate()) {
                                  if (selectedCountry != null) {
                                    if (isEdit==false&&pickedFile == null) {
                                      Utilities().showSnackbar(context,
                                          'Please pick an image first'.tr());
                                    } else {
                                      isEdit == true ? updateNews():saveNews();
                                    }
                                  } else {
                                    Utilities().showSnackbar(context,
                                        'Please select country first'.tr());
                                  }
                                }
                              }),
                        ),
                        SizedBox(
                          height: 10.sp,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 13.sp),
                          child: Button(
                              text: "View all news".tr(),
                              tapAction: () {
                                Navigator.pushNamed(
                                    context, AllNewsScreen.route);
                              }),
                        ),
                        SizedBox(
                          height: 150.sp,
                        )
                      ],
                    ),
                  ),
                ))
              ],
            ),
          ),
          FullScreenLoader(
            loading: isLoading,
          )
        ],
      )),
    );
  }

  updateNews() async {
    isLoading = true;
    updateState();
    newsToEdit?.description = descriptionController.text;
    newsToEdit?.title = titleController.text;
    newsToEdit?.country = selectedCountry?.countryName;
    if(pickedFile != null){
      String? imageUrl = await FirebaseCrud()
          .uploadImage(context: context, file: File(pickedFile!.path));
      newsToEdit?.imageUrl = imageUrl;
    }
    NewsRepository().updateNews(newsToEdit!, context, (){
      isLoading = false;
      updateState();
      Navigator.pop(context);
    }, (p0){
      isLoading = false;
      updateState();
      Utilities().showErrorMessage(context, message: 'Error: ${p0.toString()}');
    });
  }

  saveNews() async {
    isLoading = true;
    updateState();
    String? imageUrl = await FirebaseCrud()
        .uploadImage(context: context, file: File(pickedFile!.path));
    NewsModel newsModel = NewsModel(
        country: selectedCountry?.countryName,
        description: descriptionController.text,
        imageUrl: imageUrl,
        uid: Auth().currentUser?.uid,
        title: titleController.text,
        timeStamp: DateTime.now().millisecondsSinceEpoch);
    NewsRepository().addNews(newsModel, context, () {
      isLoading = false;
      updateState();
      Utilities().showSuccessDialog(context, message: 'Saved !'.tr(),
          onBtnTap: () {
        pickedFile = null;
        titleController.clear();
        descriptionController.clear();
        Navigator.pop(context);
        Navigator.pushNamed(context, AllNewsScreen.route);
      });
    }, (p0) {
      isLoading = false;
      updateState();
      Utilities().showErrorMessage(context, message: 'Error: ${p0.toString()}');
    });
  }
}
