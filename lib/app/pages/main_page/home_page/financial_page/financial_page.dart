import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:esoi/app/models/offline_payment_model.dart';
import 'package:esoi/app/models/payout_model.dart';
import 'package:esoi/app/models/sales_model.dart';
import 'package:esoi/app/models/summary_model.dart';
import 'package:esoi/app/pages/main_page/home_page/payment_status_page/payment_status_page.dart';
import 'package:esoi/app/pages/main_page/home_page/single_course_page/single_content_page/web_view_page.dart';
import 'package:esoi/app/providers/user_provider.dart';
import 'package:esoi/app/services/user_service/financial_service.dart';
import 'package:esoi/app/widgets/main_widget/financial_widget.dart/financial_widget.dart';
import 'package:esoi/common/common.dart';
import 'package:esoi/common/components.dart';
import 'package:esoi/common/data/api_public_data.dart';
import 'package:esoi/common/utils/app_text.dart';
import 'package:esoi/common/utils/constants.dart';
import 'package:esoi/locator.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FinancialPage extends StatefulWidget {
  static const String pageName = '/financial';
  const FinancialPage({super.key});

  @override
  State<FinancialPage> createState() => _FinancialPageState();
}

class _FinancialPageState extends State<FinancialPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  SaleModel? saleData;
  SummaryModel? summaryData;
  PayoutModel? payoutData;
  List<OfflinePaymentModel> offlinePayments = [];

  bool isLoadingSummaryData = true;
  bool isLoadingOfflinePaymentData = true;
  bool isLoadingPayoutData = true;
  bool isLoadingSalesData = true;

  bool isLoadingCharge = false;

  late StreamSubscription _sub;
  final appLinks = AppLinks();

  @override
  void initState() {
    super.initState();

    if (locator<UserProvider>().profile?.roleName == PublicData.userRole) {
      tabController = TabController(length: 3, vsync: this);
    } else {
      tabController = TabController(length: 4, vsync: this);
    }

    getSummaryData();
    getOfflinePaymentData();

    if (locator<UserProvider>().profile?.roleName != PublicData.userRole) {
      getSalesData();
    }
    getPayoutData();

    initUniLinks();
  }

  Future<void> initUniLinks() async {
    _sub = appLinks.uriLinkStream.listen((uri) {
      // if(link != null){

      if (uri.path == '${Constants.scheme}://payment-success') {
        getSummaryData();
        nextRoute(PaymentStatusPage.pageName, arguments: 'success');
      } else if (uri.path == '${Constants.scheme}://payment-failed') {
        nextRoute(PaymentStatusPage.pageName, arguments: 'failed');
      }

      // }
    }, onError: (err) {});
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  getSummaryData() async {
    setState(() {
      isLoadingSummaryData = true;
    });

    summaryData = await FinancialService.getSummaryData();

    setState(() {
      isLoadingSummaryData = false;
    });
  }

  getPayoutData() async {
    setState(() {
      isLoadingPayoutData = true;
    });

    payoutData = await FinancialService.getPayoutData();

    setState(() {
      isLoadingPayoutData = false;
    });
  }

  getSalesData() async {
    setState(() {
      isLoadingSalesData = true;
    });

    saleData = await FinancialService.getSalesData();

    setState(() {
      isLoadingSalesData = false;
    });
  }

  getOfflinePaymentData() async {
    setState(() {
      isLoadingOfflinePaymentData = true;
    });

    offlinePayments = await FinancialService.getOfflinePayments();

    setState(() {
      isLoadingOfflinePaymentData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return directionality(
        child: Scaffold(
      appBar: appbar(title: appText.financial),
      body: Column(
        children: [
          tabBar((i) {}, tabController, [
            Tab(text: appText.summary, height: 32),
            Tab(text: appText.offlinePayment, height: 32),
            if (locator<UserProvider>().profile?.roleName !=
                PublicData.userRole) ...{
              Tab(text: appText.sales, height: 32),
            },
            Tab(text: appText.payout, height: 32),
          ]),
          Expanded(
              child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  controller: tabController,
                  children: [
                isLoadingSummaryData
                    ? loading()
                    : FinancialWidget.summaryPage(
                        summaryData, getSummaryData, isLoadingCharge, () async {
                        isLoadingCharge = true;
                        setState(() {});

                        String? link = await FinancialService.webLinkCharge();

                        isLoadingCharge = false;
                        setState(() {});

                        if (link != null) {
                          bool? res = await nextRoute(WebViewPage.pageName,
                              arguments: [
                                link,
                                appText.charge,
                                true,
                                LoadRequestMethod.get
                              ]);

                          if (res ?? false) {
                            getSummaryData();
                          }
                        }
                      }),
                isLoadingOfflinePaymentData
                    ? loading()
                    : FinancialWidget.offlinePaymentPage(offlinePayments),
                if (locator<UserProvider>().profile?.roleName !=
                    PublicData.userRole) ...{
                  isLoadingSalesData
                      ? loading()
                      : FinancialWidget.salesPage(saleData),
                },
                isLoadingPayoutData
                    ? loading()
                    : FinancialWidget.payoutPage(payoutData, getPayoutData),
              ]))
        ],
      ),
    ));
  }
}
