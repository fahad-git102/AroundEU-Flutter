import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/app_bars/custom_app_bar.dart';
import 'package:groupchat/component_library/buttons/button.dart';
import 'package:groupchat/component_library/drop_downs/countries_dropdown.dart';
import 'package:groupchat/component_library/text_fields/white_back_textfield.dart';
import 'package:groupchat/component_library/text_widgets/extra_large_medium_bold_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/data/business_list_model.dart';
import 'package:groupchat/data/country_model.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/repositories/business_list_repository.dart';
import 'package:sizer/sizer.dart';

import '../../core/validation.dart';

class AddBusinessListDialog extends StatefulWidget{

  final bool? isEdit;
  final BusinessList? businessList;

  const AddBusinessListDialog({super.key, this.isEdit, this.businessList});

  @override
  State<StatefulWidget> createState() => _AddBusinessListDialogState();

}

class _AddBusinessListDialogState extends State<AddBusinessListDialog>{

  TextEditingController controller = TextEditingController();
  CountryModel? selectedCountry;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  updateState(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Consumer(builder: (ctx, ref, child){
        var appUserPro = ref.watch(appUserProvider);
        appUserPro.listenToCountries();
        if(widget.isEdit==false){
          if(selectedCountry == null && (appUserPro.countriesList!=null && appUserPro.countriesList!.isNotEmpty)){
            selectedCountry = appUserPro.countriesList?.first;
          }
        }else if(widget.isEdit==true && widget.businessList?.countryId!=null){
          if(selectedCountry==null){
            CountryModel? country = appUserPro.getCountryById(widget.businessList?.countryId??'');
            selectedCountry = country;
          }
          controller.text = widget.businessList?.name??'';
        }

        return Container(
          padding: EdgeInsets.all(13.sp),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExtraLargeMediumBoldText(
                  title: "Add Business List".tr(),
                  textColor: AppColors.lightBlack,
                ),
                SizedBox(height: 10.0.sp,),
                WhiteBackTextField(
                  controller: controller,
                  hintText: 'Name'.tr(),
                  validator: (value) {
                    return Validation().validateEmptyField(value,
                        message: 'Name required'.tr());
                  },
                ),
                SizedBox(height: 10.sp,),
                CountriesDropDown(
                  selectedCountry: selectedCountry,
                  onChanged: (newValue){
                    selectedCountry = newValue;
                    updateState();
                  },
                ),
                SizedBox(height: 10.sp,),
                Button(text: widget.isEdit==true?'Update'.tr():'Save'.tr(), tapAction: (){
                  if(_formKey.currentState!.validate()){
                    widget.isEdit==true?updateBusinessList():saveBusinessList();
                  }
                }),
                SizedBox(height: 5.sp,)
              ],
            ),
          ),
        );
      }),
    );
  }

  saveBusinessList(){
    BusinessList businessList = BusinessList(
      name: controller.text,
      countryId: selectedCountry?.id,
      timeStamp: DateTime.now().millisecondsSinceEpoch,
      deleted: false
    );
    BusinessListRepository().addBusinessList(businessList, context, (){
      Utilities().showSuccessDialog(context, barrierDismissle: false, message: 'Business List saved', onBtnTap: (){
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }, (p0){
      Utilities().showErrorMessage(context, message: 'Error: ${p0.toString()}');
    });
  }

  updateBusinessList(){
    widget.businessList?.name = controller.text;
    widget.businessList?.countryId = selectedCountry?.id;
    BusinessListRepository().updateBusinessList(widget.businessList!,
        context, (){
          Utilities().showSuccessDialog(context, barrierDismissle: false, message: 'Business List updated', onBtnTap: (){
            Navigator.pop(context);
            Navigator.pop(context);
          });
        }, (p0){
          Utilities().showErrorMessage(context, message: 'Error: ${p0.toString()}');
        });
  }

}