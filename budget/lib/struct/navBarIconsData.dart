import 'package:budget/database/tables.dart';
import 'package:budget/functions.dart';
import 'package:budget/struct/settings.dart';
import 'package:budget/widgets/moreIcons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NavBarIconData {
  NavBarIconData({
    required this.iconData,
    required this.label,
    this.labelShort,
    required this.navigationIndexedStackIndex,
    this.labelLong = "",
    this.iconSize = 25,
    this.iconScale = 1,
  });

  IconData iconData;
  String label;
  String? labelShort;
  String labelLong;
  int navigationIndexedStackIndex;
  double iconSize;
  double iconScale;
}

Map<String, NavBarIconData> navBarIconsData = getNavBarIconsData();

Map<String, NavBarIconData> getNavBarIconsData() {
  return {
    "home": NavBarIconData(
      iconData: appStateSettings["outlinedIcons"] ? Icons.home_outlined : Icons.home_rounded,
      label: "خانه",
      navigationIndexedStackIndex: 0,
    ),
    "transactions": NavBarIconData(
      iconData: appStateSettings["outlinedIcons"] ? Icons.payments_outlined : Icons.payments_rounded,
      label: "تراکنش ها",
      navigationIndexedStackIndex: 1,
    ),
    "budgets": NavBarIconData(
      iconData: appStateSettings["outlinedIcons"] ? Icons.donut_small_outlined : MoreIcons.chart_pie,
      iconScale: appStateSettings["outlinedIcons"] ? 1 : 0.87,
      iconSize: appStateSettings["outlinedIcons"] ? 24 : 20,
      label: "بودجه ها",
      navigationIndexedStackIndex: 2,
    ),
    "goals": NavBarIconData(
      iconData: appStateSettings["outlinedIcons"] ? Icons.savings_outlined : Icons.savings_rounded,
      label: "هدف ها",
      labelLong: "spending-and-savings-goals",
      navigationIndexedStackIndex: 14,
    ),
    "subscriptions": NavBarIconData(
      iconData: appStateSettings["outlinedIcons"] ? Icons.event_repeat_outlined : Icons.event_repeat_rounded,
      label: "اشتراک ها",
      navigationIndexedStackIndex: 5,
    ),
    "scheduled": NavBarIconData(
      iconData: getTransactionTypeIcon(TransactionSpecialType.upcoming),
      label: "برنامه",
      navigationIndexedStackIndex: 16,
    ),
    "loans": NavBarIconData(
      iconData: getTransactionTypeIcon(TransactionSpecialType.credit),
      label: "وام ها",
      navigationIndexedStackIndex: 17,
    ),
    "notifications": NavBarIconData(
      iconData: appStateSettings["outlinedIcons"] ? Icons.notifications_outlined : Icons.notifications_rounded,
      label: "اعلان ها",
      navigationIndexedStackIndex: 6,
    ),
    "allSpending": NavBarIconData(
      iconData: appStateSettings["outlinedIcons"] ? Icons.receipt_long_outlined : Icons.receipt_long_rounded,
      // This icon is pretty cool, could suit it
      // ? Icons.data_thresholding_outlined
      // : Icons.data_thresholding_rounded,
      label: "all-spending",
      labelShort: "summary",
      labelLong: "all-spending-summary",
      navigationIndexedStackIndex: 7,
    ),
    "settings": NavBarIconData(
      iconData: appStateSettings["outlinedIcons"] ? Icons.settings_outlined : Icons.settings_rounded,
      label: "تنظیمات",
      labelLong: "settings-and-customization",
      navigationIndexedStackIndex: 4,
    ),
    "more": NavBarIconData(
      iconData: appStateSettings["outlinedIcons"] ? Icons.more_horiz_outlined : Icons.more_horiz_rounded,
      label: "بیشتر",
      navigationIndexedStackIndex: 4,
    ),
    "about": NavBarIconData(
      iconData: appStateSettings["outlinedIcons"] ? Icons.info_outlined : Icons.info_outline_rounded,
      label: "درباره",
      navigationIndexedStackIndex: 13,
    ),
    "accountDetails": NavBarIconData(
      iconData: appStateSettings["outlinedIcons"] ? Icons.account_balance_wallet_outlined : Icons.account_balance_wallet_rounded,
      label: "حساب ها",
      labelLong: "account-details",
      navigationIndexedStackIndex: 9,
    ),
    "budgetDetails": NavBarIconData(
      iconData: appStateSettings["outlinedIcons"] ? Icons.donut_small_outlined : MoreIcons.chart_pie,
      label: "بودجه ها",
      labelLong: "budgets-details",
      navigationIndexedStackIndex: 10,
      iconScale: appStateSettings["outlinedIcons"] ? 1 : 0.83,
    ),
    "categoriesDetails": NavBarIconData(
      iconData: appStateSettings["outlinedIcons"] ? Icons.category_outlined : Icons.category_rounded,
      label: "دسته ها",
      labelLong: "categories-details",
      navigationIndexedStackIndex: 11,
    ),
    "titlesDetails": NavBarIconData(
      iconData: appStateSettings["outlinedIcons"] ? Icons.text_fields_outlined : Icons.text_fields_rounded,
      label: "سرتیترها",
      labelLong: "titles-details",
      navigationIndexedStackIndex: 12,
    ),
    "goalsDetails": NavBarIconData(
      iconData: appStateSettings["outlinedIcons"] ? Icons.savings_outlined : Icons.savings_rounded,
      label: "اهداف",
      labelLong: "goals-details",
      navigationIndexedStackIndex: 15,
    ),
  };
}
