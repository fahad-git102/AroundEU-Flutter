import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/companies_widgets/company_details_widget.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/size_config.dart';
import 'package:groupchat/data/company_model.dart';
import 'package:groupchat/providers/companies_provider.dart';
import 'package:groupchat/views/companies_screens/company_settings_screen.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/app_bars/custom_app_bar.dart';
import '../../core/assets_names.dart';

class CompanyDetailScreen extends StatefulWidget {
  static const route = 'CompanyDetailScreen';

  @override
  State<StatefulWidget> createState() => _CompanyDetailScreenState();
}

class _CompanyDetailScreenState extends State<CompanyDetailScreen> {
  CompanyModel? company;
  bool? fromHome = false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final args = ModalRoute.of(context)!.settings.arguments != null
        ? ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>
        : null;
    company ??= args!['company'] != null ? CompanyModel.fromMap(args['company']) : null;
    fromHome = args!['fromHome'] != null ? args['fromHome'] as bool : false;
    return Scaffold(
      body: SafeArea(
          child: Consumer(builder: (ctx, ref, child){
            var companiesPro = ref.watch(companiesProvider);
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(
                    title: 'Company Details'.tr(),
                    trailingWidget: InkWell(
                      onTap: () {
                        if(fromHome==true){
                          Navigator.pushNamed(context, CompanySettingsScreen.route, arguments: {
                            'company': company?.toMap(),
                            'myCompanyTimeScheduled': companiesPro.myCompanyTimeScheduled?.toMap(),
                            'edit' : true
                          });
                        }else{
                          Navigator.pushNamed(context, CompanySettingsScreen.route, arguments: {
                            'company': company?.toMap()
                          });
                        }
                      },
                      child: Padding(
                          padding: EdgeInsets.all(3.0.sp),
                          child: Icon(
                            fromHome == true ? Icons.edit : Icons.settings,
                            color: AppColors.lightBlack,
                            size: 25.0.sp,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 15.0.sp,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: CompanyDetailWidget(
                              title: 'Full Legal Name:'.tr(),
                              value: company?.fullLegalName??'',
                            ),
                          ),
                          SizedBox(height: 10.0.sp,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: CompanyDetailWidget(
                              title: 'Size:'.tr(),
                              value: company?.size??'',
                            ),
                          ),
                          SizedBox(height: 10.0.sp,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: CompanyDetailWidget(
                              title: 'Legal Address:'.tr(),
                              value: company?.legalAddress??'',
                            ),
                          ),
                          SizedBox(height: 10.0.sp,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: CompanyDetailWidget(
                              title: 'Postal Code:'.tr(),
                              value: company?.poastalCode??'',
                            ),
                          ),
                          SizedBox(height: 10.0.sp,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: CompanyDetailWidget(
                              title: 'City:'.tr(),
                              value: company?.city??'',
                            ),
                          ),
                          SizedBox(height: 10.0.sp,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: CompanyDetailWidget(
                              title: 'Country:'.tr(),
                              value: company?.country??'',
                            ),
                          ),
                          SizedBox(height: 10.0.sp,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: CompanyDetailWidget(
                              title: 'Telephone:'.tr(),
                              value: company?.telephone??'',
                            ),
                          ),
                          SizedBox(height: 10.0.sp,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: CompanyDetailWidget(
                              title: 'Email:'.tr(),
                              value: company?.email??'',
                            ),
                          ),
                          SizedBox(height: 10.0.sp,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: CompanyDetailWidget(
                              title: 'Contact Person:'.tr(),
                              value: company?.contactPerson??'',
                            ),
                          ),
                          SizedBox(height: 10.0.sp,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: CompanyDetailWidget(
                              title: 'P.I.V.A:'.tr(),
                              value: company?.piva ??'',
                            ),
                          ),
                          SizedBox(height: 10.0.sp,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: CompanyDetailWidget(
                              title: 'Legal Representative:'.tr(),
                              value: company?.legalRepresentative??'',
                            ),
                          ),
                          SizedBox(height: 10.0.sp,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: CompanyDetailWidget(
                              title: 'Legal Representative ID:'.tr(),
                              value: company?.idLegalRepresent??'',
                            ),
                          ),
                          SizedBox(height: 10.0.sp,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: CompanyDetailWidget(
                              title: 'Website:'.tr(),
                              value: company?.website??'',
                            ),
                          ),
                          SizedBox(height: 10.0.sp,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: CompanyDetailWidget(
                              title: 'Company Description:'.tr(),
                              value: company?.companyDescription??'',
                            ),
                          ),
                          SizedBox(height: 10.0.sp,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: CompanyDetailWidget(
                              title: 'Company Responsibility:'.tr(),
                              value: company?.companyResponsibility??'',
                            ),
                          ),
                          SizedBox(height: 10.0.sp,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                            child: CompanyDetailWidget(
                              title: 'Tasks of Students:'.tr(),
                              value: company?.taskOfStudents??'',
                            ),
                          ),
                          SizedBox(height: 10.0.sp,),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },)),
    );
  }
}
