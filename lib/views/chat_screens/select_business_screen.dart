import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/business_list_widgets/business_list_item.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/providers/business_list_provider.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/app_bars/custom_app_bar.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';
import '../../providers/groups_provider.dart';
import '../admin_screens/groups_screen.dart';

class SelectBusinessScreen extends ConsumerStatefulWidget {
  static const route = 'SelectBusinessScreen';

  const SelectBusinessScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectBusinessState();
}

class _SelectBusinessState extends ConsumerState<SelectBusinessScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.watch(businessListProvider).listenToBusinessList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var businessListPro = ref.watch(businessListProvider);
    var appUserPro = ref.read(appUserProvider);
    businessListPro.filterBusinessListByCountry(appUserPro.coordinatorsCountryModel?.id??appUserPro.countriesList?[0].id??'');
    return Scaffold(
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
            CustomAppBar(
              title: 'Select country'.tr(),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: businessListPro.filteredBusinessList?.length ?? 0,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 13.sp),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          ref.watch(groupsProvider).currentBLGroupsList = null;
                          Navigator.pushNamed(
                              context, GroupsScreen.route, arguments: {
                            'businessList':
                                businessListPro.filteredBusinessList?[index].toMap()
                          });
                        },
                        child: BusinessListItem(
                          showDot: businessListPro.filteredBusinessList?[index].showDot,
                          showMenuButton: false,
                          title: businessListPro.filteredBusinessList?[index].name,
                          country: appUserPro
                                  .getCountryById(businessListPro
                                          .filteredBusinessList?[index].countryId ??
                                      '')
                                  ?.countryName ??
                              '',
                        ),
                      );
                    }))
          ],
        ),
      )),
    );
  }
}
