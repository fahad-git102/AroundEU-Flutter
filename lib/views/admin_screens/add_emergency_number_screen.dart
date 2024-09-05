import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupchat/component_library/buttons/button.dart';
import 'package:groupchat/component_library/loaders/full_screen_loader.dart';
import 'package:groupchat/component_library/text_fields/custom_text_field.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/data/emergency_contact_model.dart';
import 'package:groupchat/repositories/contacts_repository.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/buttons/back_button.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';
import '../../core/static_keys.dart';
import '../../core/utilities_class.dart';
import '../../core/validation.dart';
import '../home_screens/contacts_info_screen.dart';

class AddEmergencyNumbersScreen extends StatefulWidget{
  static const route = 'AddEmergencyNumbersScreen';
  @override
  State<StatefulWidget> createState() => _AddEmergencyNumberState();

}

class _AddEmergencyNumberState extends State<AddEmergencyNumbersScreen>{

  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool? isLoading = false;

  updateState(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(child: Stack(
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 18.0.sp,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackIconButton(
                          size: 24.0.sp,
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, ContactsInfoScreen.route, arguments: {
                              'type': emergency
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
                  SizedBox(height: 15.sp,),
                  Image.asset(
                    Images.logoAroundEU,
                    height: 130.0.sp,
                    width: 130.0.sp,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(height: 7.sp,),
                  ExtraMediumText(
                    textColor: AppColors.lightBlack,
                    title: 'Add new Emergency Contact'.tr(),
                  ),
                  SizedBox(height: 15.sp,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                    child: CustomTextField(
                        controller: nameController,
                      labelText: 'Name'.tr(),
                      validator: (value) {
                        return Validation().validateEmptyField(value,
                            message: 'Name required'.tr());
                      },
                    ),
                  ),
                  SizedBox(height: 10.sp,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                    child: CustomTextField(
                      controller: numberController,
                      labelText: 'Contact'.tr(),
                      allowNumbersOnly: true,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9]')),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (value) {
                        return Validation().validateEmptyField(value,
                            message: 'Contact required'.tr());
                      },
                    ),
                  ),
                  SizedBox(height: 25.sp,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.sp),
                    child: Button(text: 'Save'.tr(), tapAction: (){
                      if(_formKey.currentState!.validate()){
                        saveContact();
                      }
                    }),
                  )
                ],
              ),
            ),
          ),
          FullScreenLoader(loading: isLoading,)
        ],
      )),
    );
  }

  saveContact(){
    isLoading = true;
    updateState();
    EmergencyContactModel contactModel = EmergencyContactModel(
      name: nameController.text,
      number: numberController.text
    );
    ContactsRepository().addEmergencyContact(contactModel, context, (){
      isLoading = false;
      updateState();
      Utilities().showSuccessDialog(context, message: 'Saved !'.tr(),
          onBtnTap: () {
            nameController.clear();
            numberController.clear();
            Navigator.pop(context);
            Navigator.pushNamed(context, ContactsInfoScreen.route, arguments: {
              'type': emergency
            });
          });
    }, (p0){
      isLoading = false;
      updateState();
      Utilities().showErrorMessage(context, message: 'Error: ${p0.toString()}');
    });
  }

}