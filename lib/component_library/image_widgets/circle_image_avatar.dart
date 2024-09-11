import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:groupchat/core/assets_names.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_colors.dart';

class CircleImageAvatar extends StatelessWidget {
  final String? imagePath;
  final double? size;
  final double borderWidth;
  final Color borderColor;

  const CircleImageAvatar({
    super.key,
    this.imagePath,
    this.size,
    this.borderWidth = 2.0,
    this.borderColor = Colors.blue, // Default border color
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 70.0.sp,
      height: size ?? 70.0.sp,
      child: CircleAvatar(
        backgroundColor: borderColor, // Border color
        radius: (size ?? 70.0.sp) / 2,
        child: ClipOval(
          child: Container(
            padding: EdgeInsets.all(borderWidth), // Border width
            color: AppColors.fadedTextColor2, // Inner background color
            child: ClipOval(
              child: imagePath != null && imagePath?.isNotEmpty==true
                  ? CachedNetworkImage(
                height: size,
                width: size,
                imageUrl: imagePath ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: SizedBox(
                    height: 12.0.sp,
                    width: 12.0.sp,
                    child: const CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Text(
                    'Failed to load image',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              )
                  : Image.asset(
                Images.profileImageIcon,
                width: size ?? 70.0.sp,
                height: size ?? 70.0.sp,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
