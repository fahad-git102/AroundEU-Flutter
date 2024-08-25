import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:groupchat/component_library/buttons/button.dart';
import 'package:groupchat/component_library/drawers/admin_home_drawer.dart';
import 'package:groupchat/component_library/drop_downs/countries_dropdown.dart';
import 'package:groupchat/component_library/loaders/full_screen_loader.dart';
import 'package:groupchat/component_library/text_fields/white_back_textfield.dart';
import 'package:groupchat/component_library/text_widgets/extra_large_medium_bold_text.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/data/company_model.dart';
import 'package:groupchat/data/country_model.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/providers/companies_provider.dart';
import 'package:groupchat/repositories/companies_repository.dart';
import 'package:groupchat/views/companies_screens/companies_screen.dart';
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
  bool? isEdit = false;
  CompanyModel? companyToEdit;

  updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final args = ModalRoute.of(context)!.settings.arguments != null
        ? ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>
        : null;
    if (args != null) {
      companyToEdit ??= args['company'] != null
          ? CompanyModel.fromMap(args['company'])
          : null;
      isEdit = args['edit'] != null ? args['edit'] as bool : false;
      if (companyToEdit != null && isEdit == true) {
        fullNameController?.text = companyToEdit?.fullLegalName ?? '';
        legalAddressController?.text = companyToEdit?.legalAddress ?? '';
        postalCodeController?.text = companyToEdit?.poastalCode ?? '';
        cityController?.text = companyToEdit?.city ?? '';
        countryController?.text = companyToEdit?.country ?? '';
        phoneController?.text = companyToEdit?.telephone ?? '';
        emailController?.text = companyToEdit?.email ?? '';
        contactPersonController?.text = companyToEdit?.contactPerson ?? '';
        websiteController?.text = companyToEdit?.website ?? '';
        companyDescriptionController?.text =
            companyToEdit?.companyDescription ?? '';
        companyResponsibilityController?.text =
            companyToEdit?.companyResponsibility ?? '';
        tasksOfStudentsController?.text = companyToEdit?.taskOfStudents ?? '';
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(child: Consumer(builder: (ctx, ref, child) {
        var appUserPro = ref.watch(appUserProvider);
        appUserPro.listenToCountries();
        if (isEdit == true &&
            companyToEdit != null &&
            selectedCountry == null &&
            companyToEdit?.selectedCountry != null) {
          for (CountryModel element in appUserPro.countriesList ?? []) {
            if (companyToEdit?.selectedCountry == element.countryName) {
              selectedCountry = element;
            }
          }
        }
        return Stack(
          children: [
            Container(
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenWidth,
              padding:
                  EdgeInsets.only(top: 15.0.sp, left: 13.0.sp, right: 13.0.sp),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Images.mainBackground),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 7.sp,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(
                            Images.backIcon,
                            height: 30.sp,
                            width: 30.sp,
                          )),
                      isEdit == false
                          ? InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, CompaniesScreen.route);
                              },
                              child: Padding(
                                padding: EdgeInsets.all(3.0.sp),
                                child: ExtraMediumText(
                                  title: 'All Companies'.tr(),
                                  textColor: AppColors.lightBlack,
                                ),
                              ),
                            )
                          : Container()
                    ],
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
                              title: isEdit==true?'Edit Company'.tr():'Add new Company'.tr(),
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
                            textColor: AppColors.lightBlack,
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
                            textColor: AppColors.lightBlack,
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
                            textColor: AppColors.lightBlack,
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
                            textColor: AppColors.lightBlack,
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
                            textColor: AppColors.lightBlack,
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
                            textColor: AppColors.lightBlack,
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
                            textColor: AppColors.lightBlack,
                          ),
                          WhiteBackTextField(
                            controller: emailController,
                          ),
                          SizedBox(
                            height: 6.0.sp,
                          ),
                          SmallLightText(
                            title: 'Contact Person'.tr(),
                            textColor: AppColors.lightBlack,
                          ),
                          WhiteBackTextField(
                            controller: contactPersonController,
                          ),
                          SizedBox(
                            height: 6.0.sp,
                          ),
                          SmallLightText(
                            title: 'Website'.tr(),
                            textColor: AppColors.lightBlack,
                          ),
                          WhiteBackTextField(
                            controller: websiteController,
                          ),
                          SizedBox(
                            height: 6.0.sp,
                          ),
                          SmallLightText(
                            title: 'Company Description'.tr(),
                            textColor: AppColors.lightBlack,
                          ),
                          WhiteBackTextField(
                            controller: companyDescriptionController,
                            maxLines: 4,
                          ),
                          SizedBox(
                            height: 6.0.sp,
                          ),
                          SmallLightText(
                            title: 'Company\'s Responsibility'.tr(),
                            textColor: AppColors.lightBlack,
                          ),
                          WhiteBackTextField(
                            controller: companyResponsibilityController,
                            maxLines: 4,
                          ),
                          SizedBox(
                            height: 6.0.sp,
                          ),
                          SmallLightText(
                            title: 'Tasks of Students'.tr(),
                            textColor: AppColors.lightBlack,
                          ),
                          WhiteBackTextField(
                            controller: tasksOfStudentsController,
                            maxLines: 4,
                          ),
                          SizedBox(
                            height: 15.sp,
                          ),
                          Consumer(builder: (ctx, ref, child) {
                            var appUserPro = ref.watch(appUserProvider);
                            return Button(
                                text: isEdit == true
                                    ? 'Update'.tr()
                                    : 'Save'.tr(),
                                tapAction: () {
                                  selectedCountry ??=
                                      appUserPro.countriesList?[0];
                                  if (_formKey.currentState!.validate()) {
                                    isEdit == true
                                        ? editCompany(ref)
                                        : saveNewCompany();
                                  }
                                });
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
            FullScreenLoader(
              loading: isLoading,
            )
          ],
        );
      })),
    );
  }

  editCompany(WidgetRef ref) {
    var companiesPro = ref.watch(companiesProvider);
    var appUserPro = ref.watch(appUserProvider);
    isLoading = true;
    updateState();
    companyToEdit?.city = cityController?.text;
    companyToEdit?.companyDescription = companyDescriptionController?.text;
    companyToEdit?.companyResponsibility =
        companyResponsibilityController?.text;
    companyToEdit?.contactPerson = contactPersonController?.text;
    companyToEdit?.country = countryController?.text;
    companyToEdit?.email = emailController?.text;
    companyToEdit?.fullLegalName = fullNameController?.text;
    companyToEdit?.legalAddress = legalAddressController?.text;
    companyToEdit?.poastalCode = postalCodeController?.text;
    companyToEdit?.selectedCountry = selectedCountry?.countryName;
    companyToEdit?.taskOfStudents = tasksOfStudentsController?.text;
    companyToEdit?.telephone = phoneController?.text;
    companyToEdit?.website = websiteController?.text;
    CompanyRepository().updateCompany(companyToEdit!, context, () {
      isLoading = false;
      updateState();
      Utilities().showSuccessDialog(context,
          message: "Company data updated successfully".tr(),
          barrierDismissle: false, onBtnTap: () {
        companiesPro.resetSelectedCountry(appUserPro.countriesList![0]);
        Navigator.pop(context);
        Navigator.pop(context);
        clearControllers();
      });
    }, (p0) {
      isLoading = false;
      updateState();
      Utilities().showErrorMessage(context, message: "Error: ${p0.toString()}");
    });
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
