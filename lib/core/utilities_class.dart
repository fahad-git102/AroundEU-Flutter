import 'package:flutter/material.dart';

import 'app_colors.dart';

class Utilities{
  Future<DateTime?> datePicker(BuildContext context, Color? color,
      {lastDate, firstDate, initialDate}) async {
    return showDatePicker(
        context: context,
        initialDate: initialDate ?? DateTime.now(),

        /// initial date from which user can select date
        firstDate: firstDate ?? DateTime(1950),

        ///initial value of date
        lastDate: lastDate ?? DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary:
                color ?? Theme.of(context).primaryColor, // <-- SEE HERE
                onPrimary: AppColors.white, // <-- SEE HERE
                onSurface:
                color ?? Theme.of(context).primaryColor, // <-- SEE HERE
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: color ??
                      Theme.of(context).primaryColor, // button text color
                ),
              ),
            ),
            child: child!,
          );
        })

    ///last date till user can select date
        .then((pickedDate) {
      ///future jobs after user action
      if (pickedDate == null) {
        //if user tap cancel then this function will stop and return null
        return null;
      } else {
        return pickedDate;
      }
      });
    }
}