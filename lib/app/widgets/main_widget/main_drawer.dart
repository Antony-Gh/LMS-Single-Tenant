import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:esoi/app/pages/authentication_page/login_page.dart';
import 'package:esoi/app/pages/main_page/home_page/assignments_page/assignments_page.dart';
import 'package:esoi/app/pages/main_page/home_page/meetings_page/meetings_page.dart';
import 'package:esoi/app/pages/main_page/home_page/setting_page/setting_page.dart';
import 'package:esoi/app/providers/app_language_provider.dart';
import 'package:esoi/app/providers/page_provider.dart';
import 'package:esoi/app/providers/theme_provider.dart';
import 'package:esoi/app/providers/user_provider.dart';
import 'package:esoi/app/services/user_service/user_service.dart';
import 'package:esoi/locator.dart';
import 'package:esoi/app/services/authentication_service/authentication_service.dart';
import 'package:esoi/app/widgets/authentication_widget/auth_widget.dart';
import 'package:esoi/app/widgets/main_widget/main_widget.dart';
import 'package:esoi/common/common.dart';
import 'package:esoi/common/components.dart';
import 'package:esoi/common/data/app_data.dart';
import 'package:esoi/common/data/app_language.dart';
import 'package:esoi/common/database/app_database.dart';
import 'package:esoi/common/enums/error_enum.dart';
import 'package:esoi/common/enums/page_name_enum.dart';
import 'package:esoi/common/utils/app_text.dart';
import 'package:esoi/common/utils/currency_utils.dart';
import 'package:esoi/config/assets.dart';
import 'package:esoi/config/styles.dart';
import 'package:esoi/locator.dart';

import '../../../common/utils/object_instance.dart';
import '../../pages/main_page/home_page/quizzes_page/quizzes_page.dart';
import '../../pages/main_page/home_page/support_message_page/support_message_page.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String token = '';

  @override
  void initState() {
    super.initState();

    getToken();
  }

  getToken() {
    AppData.getAccessToken().then((value) {
      setState(() {
        token = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppLanguageProvider>(builder: (context, provider, _) {
      getToken();

      return directionality(
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: const EdgeInsetsDirectional.only(start: 21),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // user Profile
                    Consumer<UserProvider>(builder: (context, userProiver, _) {
                      return Container(
                        margin: EdgeInsetsDirectional.only(
                          top: getSize().height * .12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // user image
                            GestureDetector(
                              onTap: () {
                                if (hasAccess()) {
                                  nextRoute(SettingPage.pageName);
                                }
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ClipRRect(
                                    borderRadius: borderRadius(radius: 65),
                                    child: token.isEmpty
                                        ? Container(
                                            width: 65,
                                            height: 65,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle),
                                            child: SvgPicture.asset(
                                              AppAssets.splashLogoSvg,
                                              width: 65,
                                              height: 65,
                                            ),
                                          )
                                        : Image.network(
                                            userProiver.profile?.avatar ?? '',
                                            width: 65,
                                            height: 65,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                  AppAssets.placePng,
                                                  width: 65,
                                                  height: 65,
                                                  fit: BoxFit.cover);
                                            },
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  if (token.isNotEmpty) ...{
                                    PositionedDirectional(
                                      bottom: -3,
                                      end: -3,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                            AppAssets.settingSvg),
                                      ),
                                    )
                                  }
                                ],
                              ),
                            ),

                            space(12),

                            // name
                            Text(
                              userProiver.profile?.fullName ?? appText.webinar,
                              style:
                                  style16Bold().copyWith(color: Colors.white),
                            ),

                            space(3),

                            Container(
                              width: 25,
                              height: 3,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: borderRadius()),
                            )
                          ],
                        ),
                      );
                    }),

                    Expanded(
                        child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          space(15),
                          menuItem(appText.dashboard, AppAssets.dashboardSvg, () {
                            if (locator<PageProvider>().page !=
                                PageNames.home) {
                              locator<PageProvider>().setPage(PageNames.home);
                            }

                            drawerController.hideDrawer();
                          }),
                          menuItem(appText.classes, AppAssets.classesSvg, () {
                            if (hasAccess(canRedirect: true)) {
                              if (locator<PageProvider>().page !=
                                  PageNames.myClasses) {
                                locator<PageProvider>()
                                    .setPage(PageNames.myClasses);
                              }

                              drawerController.hideDrawer();
                            }
                          }),
                          menuItem(appText.meetings, AppAssets.meetingsSvg, () {
                            if (hasAccess(canRedirect: true)) {
                              nextRoute(MeetingsPage.pageName);
                            }
                          }),
                          menuItem(
                              appText.assignments, AppAssets.assignmentsSvg,
                              () {
                            if (hasAccess(canRedirect: true)) {
                              nextRoute(AssignmentsPage.pageName);
                            }
                          }),
                          menuItem(appText.quizzes, AppAssets.quizzesSvg, () {
                            if (hasAccess(canRedirect: true)) {
                              nextRoute(QuizzesPage.pageName);
                            }
                          }),
                          menuItem(appText.support, AppAssets.supportSvg, () {
                            if (hasAccess(canRedirect: true)) {
                              nextRoute(SupportMessagePage.pageName);
                            }
                          }),
                          menuItem(appText.settings, AppAssets.settingSvg, () {
                            if (hasAccess(canRedirect: true)) {
                              nextRoute(SettingPage.pageName);
                            }
                          }),
                          space(10),
                        ],
                      ),
                    )),

                    space(10),

                    Builder(builder: (context) {
                      return Row(
                        children: [
                          Text(
                            appText.darkMode,
                            style:
                                style14Regular().copyWith(color: Colors.white),
                          ),
                          const Spacer(),
                          switchButton(
                              '', !locator<ThemeProvider>().isLightMode,
                              (value) {
                            locator<ThemeProvider>().setTheme(value);
                            setState(() {});
                          }),
                          const Spacer(),
                        ],
                      );
                    }),

                    space(5),

                    Container(
                      width: getSize().width,
                      margin: const EdgeInsets.only(bottom: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // login + language
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // language
                              GestureDetector(
                                onTap: () async {
                                  MainWidget.showLanguageDialog();
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipRRect(
                                      borderRadius: borderRadius(),
                                      child: Image.asset(
                                        '${AppAssets.flags}${locator<AppLanguage>().currentLanguage}.png',
                                        width: 21,
                                        height: 20,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    space(0, width: 6),
                                    Text(
                                      locator<AppLanguage>()
                                              .appLanguagesData[
                                                  locator<AppLanguage>()
                                                      .appLanguagesData
                                                      .indexWhere((element) =>
                                                          element.code!
                                                              .toLowerCase() ==
                                                          locator<AppLanguage>()
                                                              .currentLanguage
                                                              .toLowerCase())]
                                              .name ??
                                          '',
                                      style: style12Regular()
                                          .copyWith(color: Colors.white),
                                    ),
                                    space(0, width: 6),
                                    Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white.withOpacity(.6),
                                    )
                                  ],
                                ),
                              ),

                              // line
                              Container(
                                margin: padding(horizontal: 8),
                                width: 1.5,
                                height: 18,
                                color: Colors.white.withOpacity(.5),
                              ),

                              GestureDetector(
                                onTap: () async {
                                  if (token.isNotEmpty) {
                                    drawerController.hideDrawer();

                                    // logout
                                    locator<AuthenticationService>().logout();
                                    await Future.delayed(
                                        const Duration(milliseconds: 200));

                                    await AppData.saveCurrency('');
                                    AppData.saveAccessToken('');
                                    AppDataBase.clearBox();

                                    locator<UserProvider>().clearAll();
                                    locator<AppLanguageProvider>()
                                        .changeState();
                                  } else {
                                    AppData.saveAccessToken('');
                                    nextRoute(LoginPage.pageName,
                                        isClearBackRoutes: true);
                                  }
                                },
                                behavior: HitTestBehavior.opaque,
                                child: SizedBox(
                                  height: 35,
                                  width: 45,
                                  child: Center(
                                    child: Text(
                                      token.isNotEmpty
                                          ? appText.logOut
                                          : appText.login,
                                      style: style12Regular().copyWith(
                                          color: Colors.white, height: .8),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),

                          space(12),

                          if (token.isNotEmpty &&
                              (PublicData.apiConfigData?['multi_currency'] ??
                                  false)) ...{
                            // currency
                            GestureDetector(
                              onTap: () {
                                MainWidget.showCurrencyDialog();
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 21,
                                    height: 21,
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(.2),
                                        borderRadius: borderRadius(radius: 5)),
                                    alignment: Alignment.center,
                                    child: Text(
                                      CurrencyUtils.getSymbol(
                                          CurrencyUtils.userCurrency),
                                      style: style12Regular().copyWith(
                                          color: Colors.white, height: 1),
                                    ),
                                  ),
                                  space(0, width: 6),
                                  Text(
                                    CurrencyUtils.userCurrency,
                                    style: style12Regular()
                                        .copyWith(color: Colors.white),
                                  ),
                                  space(0, width: 6),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Colors.white.withOpacity(.6),
                                  )
                                ],
                              ),
                            ),
                          }
                        ],
                      ),
                    )
                  ],
                ),
              )));
    });
  }

  bool hasAccess({bool canRedirect = false}) {
    if (token.isEmpty) {
      showSnackBar(ErrorEnum.alert, appText.youHaveNotAccess);
      if (canRedirect) {
        nextRoute(LoginPage.pageName, isClearBackRoutes: true);
      }
      return false;
    } else {
      return true;
    }
  }

  Widget menuItem(String name, String iconPath, Function onTap,
      {Color textColor = Colors.white}) {
    return Container(
      width: getSize().width,
      margin: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              colorFilter: textColor != Colors.white
                  ? ColorFilter.mode(textColor, BlendMode.srcIn)
                  : null,
            ),
            space(0, width: 8),
            Text(
              name,
              style: style16Regular().copyWith(color: textColor),
            )
          ],
        ),
      ),
    );
  }
}
