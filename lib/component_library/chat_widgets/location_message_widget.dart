import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:groupchat/core/app_colors.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationMessageWidget extends StatelessWidget {
  final double? latitude;
  final double? longitude;

  const LocationMessageWidget({super.key,
    required this.latitude,
    required this.longitude,
  });

  String _getStaticMapImage() {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=14&size=300x300&markers=color:red%7C$latitude,$longitude&key=AIzaSyALZpIBW7NvdLPVAYaDRwBYfZUo9vregH0';
  }

  Future<void> _openLocationInMap() async {
    String url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openLocationInMap,
      child: SizedBox(
        width: 100.sp,
        height: 85.sp,
        child: CachedNetworkImage(
          imageUrl: _getStaticMapImage(),
          placeholder: (context, url) => SpinKitPulse(color: AppColors.mainColorDark,),
          errorWidget: (context, url, error) => Icon(Icons.error, color: AppColors.mainColorDark,),
        ),
      ),
    );
  }
}
