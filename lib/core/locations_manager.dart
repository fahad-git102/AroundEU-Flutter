import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationsManager{
  Future<LatLng>? getLatLngFromAddress(String fullText) async {
    const String googelApiKey = 'AIzaSyBG2n1YwnWAwYhCMjLZYAVWnMI3c7RQIII';
    const bool isDebugMode = true;
    final api = GoogleGeocodingApi(googelApiKey, isLogged: isDebugMode);
    final reversedSearchResults = await api.search(
      fullText,
      language: 'en',
    );
    double? lat = reversedSearchResults.results.last.geometry?.location.lat;
    double? lng = reversedSearchResults.results.last.geometry?.location.lng;
    LatLng lt= LatLng(lat!,lng!);
    return lt;
  }

  Future<String?> getAddressFromLatLng(LatLng location) async{
    try{
      const String googelApiKey = 'AIzaSyBG2n1YwnWAwYhCMjLZYAVWnMI3c7RQIII';
      const bool isDebugMode = true;
      final api = GoogleGeocodingApi(googelApiKey, isLogged: isDebugMode);
      final reversedSearchResults = await api.reverse(
        '${location.latitude},${location.longitude}',
        language: 'en',
      );
      var address = reversedSearchResults.results.first.formattedAddress;
      return address;
    }catch(e){
      return null;
    }

  }
}