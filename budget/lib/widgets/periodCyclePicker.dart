import 'package:budget/database/tables.dart';
import 'package:budget/functions.dart';
import 'package:budget/pages/addBudgetPage.dart';
import 'package:budget/struct/settings.dart';
import 'package:budget/widgets/framework/popupFramework.dart';
import 'package:budget/widgets/openBottomSheet.dart';
import 'package:budget/widgets/outlinedButtonStacked.dart';
import 'package:budget/widgets/radioItems.dart';
import 'package:budget/widgets/selectAmount.dart';
import 'package:budget/widgets/tappable.dart';
import 'package:budget/widgets/tappableTextEntry.dart';
import 'package:budget/widgets/textWidgets.dart';
import 'package:budget/widgets/util/showDatePicker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:budget/colors.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:flutter/material.dart' as material;

import 'selectDateRange.dart';

enum CycleType {
  allTime,
  dateRange, // e.g. September 10 to present day
  pastDays, // e.g. last 10 days
  cycle, //e.g. every 1 month starting Sept 13
}

class PeriodCyclePicker extends StatefulWidget {
  const PeriodCyclePicker({
    required this.cycleSettingsExtension,
    this.onlyShowCycleOption = false,
    super.key,
  });
  final String cycleSettingsExtension;
  final bool onlyShowCycleOption;

  @override
  State<PeriodCyclePicker> createState() => _PeriodCyclePickerState();
}

class _PeriodCyclePickerState extends State<PeriodCyclePicker> {
  late CycleType selectedCycle = CycleType.values[appStateSettings["selectedPeriodCycleType" + widget.cycleSettingsExtension] ?? 0];
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: material.TextDirection.rtl,
      child: Column(
        children: [
          if (widget.onlyShowCycleOption == false)
            CycleTypeEntry(
              cycleSettingsExtension: widget.cycleSettingsExtension,
              title: "تمام زمان ها",
              icon: appStateSettings["outlinedIcons"] ? Icons.apps_outlined : Icons.apps_rounded,
              cycle: CycleType.allTime,
              onTap: () {
                setState(() {
                  selectedCycle = CycleType.allTime;
                });
              },
              selectedCycle: selectedCycle,
            ),
          CycleTypeEntry(
            cycleSettingsExtension: widget.cycleSettingsExtension,
            title: "دوره",
            icon: appStateSettings["outlinedIcons"] ? Icons.timelapse_outlined : Icons.timelapse_rounded,
            cycle: CycleType.cycle,
            onTap: () {
              setState(() {
                selectedCycle = CycleType.cycle;
              });
            },
            extraWidget: CyclePeriodSelection(
              cycleSettingsExtension: widget.cycleSettingsExtension,
              selected: widget.onlyShowCycleOption ? true : selectedCycle == CycleType.cycle,
            ),
            selectedCycle: widget.onlyShowCycleOption ? CycleType.cycle : selectedCycle,
          ),
          if (widget.onlyShowCycleOption == false)
            CycleTypeEntry(
              cycleSettingsExtension: widget.cycleSettingsExtension,
              title: "چند روز گذشته",
              icon: appStateSettings["outlinedIcons"] ? Icons.today_outlined : Icons.today_rounded,
              cycle: CycleType.pastDays,
              onTap: () {
                setState(() {
                  selectedCycle = CycleType.pastDays;
                });
              },
              selectedCycle: selectedCycle,
              extraWidget: PastDaysSelection(
                cycleSettingsExtension: widget.cycleSettingsExtension,
              ),
            ),
          if (widget.onlyShowCycleOption == false)
            CycleTypeEntry(
              cycleSettingsExtension: widget.cycleSettingsExtension,
              title: "بازه تاریخ",
              icon: appStateSettings["outlinedIcons"] ? Icons.date_range_outlined : Icons.date_range_rounded,
              cycle: CycleType.dateRange,
              onTap: () {
                setState(() {
                  selectedCycle = CycleType.dateRange;
                });
              },
              extraWidget: SelectDateRange(
                initialStartDate: DateTime.tryParse(appStateSettings["customPeriodStartDate" + widget.cycleSettingsExtension]),
                onSelectedStartDate: (DateTime? selectedStartDate) {
                  updateSettings("customPeriodStartDate" + widget.cycleSettingsExtension,
                      (selectedStartDate != null ? selectedStartDate : DateTime.now()).toString(),
                      updateGlobalState: false);
                },
                initialEndDate: DateTime.tryParse(appStateSettings["customPeriodEndDate" + widget.cycleSettingsExtension]),
                onSelectedEndDate: (DateTime? selectedEndDate) {
                  updateSettings("customPeriodEndDate" + widget.cycleSettingsExtension,
                      (selectedEndDate != null ? selectedEndDate : DateTime.now()).toString(),
                      updateGlobalState: false);
                },
              ),
              selectedCycle: selectedCycle,
            ),
        ],
      ),
    );
  }
}

class CycleTypeEntry extends StatelessWidget {
  const CycleTypeEntry({
    super.key,
    required this.title,
    required this.icon,
    this.extraWidget,
    required this.onTap,
    required this.cycle,
    required this.selectedCycle,
    required this.cycleSettingsExtension,
  });

  final String title;
  final IconData icon;
  final Widget? extraWidget;
  final VoidCallback onTap;
  final CycleType cycle;
  final CycleType selectedCycle;
  final String cycleSettingsExtension;

  @override
  Widget build(BuildContext context) {
    bool isSelected = cycle == selectedCycle;
    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: isSelected ? 1 : 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButtonStacked(
                filled: isSelected,
                alignLeft: true,
                alignBeside: true,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                text: title,
                iconData: icon,
                onTap: () {
                  onTap();
                  updateSettings("selectedPeriodCycleType" + cycleSettingsExtension, cycle.index, updateGlobalState: false);
                },
                afterWidget: extraWidget == null
                    ? null
                    : IgnorePointer(
                        ignoring: !isSelected,
                        child: extraWidget,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CyclePeriodSelection extends StatefulWidget {
  const CyclePeriodSelection({
    super.key,
    required this.cycleSettingsExtension,
    required this.selected,
  });
  final String cycleSettingsExtension;
  final bool selected;
  @override
  State<CyclePeriodSelection> createState() => _CyclePeriodSelectionState();
}

class _CyclePeriodSelectionState extends State<CyclePeriodSelection> {
  late int selectedPeriodLength;
  late DateTime selectedStartDate;
  late DateTime? selectedEndDate;
  late String selectedRecurrence;
  String selectedRecurrenceDisplay = "month";
  @override
  void initState() {
    selectedPeriodLength = appStateSettings["cyclePeriodLength" + widget.cycleSettingsExtension] ?? 1;
    selectedStartDate = DateTime.tryParse(appStateSettings["cycleStartDate" + widget.cycleSettingsExtension]) ?? DateTime.now();
    selectedRecurrence =
        enumRecurrence[BudgetReoccurence.values[appStateSettings["cycleReoccurrence" + widget.cycleSettingsExtension]]] ?? "Monthly";

    if (selectedPeriodLength == 1) {
      selectedRecurrenceDisplay = nameRecurrence[selectedRecurrence];
    } else {
      selectedRecurrenceDisplay = namesRecurrence[selectedRecurrence];
    }
    super.initState();
  }

  Future<void> selectPeriodLength(BuildContext context) async {
    openBottomSheet(
      context,
      PopupFramework(
        title: "ورود طول دوره",
        child: SelectAmountValue(
          enableDecimal: false,
          amountPassed: selectedPeriodLength.toString(),
          setSelectedAmount: (amount, _) {
            setSelectedPeriodLength(amount);
          },
          next: () async {
            Navigator.pop(context);
          },
          nextLabel: "ثبت طول دوره",
        ),
      ),
    );
  }

  void setSelectedPeriodLength(double period) {
    try {
      setState(() {
        selectedPeriodLength = period.toInt();
        if (selectedPeriodLength == 0) {
          selectedPeriodLength = 1;
        }
        if (selectedPeriodLength == 1) {
          selectedRecurrenceDisplay = nameRecurrence[selectedRecurrence];
        } else {
          selectedRecurrenceDisplay = namesRecurrence[selectedRecurrence];
        }
      });
    } catch (e) {
      setState(() {
        selectedPeriodLength = 1;
        if (selectedPeriodLength == 1) {
          selectedRecurrenceDisplay = nameRecurrence[selectedRecurrence];
        } else {
          selectedRecurrenceDisplay = namesRecurrence[selectedRecurrence];
        }
      });
    }
    updateSettings("cyclePeriodLength" + widget.cycleSettingsExtension, selectedPeriodLength, updateGlobalState: false);
    return;
  }

  Future<void> selectRecurrence(BuildContext context) async {
    openBottomSheet(
      context,
      Directionality(
        textDirection: material.TextDirection.rtl,
        child: PopupFramework(
          title: "انتخاب نوع دوره",
          child: RadioItems(
            items: ["Daily", "Weekly", "Monthly", "Yearly"],
            initial: selectedRecurrence,
            displayFilter: (item) {
              switch (item) {
                case "Daily":
                  return 'روز';
                case "Weekly":
                  return 'هفته';
                case "Monthly":
                  return 'ماه';
                default:
                  return "سال";
              }
            },
            onChanged: (value) {
              setState(() {
                selectedRecurrence = value;
                updateSettings("cycleReoccurrence" + widget.cycleSettingsExtension, enumRecurrence[value].index,
                    updateGlobalState: false);
                if (selectedPeriodLength == 1) {
                  selectedRecurrenceDisplay = nameRecurrence[value];
                } else {
                  selectedRecurrenceDisplay = namesRecurrence[value];
                }
              });
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showCustomDatePicker(context, selectedStartDate);
    setSelectedStartDate(picked);
  }

  setSelectedStartDate(DateTime? date) {
    if (date != null && date != selectedStartDate) {
      updateSettings("cycleStartDate" + widget.cycleSettingsExtension, date.toString(), updateGlobalState: false);
      setState(() {
        selectedStartDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            alignment: WrapAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 15,
                  right: 10,
                  left: 10,
                ),
                child: TextFont(
                  text: "هر",
                  fontSize: 20,
                ),
              ),
              IntrinsicWidth(
                child: Row(
                  children: [
                    TappableTextEntry(
                      title: selectedPeriodLength.toString().toPersianDigit(),
                      placeholder: "0".toPersianDigit(),
                      showPlaceHolderWhenTextEquals: "0".toPersianDigit(),
                      onTap: () {
                        selectPeriodLength(context);
                      },
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      internalPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 9),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                    ),
                    TappableTextEntry(
                      title: selectedRecurrenceDisplay.toString().toLowerCase().tr().toLowerCase(),
                      placeholder: "",
                      onTap: () {
                        selectRecurrence(context);
                      },
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      internalPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Tappable(
            onTap: () {
              selectStartDate(context);
            },
            color: Colors.transparent,
            borderRadius: 15,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              child: Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  runAlignment: WrapAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.8),
                      child: TextFont(
                        text: "شروع" + " ",
                        fontSize: 20,
                      ),
                    ),
                    IgnorePointer(
                      child: TappableTextEntry(
                        title: getWordedDateShortMore(Jalali.fromDateTime(selectedStartDate)),
                        placeholder: "",
                        onTap: () {},
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        internalPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Builder(builder: (context) {
          DateTimeRange budgetRange = getBudgetDate(
            Budget(
              startDate: selectedStartDate,
              periodLength: selectedPeriodLength,
              reoccurrence: enumRecurrence[selectedRecurrence],
              budgetPk: "-1",
              name: "",
              amount: 0,
              endDate: DateTime.now(),
              addedTransactionsOnly: false,
              dateCreated: DateTime.now(),
              pinned: false,
              order: -1,
              walletFk: "",
              isAbsoluteSpendingLimit: false,
              income: false,
              archived: false,
            ),
            DateTime.now(),
          );
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 0,
              top: 15,
            ),
            child: TextFont(
              text: "(" +
                  getWordedDateShortMore(Jalali.fromDateTime(budgetRange.start), includeYear: true) +
                  " - " +
                  getWordedDateShortMore(Jalali.fromDateTime(budgetRange.end), includeYear: true) +
                  ")",
              fontSize: 16,
              maxLines: 3,
              textColor: Theme.of(context).brightness == Brightness.dark && appStateSettings["materialYou"] == false && widget.selected
                  ? getColor(context, "black").withOpacity(0.5) //Fix contrast when selected and not material you and dark mode
                  : getColor(context, "textLight"),
              textAlign: TextAlign.center,
            ),
          );
        }),
      ],
    );
  }
}

Budget getCustomCycleTempBudget(String cycleSettingsExtension) {
  return Budget(
    startDate: DateTime.tryParse(appStateSettings["cycleStartDate" + cycleSettingsExtension] ?? "") ?? DateTime.now(),
    periodLength: appStateSettings["cyclePeriodLength" + cycleSettingsExtension] ?? 1,
    reoccurrence: BudgetReoccurence.values[appStateSettings["cycleReoccurrence" + cycleSettingsExtension] ?? 0],
    budgetPk: "-1",
    name: "",
    amount: 0,
    endDate: DateTime.now(),
    addedTransactionsOnly: false,
    dateCreated: DateTime.now(),
    pinned: false,
    order: -1,
    walletFk: "",
    isAbsoluteSpendingLimit: false,
    income: false,
    archived: false,
  );
}

DateTime getCycleDatePastToDetermineBudgetDate(String cycleSettingsExtension, int index) {
  return getDatePastToDetermineBudgetDate(
    index,
    getCustomCycleTempBudget(cycleSettingsExtension),
  );
}

DateTimeRange getCycleDateTimeRange(String cycleSettingsExtension, {DateTime? currentDate}) {
  return getBudgetDate(
    getCustomCycleTempBudget(cycleSettingsExtension),
    currentDate ?? DateTime.now(),
  );
}

DateTime? getStartDateOfSelectedCustomPeriod(
  String cycleSettingsExtension, {
  DateTimeRange? forcedDateTimeRange,
}) {
  if (forcedDateTimeRange != null) {
    return forcedDateTimeRange.start;
  }
  CycleType selectedPeriodType = CycleType.values[appStateSettings["selectedPeriodCycleType" + cycleSettingsExtension] ?? 0];
  if (selectedPeriodType == CycleType.allTime) {
    return null;
  } else if (selectedPeriodType == CycleType.cycle) {
    DateTimeRange budgetRange = getCycleDateTimeRange(cycleSettingsExtension);
    DateTime startDate = DateTime(budgetRange.start.year, budgetRange.start.month, budgetRange.start.day);
    return startDate;
  } else if (selectedPeriodType == CycleType.pastDays) {
    DateTime startDate =
        DateTime.now().subtract(Duration(days: (appStateSettings["customPeriodPastDays" + cycleSettingsExtension] ?? 0)));
    if (startDate.year <= 1900) return DateTime(1900);
    if (startDate.isAfter(DateTime.now())) return DateTime(1900);
    return startDate;
  } else if (selectedPeriodType == CycleType.dateRange) {
    DateTime startDate = DateTime.tryParse(appStateSettings["customPeriodStartDate" + cycleSettingsExtension] ?? "") ?? DateTime.now();
    return startDate;
  }
  return null;
}

DateTime? getEndDateOfSelectedCustomPeriod(
  String cycleSettingsExtension, {
  DateTimeRange? forcedDateTimeRange,
}) {
  if (forcedDateTimeRange != null) {
    return forcedDateTimeRange.end;
  }

  CycleType selectedPeriodType = CycleType.values[appStateSettings["selectedPeriodCycleType" + cycleSettingsExtension] ?? 0];

  // If it is a cycle, we want the end date to be null (display everything up to today!)
  // Therefore, do not add this code in!
  if (selectedPeriodType == CycleType.cycle) {
    DateTimeRange budgetRange = getCycleDateTimeRange(cycleSettingsExtension);
    DateTime endDate = DateTime(budgetRange.end.year, budgetRange.end.month, budgetRange.end.day);
    return endDate;
  }

  if (selectedPeriodType == CycleType.pastDays) {
    DateTime endDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return endDate;
  }

  if (selectedPeriodType == CycleType.dateRange) {
    DateTime? endDate = DateTime.tryParse(appStateSettings["customPeriodEndDate" + cycleSettingsExtension] ?? "");
    return endDate == null ? null : DateTime(endDate.year, endDate.month, endDate.day, 23, 59);
  }
  return null;
}

String getLabelOfSelectedCustomPeriod(String cycleSettingsExtension) {
  CycleType selectedPeriodType = CycleType.values[appStateSettings["selectedPeriodCycleType" + cycleSettingsExtension] ?? 0];
  if (selectedPeriodType == CycleType.allTime) {
    return "تمام زمان ها";
  } else if (selectedPeriodType == CycleType.cycle) {
    DateTimeRange dateRange = getCycleDateTimeRange(cycleSettingsExtension);
    return getWordedDateShort(Jalali.fromDateTime(dateRange.start)) + " – " + getWordedDateShort(Jalali.fromDateTime(dateRange.end));
  } else if (selectedPeriodType == CycleType.pastDays) {
    int days = appStateSettings["customPeriodPastDays" + cycleSettingsExtension] ?? 1;
    return days.toString().toPersianDigit() + " روز گذشته";
  } else if (selectedPeriodType == CycleType.dateRange) {
    DateTime startDate = getStartDateOfSelectedCustomPeriod(cycleSettingsExtension) ?? DateTime.now();
    DateTime? endDate = getEndDateOfSelectedCustomPeriod(cycleSettingsExtension);
    return getWordedDateShort(Jalali.fromDateTime(startDate)) +
        (endDate == null ? " تا همیشه" : (" – " + getWordedDateShort(Jalali.fromDateTime(endDate))));
  }
  return "";
}

class PastDaysSelection extends StatefulWidget {
  const PastDaysSelection({super.key, required this.cycleSettingsExtension});
  final String cycleSettingsExtension;
  @override
  State<PastDaysSelection> createState() => _PastDaysSelectionState();
}

class _PastDaysSelectionState extends State<PastDaysSelection> {
  late int selectedPeriodLength;

  @override
  void initState() {
    selectedPeriodLength = appStateSettings["customPeriodPastDays" + widget.cycleSettingsExtension] ?? 1;
    super.initState();
  }

  Future<void> selectPeriodLength(BuildContext context) async {
    openBottomSheet(
      context,
      PopupFramework(
        title: "ورود طول دوره",
        child: SelectAmountValue(
          enableDecimal: false,
          amountPassed: selectedPeriodLength.toString(),
          setSelectedAmount: (amount, _) {
            setSelectedPeriodLength(amount);
          },
          next: () async {
            Navigator.pop(context);
          },
          nextLabel: "ثبت طول دوره",
        ),
      ),
    );
  }

  void setSelectedPeriodLength(double period) {
    try {
      setState(() {
        selectedPeriodLength = period.toInt();
        if (selectedPeriodLength == 0) {
          selectedPeriodLength = 1;
        }
      });
    } catch (e) {
      setState(() {
        selectedPeriodLength = 0;
      });
    }
    updateSettings("customPeriodPastDays" + widget.cycleSettingsExtension, selectedPeriodLength, updateGlobalState: false);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: TappableTextEntry(
                  title: selectedPeriodLength.toString().toPersianDigit(),
                  placeholder: "0".toPersianDigit(),
                  showPlaceHolderWhenTextEquals: "0".toPersianDigit(),
                  onTap: () {
                    selectPeriodLength(context);
                  },
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  internalPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 9),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                ),
              ),
              TextFont(
                text: "روز گذشته",
                fontSize: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
