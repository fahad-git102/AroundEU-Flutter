import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/buttons/button.dart';
import 'package:groupchat/component_library/image_widgets/no_data_widget.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/core/size_config.dart';
import 'package:groupchat/core/static_keys.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/providers/places_provider.dart';
import 'package:groupchat/views/admin_screens/all_places_screen.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/app_bars/custom_app_bar.dart';
import '../../component_library/places_widgets/places_item.dart';
import '../../core/assets_names.dart';
import '../places_screens/places_detail_screen.dart';

class ManagePlacesScreen extends StatefulWidget {
  static const route = 'ManagePlacesScreen';

  @override
  State<StatefulWidget> createState() => _ManagePlacesScreenState();
}

class _ManagePlacesScreenState extends State<ManagePlacesScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(child: Consumer(builder: (ctx, ref, child) {
        var placesPro = ref.watch(placesProvider);
        var appUserPro = ref.watch(appUserProvider);
        placesPro.listenToPendingPlaces();
        appUserPro.listenToCountries();
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
                title: 'Pending Places'.tr(),
              ),
              SizedBox(
                height: 10.sp,
              ),
              Expanded(
                  child: placesPro.pendingPlacesList?.isEmpty == true
                      ? Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 50.sp),
                            child: NoDataWidget()),
                      )
                      : ListView.builder(
                          itemCount: placesPro.pendingPlacesList?.length ?? 0,
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 13.sp),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 3.0.sp),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, PlacesDetailScreen.route,
                                        arguments: {
                                          'place': placesPro
                                              .pendingPlacesList?[index]
                                              .toMap()
                                        });
                                  },
                                  child: PlacesWidget(
                                    imageUrl: placesPro
                                        .pendingPlacesList?[index].imageUrl,
                                    createdBy: placesPro
                                        .pendingPlacesList?[index].creatorName,
                                    category: placesPro
                                        .pendingPlacesList?[index].category,
                                    description: placesPro
                                        .pendingPlacesList?[index].description,
                                    country: placesPro
                                        .pendingPlacesList?[index].country,
                                  ),
                                ));
                          })),
              SizedBox(
                height: 4.sp,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.sp),
                child: Button(
                    text: 'All Places'.tr(),
                    tapAction: () {
                      Navigator.pushNamed(context, AllPlacesScreen.route);
                    }),
              ),
              SizedBox(
                height: 13.sp,
              )
            ],
          ),
        );
      })),
    );
  }
}
