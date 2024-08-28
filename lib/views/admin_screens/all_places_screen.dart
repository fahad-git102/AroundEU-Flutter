import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/app_bars/custom_app_bar.dart';
import 'package:groupchat/core/size_config.dart';
import 'package:groupchat/core/static_keys.dart';
import 'package:groupchat/providers/places_provider.dart';
import 'package:sizer/sizer.dart';

import '../../component_library/places_widgets/places_item.dart';
import '../../core/assets_names.dart';
import '../places_screens/places_detail_screen.dart';

class AllPlacesScreen extends StatefulWidget{
  static const route = 'AllPlacesScreen';
  @override
  State<StatefulWidget> createState() => _AllPlacesScreenState();
}

class _AllPlacesScreenState extends State<AllPlacesScreen>{
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(child: Consumer(builder: (ctx, ref, child){
        var placesPro = ref.watch(placesProvider);
        placesPro.listenToAllPlacesForAdmin();
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
                title: 'All Places'.tr(),
              ),
              SizedBox(height: 10.sp,),
              Expanded(child: ListView.builder(
                itemCount: placesPro.allPlacesForAdminList?.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 13.sp),
                  itemBuilder: (BuildContext context, int index){
                    return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.0.sp),
                        child: InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, PlacesDetailScreen.route, arguments: {
                              'place' : placesPro.allPlacesForAdminList?[index].toMap()
                            });
                          },
                          child: PlacesWidget(
                            imageUrl: placesPro.allPlacesForAdminList?[index].imageUrl,
                            createdBy: placesPro.allPlacesForAdminList?[index].creatorName,
                            category: placesPro.allPlacesForAdminList?[index].category,
                            description: placesPro.allPlacesForAdminList?[index].description,
                            country: placesPro.allPlacesForAdminList?[index].country,
                            status: placesPro.allPlacesForAdminList?[index].status,
                          ),
                        ));;
                  }))
            ],
          ),
        );
      },)),
    );
  }

}