import 'dart:math';
import 'dart:ui';

import 'package:budget/functions.dart';
import 'package:budget/struct/settings.dart';
import 'package:budget/widgets/fab.dart';
import 'package:budget/widgets/globalSnackbar.dart';
import 'package:budget/widgets/openSnackbar.dart';
import 'package:budget/widgets/p_date_picker/pdate_picker_common.dart';
import 'package:budget/widgets/p_date_picker/pdate_picker_dialog.dart';
import 'package:budget/widgets/p_date_picker/pdate_range_picker_dialog.dart';
import 'package:budget/widgets/textInput.dart';
import 'package:budget/widgets/util/showTimePicker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

Future<DateTime?> showCustomDatePicker(
  BuildContext context,
  DateTime initialDate, {
  DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
  String? helpText,
  String? cancelText,
  String? confirmText,
}) async {
  minimizeKeyboard(context);

  Jalali? date = await showPersianDatePickerCustom(
    context: context,
    initialDate: Jalali.fromDateTime(initialDate),
    firstDate: Jalali(1385, 8),
    lastDate: Jalali(1450, 9),
    // initialEntryMode: PDatePickerEntryMode.calendarOnly,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).copyWith(
          useMaterial3: appStateSettings["materialYou"],
          dialogBackgroundColor: Theme.of(context).canvasColor,
          scaffoldBackgroundColor: Theme.of(context).canvasColor,
          dividerColor: Colors.black,
          primaryColor: Colors.black,
          cardColor: Colors.black,
          shadowColor: getPlatform() == PlatformOS.isIOS && appStateSettings["materialYou"]
              ? Theme.of(context).colorScheme.secondaryContainer
              : null,

          colorScheme: Theme.of(context).colorScheme.copyWith(
                onPrimary: Theme.of(context).colorScheme.onPrimary,
              ),
          // Buttons
        ),
        child: child!,
      );
    },
  );
  if (date != null) {
    return Jalali(date.year, date.month, date.day).toDateTime();
  } else {
    return null;
  }
  // return jalali.Jalali.fromDateTime(await showDatePicker(
  //       context: context,
  //       initialDate: DateTime(initialDate.year, initialDate.month, initialDate.day),
  //       initialEntryMode: initialEntryMode,
  //       firstDate: DateTime(DateTime.now().year - 1000),
  //       lastDate: DateTime(DateTime.now().year + 1000),
  //       helpText: helpText,
  //       cancelText: cancelText,
  //       confirmText: confirmText,
  //       builder: (BuildContext context, Widget? child) {
  //         return Theme(
  //           data: Theme.of(context).copyWith(
  //             useMaterial3: appStateSettings["materialYou"],
  //             datePickerTheme: DatePickerTheme.of(context).copyWith(
  //               headerHeadlineStyle: const TextStyle(
  //                 fontSize: 26,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             shadowColor: getPlatform() == PlatformOS.isIOS && appStateSettings["materialYou"]
  //                 ? Theme.of(context).colorScheme.secondaryContainer
  //                 : null,
  //           ),
  //           child: child ?? SizedBox.shrink(),
  //         );
  //       },
  //     ) ??
  //     DateTime.now());
}

class DateTimeRangeOrAllTime {
  final bool allTime;
  final DateTimeRange? dateTimeRange;

  DateTimeRangeOrAllTime({
    required this.allTime,
    this.dateTimeRange,
  });

  factory DateTimeRangeOrAllTime.allTime() => DateTimeRangeOrAllTime(allTime: true);

  factory DateTimeRangeOrAllTime.fromRange(DateTime start, DateTime end) => DateTimeRangeOrAllTime(
        allTime: false,
        dateTimeRange: DateTimeRange(start: start, end: end),
      );

  @override
  String toString() {
    if (allTime) {
      return 'All Time';
    } else {
      return 'Start: ${dateTimeRange!.start}, End: ${dateTimeRange!.end}';
    }
  }
}

Future<DateTimeRangeOrAllTime> showCustomDateRangePicker(
  BuildContext context,
  DateTimeRangeOrAllTime? initialDateRange, {
  DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
  bool allTimeButton = false,
}) async {
  minimizeKeyboard(context);
  bool allTime = initialDateRange?.allTime ?? false;
  JalaliRange? result = await showPersianDateRangePickerCustom(
    context: context,
    firstDate: Jalali(1385, 8),
    lastDate: Jalali(1450, 9),
    initialDateRange: JalaliRange(
        start: initialDateRange != null ? Jalali.fromDateTime(initialDateRange.dateTimeRange!.start) : Jalali.now(),
        end: initialDateRange != null ? Jalali.fromDateTime(initialDateRange.dateTimeRange!.end) : Jalali.now().addMonths(1)),
    builder: (BuildContext context2, Widget? child) {
      double fabSize = 50;
      return Theme(
        data: Theme.of(context2).copyWith(
          useMaterial3: appStateSettings["materialYou"],
          datePickerTheme: DatePickerTheme.of(context2).copyWith(
            headerHeadlineStyle: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MediaQuery(
              data: MediaQuery.of(context).copyWith(
                viewInsets: EdgeInsets.only(
                  top: MediaQuery.viewInsetsOf(context).top,
                  right: MediaQuery.viewInsetsOf(context).right,
                  left: MediaQuery.viewInsetsOf(context).left,
                ),
              ),
              child: child ?? SizedBox.shrink(),
            ),
            if (allTimeButton)
              Align(
                alignment: Alignment.centerRight,
                child: Transform.translate(
                  offset: Offset(0, -10),
                  child: Padding(
                    padding: EdgeInsets.only(right: max((MediaQuery.sizeOf(context).width / 2 - 300), 30)),
                    child: Opacity(
                      opacity: allTime ? 1 : 0.7,
                      child: FAB(
                        borderRadius: 15,
                        fabSize: fabSize,
                        iconData: appStateSettings["outlinedIcons"] ? Icons.event_outlined : Icons.event_rounded,
                        label: "all-time".tr(),
                        labelSize: 16,
                        onTap: () {
                          allTime = !allTime;
                          Navigator.pop(context, null);
                        },
                        isOutlined: allTime == false,
                      ),
                    ),
                  ),
                ),
              ),
            Builder(builder: (context) {
              return SizedBox(
                  height: clampDouble(
                getKeyboardHeightForceBuild(context) - fabSize * 2,
                0,
                double.infinity,
              ));
            }),
          ],
        ),
      );
    },
    // initialEntryMode: initialEntryMode,
  );
  return DateTimeRangeOrAllTime(
    allTime: allTime,
    dateTimeRange: result == null && allTime == false
        ? initialDateRange?.dateTimeRange
        : DateTimeRange(start: result!.start.toDateTime(), end: result.end.toDateTime()),
  );
}

Future<Jalali?> selectDateAndTimeSequence(BuildContext context, Jalali initialDate) async {
  Jalali? selectedDateTime = await showPersianDatePickerCustom(
    context: context,
    initialDate: initialDate,
    firstDate: Jalali(1385, 8),
    lastDate: Jalali(1450, 9),
  );
  if (selectedDateTime == null) {
    openSnackbar(
      SnackbarMessage(
        icon: appStateSettings["outlinedIcons"] ? Icons.event_busy_outlined : Icons.event_busy_rounded,
        title: "date-not-selected".tr(),
      ),
    );
    return null;
  }
  TimeOfDay? selectedTime = await showCustomTimePicker(
    context,
    TimeOfDay(
      hour: initialDate.hour,
      minute: initialDate.minute,
    ),
    confirmText: appStateSettings["materialYou"] ? "set-date-time".tr() : "set-date-time".tr().allCaps,
  );
  if (selectedTime == null) {
    openSnackbar(
      SnackbarMessage(
        icon: appStateSettings["outlinedIcons"] ? Icons.timer_off_outlined : Icons.timer_off_rounded,
        title: "time-not-selected".tr(),
      ),
    );
    return null;
  }
  selectedDateTime = selectedDateTime.copy(
    hour: selectedTime.hour,
    minute: selectedTime.minute,
  );
  return Jalali(selectedDateTime.year, selectedDateTime.month, selectedDateTime.day, selectedDateTime.hour, selectedDateTime.minute,
      selectedDateTime.second);
}
