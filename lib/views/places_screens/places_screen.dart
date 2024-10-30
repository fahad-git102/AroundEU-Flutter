import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groupchat/component_library/app_bars/custom_app_bar.dart';
import 'package:groupchat/component_library/dialogs/new_place_dialog.dart';
import 'package:groupchat/component_library/loaders/full_screen_loader.dart';
import 'package:groupchat/component_library/places_widgets/places_item.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:groupchat/providers/app_user_provider.dart';
import 'package:groupchat/providers/places_provider.dart';
import 'package:groupchat/views/places_screens/places_detail_screen.dart';
import 'package:sizer/sizer.dart';
import '../../core/assets_names.dart';
import '../../core/size_config.dart';

class PlacesScreen extends StatefulWidget{
  static const route = 'PlacesScreen';
  @override
  State<StatefulWidget> createState() => _PlacesScreenState();

}

class _PlacesScreenState extends State<PlacesScreen>{

  TextEditingController searchController = TextEditingController();
  bool? isLoading = false;
  bool? pageStarted = true;
  var categories = [
    'All'.tr(),
    "Bars & Restaurants".tr(),
    "Sightseeing places".tr(),
    "Experience".tr()
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  updateState(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.mainColor,
        tooltip: 'add',
        onPressed: (){
          showDialog(context: context, barrierDismissible: true, builder: (ctx) => NewPlaceDialog());
        },
        child: Icon(Icons.add, color: AppColors.lightBlack, size: 28),
      ),
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
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomAppBar(
                    title: 'Places to Explore'.tr(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.0.sp),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4.0.sp),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black87.withOpacity(0.25),
                              blurRadius: 4,
                              offset: const Offset(
                                  1, 1), // Shadow position
                            ),
                          ],
                          borderRadius: BorderRadius.all(
                              Radius.circular(4.sp))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0.sp),
                        child: SizedBox(
                          width: SizeConfig.screenWidth,
                          child: Consumer(builder: (ctx, ref, child){
                            var placesPro = ref.watch(placesProvider);
                            return DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                value: placesPro.selectedCategory,
                                style: TextStyle(color: AppColors.lightBlack),
                                items: categories.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                buttonStyleData: ButtonStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 5.0.sp),
                                  height: 43,
                                ),
                                onChanged: (newValue) {
                                  placesPro.selectedCategory = newValue!;
                                  placesPro.filterPlacesList();
                                  updateState();
                                },
                              ),
                            );
                          },),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0.sp,),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0.sp),
                      child: Consumer(builder: (ctx, ref, child){
                        var placesPro = ref.watch(placesProvider);
                        var appUserPro = ref.watch(appUserProvider);
                        if(pageStarted==true){
                          placesPro.listenToPlaces(appUserPro.currentUser!.selectedCountry??'');
                          pageStarted = false;
                        }
                        return ListView.builder(
                          itemCount: placesPro.filteredPlacesList?.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(bottom: 70.sp),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index){
                            return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.0.sp),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.pushNamed(context, PlacesDetailScreen.route, arguments: {
                                      'place' : placesPro.filteredPlacesList?[index].toMap()
                                    });
                                  },
                                  child: PlacesWidget(
                                    imageUrl: placesPro.filteredPlacesList?[index].imageUrl,
                                    createdBy: placesPro.filteredPlacesList?[index].creatorName,
                                    category: placesPro.filteredPlacesList?[index].category,
                                    description: placesPro.filteredPlacesList?[index].description,
                                  ),
                                ));
                          },
                        );
                      },),
                    ),
                  )
                ],
              ),
              FullScreenLoader(loading: isLoading,),
            ],
          ),
        ),
      ),
    );
  }

}