import 'package:budget/colors.dart';
import 'package:budget/database/tables.dart';
import 'package:flutter/material.dart';

List<TransactionCategory> defaultCategories() {
  return [
    // Note "0" categoryPk is reserved for wallet/account total correction category
    TransactionCategory(
      categoryPk: "1",
      name: "رستوران",
      colour: toHexString(Colors.blueGrey),
      iconName: "cutlery.png",
      dateCreated: DateTime.now(),
      dateTimeModified: null,
      order: 0,
      income: false,
    ),
    TransactionCategory(
      categoryPk: "2",
      name: "سوپرمارکت",
      colour: toHexString(Colors.green),
      iconName: "groceries.png",
      dateCreated: DateTime.now(),
      dateTimeModified: null,
      order: 1,
      income: false,
    ),
    TransactionCategory(
      categoryPk: "3",
      name: "خرید",
      colour: toHexString(Colors.pink),
      iconName: "shopping.png",
      dateCreated: DateTime.now(),
      dateTimeModified: null,
      order: 2,
      income: false,
    ),
    TransactionCategory(
      categoryPk: "4",
      name: "حمل و نقل",
      colour: toHexString(Colors.yellow),
      iconName: "tram.png",
      dateCreated: DateTime.now(),
      dateTimeModified: null,
      order: 3,
      income: false,
    ),
    TransactionCategory(
      categoryPk: "5",
      name: "سرگرمی",
      colour: toHexString(Colors.blue),
      iconName: "popcorn.png",
      dateCreated: DateTime.now(),
      dateTimeModified: null,
      order: 4,
      income: false,
    ),
    TransactionCategory(
      categoryPk: "6",
      name: "قبض",
      colour: toHexString(Colors.green),
      iconName: "bills.png",
      dateCreated: DateTime.now(),
      dateTimeModified: null,
      order: 5,
      income: false,
    ),
    // TransactionCategory(
    //   categoryPk: "7,
    //   name: "Education",
    //   colour: toHexString(Colors.blue),
    //   iconName: "graduation.png",
    //   dateCreated: DateTime.now(),
    //   dateTimeModified: null,
    //   order: 6,
    //   income: false,
    // ),
    // TransactionCategory(
    //   categoryPk: "8",
    //   name: "default-category-sports".tr(),
    //   colour: toHexString(Colors.cyan),
    //   iconName: "sports.png",
    //   dateCreated: DateTime.now(),
    //   dateTimeModified: null,
    //   order: 7,
    //   income: false,
    // ),
    TransactionCategory(
      categoryPk: "7",
      name: "هدیه",
      colour: toHexString(Colors.red),
      iconName: "gift.png",
      dateCreated: DateTime.now(),
      dateTimeModified: null,
      order: 6,
      income: false,
    ),
    TransactionCategory(
      categoryPk: "8",
      name: "زیبایی",
      colour: toHexString(Colors.purple),
      iconName: "flower.png",
      dateCreated: DateTime.now(),
      dateTimeModified: null,
      order: 8,
      income: false,
    ),
    TransactionCategory(
      categoryPk: "9",
      name: "کار",
      colour: toHexString(Colors.brown),
      iconName: "briefcase.png",
      dateCreated: DateTime.now(),
      dateTimeModified: null,
      order: 9,
      income: false,
    ),
    TransactionCategory(
      categoryPk: "10",
      name: "مسافرت",
      colour: toHexString(Colors.orange),
      iconName: "plane.png",
      dateCreated: DateTime.now(),
      dateTimeModified: null,
      order: 10,
      income: false,
    ),
    TransactionCategory(
      categoryPk: "11",
      name: "درآمد",
      colour: toHexString(Colors.deepPurple.shade300),
      iconName: "coin.png",
      dateCreated: DateTime.now(),
      dateTimeModified: null,
      order: 11,
      income: true,
    ),
  ];
}
