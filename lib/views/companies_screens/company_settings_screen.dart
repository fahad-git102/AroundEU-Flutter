import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/app_bars/custom_app_bar.dart';
import 'package:groupchat/component_library/buttons/button.dart';
import 'package:groupchat/component_library/companies_widgets/time_widget.dart';
import 'package:groupchat/component_library/loaders/full_screen_loader.dart';
import 'package:groupchat/component_library/text_widgets/extra_large_medium_bold_text.dart';
import 'package:groupchat/component_library/text_widgets/extra_medium_text.dart';
import 'package:groupchat/component_library/text_widgets/small_light_text.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/data/company_time_scheduled.dart';
import 'package:groupchat/firebase/auth.dart';
import 'package:groupchat/providers/companies_provider.dart';
import 'package:groupchat/repositories/companies_repository.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/text_fields/simple_text_field.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';
import '../../core/validation.dart';
import '../../data/company_model.dart';

class CompanySettingsScreen extends StatefulWidget {
  static const route = 'CompanySettingsScreen';

  @override
  State<StatefulWidget> createState() => _CompanySettingsScreenState();
}

class _CompanySettingsScreenState extends State<CompanySettingsScreen> {
  final List<String> days = [
    'MON'.tr(),
    'TUE'.tr(),
    'WED'.tr(),
    'THURS'.tr(),
    'FRI'.tr(),
    'SAT'.tr(),
    'SUN'.tr()
  ];
  final _formKey = GlobalKey<FormState>();
  List<String> selectedDays = [];
  CompanyModel? company;
  CompanyTimeScheduled? myCompanyTimeScheduled;
  String? morningFrom, morningTo;
  String? noonFrom, noonTo;
  TextEditingController descriptionController = TextEditingController();
  bool? isLoading = false;
  TimeOfDay? todMorningFrom, todMorningTo, todNoonFrom, todNoonTo;
  bool? isEdit = true;
  bool? pageStarted = true;

  updateState(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final args = ModalRoute.of(context)!.settings.arguments != null
        ? ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>
        : null;
    company ??=
        args!['company'] != null ? CompanyModel.fromMap(args['company']) : null;
    myCompanyTimeScheduled ??=
      args!['myCompanyTimeScheduled'] != null ? CompanyTimeScheduled.fromMap(args['myCompanyTimeScheduled']) : null;
    isEdit = args!['edit'] != null ? args['edit'] as bool : false;

    if(pageStarted== true&&myCompanyTimeScheduled!=null){
      morningFrom = myCompanyTimeScheduled?.morningFrom;
      morningTo = myCompanyTimeScheduled?.morningTo;
      noonFrom = myCompanyTimeScheduled?.noonFrom;
      noonTo = myCompanyTimeScheduled?.noonTo;
      descriptionController.text = myCompanyTimeScheduled?.description??'';
      for(var item in myCompanyTimeScheduled?.selectedDays??[]){
        selectedDays.add(replaceHalfWord(item));
      }
      pageStarted = false;
    }

    todMorningFrom ??= TimeOfDay.now();
    todMorningTo ??= TimeOfDay.now();
    todNoonFrom ??= TimeOfDay.now();
    todNoonTo ??= TimeOfDay.now();
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(
                  title: '',
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
                            height: 10.0.sp,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: ExtraLargeMediumBoldText(
                              title: isEdit==true?'Update Working Details'.tr():'Add Working Details'.tr(),
                              textColor: AppColors.lightBlack,
                            ),
                          ),
                          SizedBox(height: 20.0.sp,),
                          SizedBox(
                            height: 50.0,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: days.length,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                              itemBuilder: (context, index) {
                                final day = days[index];
                                final isSelected = selectedDays.contains(day);
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedDays.remove(day);
                                      } else {
                                        selectedDays.add(day);
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 40.sp,
                                    width: 40.sp,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.mainColor
                                          : AppColors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black87.withOpacity(0.25),
                                          blurRadius: 4,
                                          offset: const Offset(1, 1), // Shadow position
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: SmallLightText(
                                        title: day,
                                        textColor: AppColors.lightBlack,
                                        fontSize: 10.0.sp,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 30.0.sp,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: ExtraMediumText(
                              title: 'Select Timings'.tr(),
                              textColor: AppColors.lightBlack,
                            ),
                          ),
                          SizedBox(
                            height: 12.0.sp,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: SmallLightText(
                              title: 'Morning:'.tr(),
                              textColor: AppColors.lightBlack,
                            ),
                          ),
                          SizedBox(
                            height: 4.0.sp,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TimeWidget(
                                    title: 'From:'.tr(),
                                    value: morningFrom ?? 'Not selected'.tr(),
                                  onTap: (){
                                      Utilities().showTimePicker(context, todMorningFrom??TimeOfDay.now(), (p0) {
                                        todMorningFrom = TimeOfDay(hour: p0.hour, minute: p0.minute);
                                        morningFrom = Utilities().formatTimeOfDay(todMorningFrom!);
                                        updateState();
                                      });
                                  },
                                ),
                                TimeWidget(
                                    title: 'To:'.tr(),
                                    value: morningTo ?? 'Not selected'.tr(),
                                  onTap: (){
                                    Utilities().showTimePicker(context, todMorningTo??TimeOfDay.now(), (p0) {
                                      todMorningTo = TimeOfDay(hour: p0.hour, minute: p0.minute);
                                      morningTo = Utilities().formatTimeOfDay(todMorningTo!);
                                      updateState();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 12.0.sp,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: SmallLightText(
                              title: 'Afternoon:'.tr(),
                              textColor: AppColors.lightBlack,
                            ),
                          ),
                          SizedBox(
                            height: 4.0.sp,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TimeWidget(
                                    title: 'From:'.tr(),
                                    value: noonFrom ?? 'Not selected'.tr(),
                                  onTap: (){
                                    Utilities().showTimePicker(context, todNoonFrom??TimeOfDay.now(), (p0) {
                                      todNoonFrom = TimeOfDay(hour: p0.hour, minute: p0.minute);
                                      noonFrom = Utilities().formatTimeOfDay(todNoonFrom!);
                                      updateState();
                                    });
                                  },
                                ),
                                TimeWidget(
                                    title: 'To:'.tr(),
                                    value: noonTo ?? 'Not selected'.tr(),
                                    onTap: (){
                                      Utilities().showTimePicker(context, todNoonTo??TimeOfDay.now(), (p0) {
                                        todNoonTo = TimeOfDay(hour: p0.hour, minute: p0.minute);
                                        noonTo = Utilities().formatTimeOfDay(todNoonTo!);
                                        updateState();
                                      });
                                    },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 17.sp,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: SmallLightText(
                              title: 'Description:'.tr(),
                              textColor: AppColors.lightBlack,
                            ),
                          ),
                          SizedBox(
                            height: 4.0.sp,
                          ),
                          Container(
                            width: SizeConfig.screenWidth,
                            margin: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            padding: EdgeInsets.all(10.0.sp),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: AppColors.lightFadedTextColor, width: 0.4.sp),
                                borderRadius: BorderRadius.all(Radius.circular(4.sp))),
                            child: SimpleTextField(
                              controller: descriptionController,
                              minLines: 4,
                              validator: (value) {
                                return Validation().validateEmptyField(value, message: 'Description required'.tr());
                              },
                              noBorder: true,
                            ),
                          ),
                          SizedBox(
                            height: 20.0.sp,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: Consumer(builder: (ctx, ref, child){
                              return Button(
                                text: 'Save'.tr(),
                                tapAction: (){
                                  if(_formKey.currentState!.validate()){
                                    if(selectedDays.isEmpty){
                                      Utilities().showErrorMessage(context, message: 'Please select working days'.tr());
                                      return;
                                    }
                                    if(morningTo==null||morningFrom==null||noonFrom==null||noonFrom==null){
                                      Utilities().showErrorMessage(context, message: 'Please fill your complete timings'.tr());
                                      return;
                                    }
                                    if(isEdit==true){
                                      updateMyCompanyTimeSchedule();
                                    }else{
                                      saveMyCompanyTimeSchedule(ref);
                                    }
                                  }
                                },
                              );
                            },),
                          ),
                          SizedBox(height: 280.0.sp,)
                        ],
                      ),
                    ),
                  ),
                )
              ],
                      ),
                    ),
              FullScreenLoader(loading: isLoading,)
            ],
          )),
    );
  }

  updateMyCompanyTimeSchedule(){
    CompanyTimeScheduled companyTimeScheduled = CompanyTimeScheduled(
      selectedDays: selectedDays,
      id: myCompanyTimeScheduled?.id,
      morningFrom: morningFrom,
      morningTo: morningTo,
      companyId: myCompanyTimeScheduled?.companyId,
      noonFrom: noonFrom,
      noonTo: noonTo,
      description: descriptionController.text,
      uid: myCompanyTimeScheduled?.uid
    );
    setState(() {
      isLoading = true;
    });
    CompanyRepository().updateMyCompanySchedule(companyTimeScheduled.toMap(), myCompanyTimeScheduled?.id??'',
        context, (){
      setState(() {
        isLoading = false;
      });
      Utilities().showCustomToast(message: 'Working details uploaded successfully'.tr(), isError: false);
        }, (p0){
          setState(() {
            isLoading = false;
          });
          Utilities().showCustomToast(message: p0.toString(), isError: true);
        });
  }

  saveMyCompanyTimeSchedule(WidgetRef ref){
    var companiesPro = ref.watch(companiesProvider);
    if(selectedDays.isNotEmpty){
      replaceFullWords();
    }
    myCompanyTimeScheduled = CompanyTimeScheduled(
      noonFrom: noonFrom,
      noonTo: noonTo,
      morningFrom: morningFrom,
      morningTo: morningTo,
      selectedDays: selectedDays,
      uid: Auth().currentUser?.uid,
      companyId: company?.id
    );
    isLoading = true;
    updateState();
    CompanyRepository().addMyCompanyTimeScheduled(myCompanyTimeScheduled!, context, () async {
      await companiesPro.listenToMyCompanyTimeScheduled();
      isLoading = false;
      updateState();
      Utilities().showSuccessDialog(context, message: 'Working details uploaded successfully'.tr(), onBtnTap: (){
        Navigator.of(context);
        Navigator.of(context);
      });
    }, (p0) {
      isLoading = false;
      updateState();
      Utilities().showErrorMessage(context, message: 'Error: ${p0.toString()}');
    });
  }
  replaceFullWords(){
    for(int i = 0; i<selectedDays.length; i++){
      if(selectedDays[i] == 'MON'.tr()){
        selectedDays[i] = 'MONDAY';
      }else if(selectedDays[i] == 'TUE'.tr()){
        selectedDays[i] = 'TUESDAY';
      }else if(selectedDays[i] == 'WED'.tr()){
        selectedDays[i] = 'WEDNESDAY';
      }else if(selectedDays[i] == 'THURS'.tr()){
        selectedDays[i] = 'THURSDAY';
      }else if(selectedDays[i] == 'FRI'.tr()){
        selectedDays[i] = 'FRIDAY';
      }else if(selectedDays[i] == 'SAT'.tr()){
        selectedDays[i] = 'SATURDAY';
      }else if(selectedDays[i] == 'SUN'.tr()){
        selectedDays[i] = 'SUNDAY';
      }
    }
  }

  replaceHalfWord(String day){
    if(day == 'MONDAY'.tr()){
      day = 'MON';
    }else if(day == 'TUESDAY'.tr()){
      day = 'TUE';
    }else if(day == 'WEDNESDAY'.tr()){
      day = 'WED';
    }else if(day == 'THURSDAY'.tr()){
      day = 'THURS';
    }else if(day == 'FRIDAY'.tr()){
      day = 'FRI';
    }else if(day == 'SATURDAY'.tr()){
      day = 'SAT';
    }else if(day == 'SUNDAY'.tr()){
      day = 'SUN';
    }
    return day;
  }

}
