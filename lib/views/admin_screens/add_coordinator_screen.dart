import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/component_library/buttons/button.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/data/coordinators_contact_model.dart';
import 'package:groupchat/firebase/firebase_crud.dart';
import 'package:groupchat/repositories/contacts_repository.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/buttons/back_button.dart';
import '../../component_library/text_fields/custom_text_field.dart';
import '../../component_library/text_widgets/extra_medium_text.dart';
import '../../core/app_colors.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';
import '../../core/static_keys.dart';
import '../../core/validation.dart';
import '../home_screens/contacts_info_screen.dart';

class AddCoordinatorsScreen extends StatefulWidget {
  static const route = 'AddCategoriesScreen';

  @override
  State<StatefulWidget> createState() => _AddCoordinatorsScreenState();
}

class _AddCoordinatorsScreenState extends State<AddCoordinatorsScreen> {
  TextEditingController detailsController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  String? selectedCountryCode;
  bool? isLoading = false;
  final _formKey = GlobalKey<FormState>();

  updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
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
            SizedBox(
              height: 18.0.sp,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackIconButton(
                    size: 24.0.sp,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, ContactsInfoScreen.route, arguments: {
                        'type': coordinators
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(3.sp),
                      child: ExtraMediumText(
                        title: 'View All'.tr(),
                        textColor: AppColors.lightBlack,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15.sp,
                      ),
                      Image.asset(
                        Images.logoAroundEU,
                        height: 110.0.sp,
                        width: 110.0.sp,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        height: 7.sp,
                      ),
                      ExtraMediumText(
                        textColor: AppColors.lightBlack,
                        title: 'Add new Coordinator'.tr(),
                      ),
                      SizedBox(
                        height: 25.sp,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                        child: CustomTextField(
                          controller: detailsController,
                          labelText: 'Details'.tr(),
                          validator: (value) {
                            return Validation().validateEmptyField(value,
                                message: 'Field required'.tr());
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13.sp),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CountryCodePicker(
                              onChanged: (countryCode) {
                                selectedCountryCode = countryCode.toString();
                              },
                              initialSelection: 'IT',
                              favorite: const ['+39', 'IT'],
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                            ),
                            Expanded(
                              child: CustomTextField(
                                controller: detailsController,
                                hintText: 'XXXXXXXXXX'.tr(),
                                validator: (value) {
                                  return Validation().validateEmptyField(value,
                                      message: 'Number required'.tr());
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25.sp,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13.sp),
                        child: Button(
                            text: 'Save'.tr(),
                            tapAction: () {
                              if (_formKey.currentState!.validate()) {
                                saveCoordinatorContact();
                              }
                            }),
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13.sp),
                        child: Button(text: 'View All Teachers'.tr(), tapAction: () {}),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  saveCoordinatorContact() {
    isLoading = true;
    updateState();
    CoordinatorsContact coordinatorsContact = CoordinatorsContact(
        text: detailsController.text,
        phone: '$selectedCountryCode${numberController.text}');
    ContactsRepository().addCoordinatorsContact(coordinatorsContact, context,
        () {
      isLoading = false;
      updateState();
      numberController.clear();
      detailsController.clear();
    }, (p0) {
      isLoading = false;
      updateState();
      Utilities().showErrorMessage(context, message: 'Error: ${p0.toString()}');
    });
  }
}
