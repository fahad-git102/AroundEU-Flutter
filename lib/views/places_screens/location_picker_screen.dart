import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:groupchat/component_library/buttons/button.dart';
import 'package:groupchat/component_library/loaders/full_screen_loader.dart';
import 'package:groupchat/core/locations_manager.dart';
import 'package:groupchat/core/utilities_class.dart';
import 'package:groupchat/data/location_model.dart';
import 'package:sizer/sizer.dart';
import '../../core/app_colors.dart';

class LocationPickerScreen extends StatefulWidget {
  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  TextEditingController searchController = TextEditingController();
  late GoogleMapController _mapController;
  LatLng? _pickedLocation;
  bool? isLoading = false;

  updateState(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(15.0.sp),
        child: Button(
          text: 'Pick Location'.tr(),
          tapAction: (){
            if(_pickedLocation!=null){
              LocationModel locationModel = LocationModel(
                  address: searchController.text,
                latitude: _pickedLocation?.latitude,
                longitude: _pickedLocation?.longitude
              ) ;
              Navigator.pop(context, locationModel.toMap());
            }else{
              Utilities().showErrorMessage(context, message: 'Please pick a location to continue'.tr());
            }
          },
        ),
      ),
      appBar: AppBar(
        title: Text('Pick a Location'.tr()),
        actions: [
          if (_pickedLocation != null)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                if(_pickedLocation!=null){
                  LocationModel locationModel = LocationModel(
                      address: searchController.text,
                      latitude: _pickedLocation?.latitude,
                      longitude: _pickedLocation?.longitude
                  ) ;
                  Navigator.pop(context, locationModel.toMap());
                }else{
                  Utilities().showErrorMessage(context, message: 'Please pick a location to continue'.tr());
                }
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.7749, -122.4194), // Default to San Francisco
              zoom: 14.0,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              _getUserLocation();
            },
            onTap: (LatLng location) async {
              var address = await LocationsManager().getAddressFromLatLng(location);
              searchController.text = address??'';
              setState(() {
                _pickedLocation = location;
              });
            },
            markers: _pickedLocation == null
                ? {}
                : {
                    Marker(
                      markerId: MarkerId('picked-location'),
                      position: _pickedLocation!,
                    ),
                  },
          ),
          Positioned(
              top: 1,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.0.sp, vertical: 10.0.sp),
                child: Container(
                  color: AppColors.white,
                  child: GooglePlaceAutoCompleteTextField(
                    textEditingController: searchController,
                    googleAPIKey: "AIzaSyALZpIBW7NvdLPVAYaDRwBYfZUo9vregH0",
                    inputDecoration: InputDecoration(
                      hintText: "Search".tr(),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                    debounceTime: 400,
                    // countries: const ["in", "fr"],
                    isLatLngRequired: true,
                    getPlaceDetailWithLatLng: (Prediction prediction) {},
                    itemClick: (Prediction prediction) {
                      searchController.text = prediction.description??'';
                      navigateUsingAddress(prediction.description??'');
                    },
                    seperatedBuilder: const Divider(),
                    containerHorizontalPadding: 10,
                    itemBuilder: (context, index, Prediction prediction) {
                      return Container(
                        padding: EdgeInsets.all(10.sp),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on),
                            SizedBox(
                              width: 7.sp,
                            ),
                            Expanded(child: Text(prediction.description ?? ""))
                          ],
                        ),
                      );
                    },
                    isCrossBtnShown: true,
                  ),
                ),
              )),
          FullScreenLoader(
            loading: isLoading,
          )
        ],
      ),
    );
  }

  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _mapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(position.latitude, position.longitude),
      ),
    );
  }

  Future<void> navigateUsingAddress(String fullText) async {
    try {
      await Future.delayed(Duration(seconds: 2),() async {
        // const String googelApiKey = 'AIzaSyBG2n1YwnWAwYhCMjLZYAVWnMI3c7RQIII';
        // const bool isDebugMode = true;
        // final api = GoogleGeocodingApi(googelApiKey, isLogged: isDebugMode);
        // final reversedSearchResults = await api.search(
        //   fullText,
        //   language: 'en',
        // );
        // double? lat = reversedSearchResults.results.last.geometry?.location.lat;
        // double? lng = reversedSearchResults.results.last.geometry?.location.lng;
        // LatLng lt= LatLng(lat!,lng!);
        LatLng? lt = await LocationsManager().getLatLngFromAddress(fullText);
        _pickedLocation = lt;
        _mapController.animateCamera(
          CameraUpdate.newLatLng(lt!),
        );
        updateState();
      });
    } catch (e) {
      print("this is the error in Map AutocompleteS");
      print(e.toString());
    }
  }

  // Future<String?> getAddressFromLatLng(LatLng location) async{
  //   try{
  //     const String googelApiKey = 'AIzaSyBG2n1YwnWAwYhCMjLZYAVWnMI3c7RQIII';
  //     const bool isDebugMode = true;
  //     final api = GoogleGeocodingApi(googelApiKey, isLogged: isDebugMode);
  //     final reversedSearchResults = await api.reverse(
  //       '${location.latitude},${location.longitude}',
  //       language: 'en',
  //     );
  //     var address = reversedSearchResults.results.first.formattedAddress;
  //     return address;
  //   }catch(e){
  //     return null;
  //   }
  //
  // }

}
