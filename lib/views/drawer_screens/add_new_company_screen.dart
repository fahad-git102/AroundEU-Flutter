import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/buttons/button.dart';
import 'package:groupchat/component_library/drawers/admin_home_drawer.dart';
import 'package:groupchat/component_library/drop_downs/countries_dropdown.dart';
import 'package:groupchat/component_library/loaders/full_screen_loader.dart';
import 'package:groupchat/component_library/text_fields/white_back_textfield.dart';
import 'package:groupchat/component_library/text_widgets/extra_large_medium_bold_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/data/company_model.dart';
import 'package:groupchat/data/country_model.dart';
import 'package:groupchat/providers/companies_provider.dart';
import 'package:groupchat/repositories/companies_repository.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/buttons/custom_icon_button.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';
import '../../core/validation.dart';

class AddNewCompanyScreen extends StatefulWidget {
  static const route = 'AddNewCompanyScreen';

  @override
  State<StatefulWidget> createState() => _AddNewCompanyScreenState();
}

class _AddNewCompanyScreenState extends State<AddNewCompanyScreen> {
  final GlobalKey<ScaffoldState> _companyKey = GlobalKey<ScaffoldState>();
  CountryModel? selectedCountry;

  TextEditingController? fullNameController = TextEditingController();
  TextEditingController? legalAddressController = TextEditingController();
  TextEditingController? postalCodeController = TextEditingController();
  TextEditingController? cityController = TextEditingController();
  TextEditingController? countryController = TextEditingController();
  TextEditingController? phoneController = TextEditingController();
  TextEditingController? emailController = TextEditingController();
  TextEditingController? contactPersonController = TextEditingController();
  TextEditingController? websiteController = TextEditingController();
  TextEditingController? companyDescriptionController = TextEditingController();
  TextEditingController? companyResponsibilityController =
      TextEditingController();
  TextEditingController? tasksOfStudentsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool? isLoading = false;

  updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _companyKey,
      resizeToAvoidBottomInset: false,
      drawer: AdminHomeDrawer(),
      body: SafeArea(child: Consumer(builder: (ctx, ref, child) {
        return Stack(
          children: [
            Container(
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenWidth,
              padding: EdgeInsets.only(top: 15.0.sp, left: 13.0.sp, right: 13.0.sp),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Images.mainBackground),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: CustomIconPngButton(
                      icon: Images.menuIcon,
                      size: 36.0.sp,
                      onTap: () {
                        _companyKey.currentState!.openDrawer();
                      },
                    ),
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 18.0.sp,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: ExtraLargeMediumBoldText(
                                  title: 'Add new Company'.tr(),
                                  textColor: AppColors.lightBlack,
                                ),
                              ),
                              SizedBox(
                                height: 13.0.sp,
                              ),
                              CountriesDropDown(
                                selectedCountry: selectedCountry,
                                onChanged: (newValue) {
                                  selectedCountry = newValue;
                                  updateState();
                                },
                              ),
                              SizedBox(
                                height: 15.0.sp,
                              ),
                              SmallLightText(
                                title: 'Full Legal Name'.tr(),
                                textColor: AppColors.fadedTextColor,
                              ),
                              WhiteBackTextField(
                                controller: fullNameController,
                                validator: (value) {
                                  return Validation().validateEmptyField(value,
                                      message: 'Field required'.tr());
                                },
                              ),
                              SizedBox(
                                height: 6.0.sp,
                              ),
                              SmallLightText(
                                title: 'Legal Address'.tr(),
                                textColor: AppColors.fadedTextColor,
                              ),
                              WhiteBackTextField(
                                controller: legalAddressController,
                                validator: (value) {
                                  return Validation().validateEmptyField(value,
                                      message: 'Field required'.tr());
                                },
                              ),
                              SizedBox(
                                height: 6.0.sp,
                              ),
                              SmallLightText(
                                title: 'Postal Code'.tr(),
                                textColor: AppColors.fadedTextColor,
                              ),
                              WhiteBackTextField(
                                controller: postalCodeController,
                                validator: (value) {
                                  return Validation().validateEmptyField(value,
                                      message: 'Field required'.tr());
                                },
                              ),
                              SizedBox(
                                height: 6.0.sp,
                              ),
                              SmallLightText(
                                title: 'City'.tr(),
                                textColor: AppColors.fadedTextColor,
                              ),
                              WhiteBackTextField(
                                controller: cityController,
                                validator: (value) {
                                  return Validation().validateEmptyField(value,
                                      message: 'Field required'.tr());
                                },
                              ),
                              SizedBox(
                                height: 6.0.sp,
                              ),
                              SmallLightText(
                                title: 'Country'.tr(),
                                textColor: AppColors.fadedTextColor,
                              ),
                              WhiteBackTextField(
                                controller: countryController,
                                validator: (value) {
                                  return Validation().validateEmptyField(value,
                                      message: 'Field required'.tr());
                                },
                              ),
                              SizedBox(
                                height: 6.0.sp,
                              ),
                              SmallLightText(
                                title: 'Phone'.tr(),
                                textColor: AppColors.fadedTextColor,
                              ),
                              WhiteBackTextField(
                                controller: phoneController,
                                validator: (value) {
                                  return Validation().validateEmptyField(value,
                                      message: 'Field required'.tr());
                                },
                              ),
                              SizedBox(
                                height: 6.0.sp,
                              ),
                              SmallLightText(
                                title: 'Email'.tr(),
                                textColor: AppColors.fadedTextColor,
                              ),
                              WhiteBackTextField(
                                controller: emailController,
                                validator: (value) {
                                  return Validation().validateEmptyField(value,
                                      message: 'Field required'.tr());
                                },
                              ),
                              SizedBox(
                                height: 6.0.sp,
                              ),
                              SmallLightText(
                                title: 'Contact Person'.tr(),
                                textColor: AppColors.fadedTextColor,
                              ),
                              WhiteBackTextField(
                                controller: contactPersonController,
                                validator: (value) {
                                  return Validation().validateEmptyField(value,
                                      message: 'Field required'.tr());
                                },
                              ),
                              SizedBox(
                                height: 6.0.sp,
                              ),
                              SmallLightText(
                                title: 'Website'.tr(),
                                textColor: AppColors.fadedTextColor,
                              ),
                              WhiteBackTextField(
                                controller: websiteController,
                              ),
                              SizedBox(
                                height: 6.0.sp,
                              ),
                              SmallLightText(
                                title: 'Company Description'.tr(),
                                textColor: AppColors.fadedTextColor,
                              ),
                              WhiteBackTextField(
                                controller: companyDescriptionController,
                                maxLines: 4,
                                validator: (value) {
                                  return Validation().validateEmptyField(value,
                                      message: 'Field required'.tr());
                                },
                              ),
                              SizedBox(
                                height: 6.0.sp,
                              ),
                              SmallLightText(
                                title: 'Company\'s Responsibility'.tr(),
                                textColor: AppColors.fadedTextColor,
                              ),
                              WhiteBackTextField(
                                controller: companyResponsibilityController,
                                validator: (value) {
                                  return Validation().validateEmptyField(value,
                                      message: 'Field required'.tr());
                                },
                                maxLines: 4,
                              ),
                              SizedBox(
                                height: 6.0.sp,
                              ),
                              SmallLightText(
                                title: 'Tasks of Students'.tr(),
                                textColor: AppColors.fadedTextColor,
                              ),
                              WhiteBackTextField(
                                controller: tasksOfStudentsController,
                                maxLines: 4,
                                validator: (value) {
                                  return Validation().validateEmptyField(value,
                                      message: 'Field required'.tr());
                                },
                              ),
                              SizedBox(
                                height: 15.sp,
                              ),
                              Button(
                                  text: 'Save'.tr(),
                                  tapAction: () {
                                    if (_formKey.currentState!.validate()) {
                                      saveNewCompany();
                                    }
                                  }),
                              SizedBox(
                                height: 300.0.sp,
                              )
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
            FullScreenLoader(loading: isLoading,)
          ],
        );
      })),
    );
  }

  saveNewCompany() {
    isLoading = true;
    updateState();
    CompanyModel companyModel = CompanyModel(
        city: cityController?.text,
        companyDescription: companyDescriptionController?.text,
        companyResponsibility: companyResponsibilityController?.text,
        contactPerson: contactPersonController?.text,
        country: countryController?.text,
        email: emailController?.text,
        fullLegalName: fullNameController?.text,
        legalAddress: legalAddressController?.text,
        poastalCode: postalCodeController?.text,
        selectedCountry: selectedCountry?.countryName,
        taskOfStudents: tasksOfStudentsController?.text,
        telephone: phoneController?.text,
        website: websiteController?.text);
    CompanyRepository().addCompany(companyModel, context, () {
      isLoading = false;
      updateState();
      Utilities().showSuccessDialog(context,
          message: "Company data saved successfully".tr(),
          barrierDismissle: false, onBtnTap: () {
        Navigator.pop(context);
        clearControllers();
      });
    }, (p0) {
      isLoading = false;
      updateState();
      Utilities().showErrorMessage(context, message: "Error: ${p0.toString()}");
    });
  }

  clearControllers() {
    fullNameController?.clear();
    legalAddressController?.clear();
    postalCodeController?.clear();
    cityController?.clear();
    countryController?.clear();
    phoneController?.clear();
    emailController?.clear();
    contactPersonController?.clear();
    websiteController?.clear();
    companyDescriptionController?.clear();
    companyResponsibilityController?.clear();
    tasksOfStudentsController?.clear();
  }
}
