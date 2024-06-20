import 'package:budget/colors.dart';
import 'package:budget/database/tables.dart';
import 'package:budget/pages/creditDebtTransactionsPage.dart';
import 'package:budget/struct/databaseGlobal.dart';
import 'package:budget/widgets/framework/popupFramework.dart';
import 'package:budget/widgets/navigationFramework.dart';
import 'package:budget/widgets/openBottomSheet.dart';
import 'package:budget/widgets/periodCyclePicker.dart';
import 'package:budget/widgets/util/keepAliveClientMixin.dart';
import 'package:budget/widgets/transactionsAmountBox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageCreditDebts extends StatelessWidget {
  const HomePageCreditDebts({super.key});

  @override
  Widget build(BuildContext context) {
    return KeepAliveClientMixin(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 13, left: 13, right: 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TransactionsAmountBox(
                label: "وام های داده شده",
                absolute: false,
                invertSign: true,
                totalWithCountStream: database.watchTotalWithCountOfCreditDebt(
                  allWallets: Provider.of<AllWallets>(context),
                  isCredit: true,
                  followCustomPeriodCycle: true,
                  cycleSettingsExtension: "CreditDebts",
                  selectedTab: null,
                ),
                totalWithCountStream2: database.watchTotalWithCountOfCreditDebtLongTermLoansOffset(
                  allWallets: Provider.of<AllWallets>(context),
                  isCredit: true,
                  followCustomPeriodCycle: true,
                  cycleSettingsExtension: "CreditDebts",
                  selectedTab: null,
                ),
                textColor: getColor(context, "unPaidUpcoming"),
                openPage: CreditDebtTransactions(isCredit: true),
                onLongPress: () async {
                  await openCreditDebtsSettings(context);
                  homePageStateKey.currentState?.refreshState();
                },
              ),
            ),
            SizedBox(width: 13),
            Expanded(
              child: TransactionsAmountBox(
                label: "وام های گرفته شده",
                absolute: false,
                totalWithCountStream: database.watchTotalWithCountOfCreditDebt(
                  allWallets: Provider.of<AllWallets>(context),
                  isCredit: false,
                  cycleSettingsExtension: "CreditDebts",
                  followCustomPeriodCycle: true,
                  selectedTab: null,
                ),
                totalWithCountStream2: database.watchTotalWithCountOfCreditDebtLongTermLoansOffset(
                  allWallets: Provider.of<AllWallets>(context),
                  isCredit: false,
                  cycleSettingsExtension: "CreditDebts",
                  followCustomPeriodCycle: true,
                  selectedTab: null,
                ),
                textColor: getColor(context, "unPaidOverdue"),
                openPage: CreditDebtTransactions(isCredit: false),
                onLongPress: () async {
                  await openCreditDebtsSettings(context);
                  homePageStateKey.currentState?.refreshState();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future openCreditDebtsSettings(BuildContext context) {
  return openBottomSheet(
    context,
    PopupFramework(
      title: "وام ها",
      subtitle: "این تنظیمات در صفحه خانه اعمال می شود",
      child: PeriodCyclePicker(cycleSettingsExtension: "CreditDebts"),
    ),
  );
}
