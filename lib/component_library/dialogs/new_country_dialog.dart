import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupchat/component_library/text_fields/custom_text_field.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/data/country_model.dart';
import 'package:groupchat/repositories/users_repository.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';
import '../../core/validation.dart';
import '../buttons/button.dart';
import '../text_fields/white_back_textfield.dart';
import '../text_widgets/extra_large_medium_bold_text.dart';

class NewCountryDialog extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _NewCountryDialogState();
}

class _NewCountryDialogState extends State<NewCountryDialog>{
  TextEditingController nameController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: EdgeInsets.all(13.sp),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExtraLargeMediumBoldText(
                title: "New Country".tr(),
                textColor: AppColors.lightBlack,
              ),
              SizedBox(height: 10.0.sp,),
              CustomTextField(
                  controller: nameController,
                labelText: 'Country name'.tr(),
                validator: (value) {
                  return Validation().validateEmptyField(value,
                      message: 'Name required'.tr());
                },
              ),
              SizedBox(height: 10.sp,),
              CustomTextField(
                  controller: pinController,
                maxLength: 5,
                labelText: 'Pincode'.tr(),
                allowNumbersOnly: true,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]')),
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  return Validation().validateEmptyField(value,
                      message: 'Pincode required'.tr());
                },
              ),
              SizedBox(height: 10.sp,),
              Button(text: 'Save'.tr(), tapAction: (){
                if(_formKey.currentState!.validate()){
                  saveCountry();
                }
              }),
              SizedBox(height: 5.sp,)
            ],
          ),
        ),
      ),
    );
  }

  saveCountry(){
    CountryModel? country = CountryModel(
      countryName: nameController.text,
      pincode: pinController.text
    );
    UsersRepository().addCountry(country, context, (){
      Utilities().showCustomToast(message: 'Country saved'.tr(), isError: false);
      Navigator.pop(context);
    }, (p0){
      Utilities().showCustomToast(message: 'Error: ${p0.toString()}', isError: true);
    });
  }

}