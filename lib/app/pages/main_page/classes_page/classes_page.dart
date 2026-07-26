import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:esoi/app/models/purchase_course_model.dart';
import 'package:esoi/app/pages/authentication_page/login_page.dart';
import 'package:esoi/app/pages/main_page/classes_page/course_overview_page.dart';
import 'package:esoi/app/providers/drawer_provider.dart';
import 'package:esoi/app/providers/theme_provider.dart';
import 'package:esoi/app/providers/user_provider.dart';
import 'package:esoi/app/services/user_service/user_service.dart';
import 'package:esoi/app/widgets/main_widget/classes_widget/classes_widget.dart';
import 'package:esoi/common/common.dart';
import 'package:esoi/common/components.dart';
import 'package:esoi/common/data/app_data.dart';
import 'package:esoi/common/shimmer_component.dart';
import 'package:esoi/common/utils/app_text.dart';
import 'package:esoi/common/utils/object_instance.dart';
import 'package:esoi/config/assets.dart';
import 'package:esoi/config/colors.dart';
import 'package:esoi/locator.dart';

import '../../../models/course_model.dart';
import '../../../providers/app_language_provider.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({super.key});

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage>
    with TickerProviderStateMixin {
  late TabController tabController;

  bool isLoading = false;

  List<CourseModel> myClasses = [];
  List<PurchaseCourseModel> purchases = [];
  List<CourseModel> invitations = [];

  bool hasLogin = false;

  @override
  void initState() {
    super.initState();

    AppData.getAccessToken().then((value) {
      hasLogin = value.isNotEmpty;
      if (mounted) {
        setState(() {});
      }
    });

    tabController = TabController(
        length: locator<UserProvider>().profile?.roleName == 'user' ? 1 : 3,
        vsync: this);
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });

    if (locator<UserProvider>().profile?.roleName != 'user') {
      var data = await locator<UserService>().getTeacherClassess();

      myClasses = data.$1;
      purchases = data.$2;
      invitations = data.$3;
    } else {
      purchases = await locator<UserService>().getPurchaseCourse();
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppLanguageProvider>(builder: (context, provider, _) {
      return directionality(child:
          Consumer<DrawerProvider>(builder: (context, drawerProvider, _) {
        context.watch<ThemeProvider>();

        return ClipRRect(
          borderRadius:
              borderRadius(radius: drawerProvider.isOpenDrawer ? 20 : 0),
          child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: appbar(
                title: appText.classes,
                leftIcon: AppAssets.menuSvg,
                onTapLeftIcon: () {
                  drawerController.showDrawer();
                }),
            body: !hasLogin
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      emptyState(AppAssets.loginEmptyStateSvg, appText.login,
                          appText.loginDesc,
                          isBottomPadding: false),
                      space(16, width: getSize().width),
                      button(
                          onTap: () {
                            nextRoute(LoginPage.pageName,
                                isClearBackRoutes: true);
                          },
                          width: getSize().width * .65,
                          height: 52,
                          text: appText.login,
                          bgColor: green77(),
                          textColor: Colors.white,
                          raduis: 16),
                      space(getSize().height * .15),
                    ],
                  )
                : NestedScrollView(
                    physics: const BouncingScrollPhysics(),
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          pinned: true,
                          centerTitle: true,
                          automaticallyImplyLeading: false,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          shadowColor: Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(.2),
                          elevation: 10,
                          titleSpacing: 0,
                          title: tabBar((i) {}, tabController, [
                            Tab(
                              text: appText.purchased,
                              height: 32,
                            ),
                            if (locator<UserProvider>().profile?.roleName !=
                                'user') ...{
                              Tab(
                                text: appText.myClassess,
                                height: 32,
                              ),
                            },
                            if (locator<UserProvider>().profile?.roleName !=
                                'user') ...{
                              Tab(
                                text: appText.invited,
                                height: 32,
                              ),
                            },
                          ]),
                        )
                      ];
                    },
                    body: TabBarView(
                        physics: const BouncingScrollPhysics(),
                        controller: tabController,
                        children: [
                          // purchased
                          !isLoading && purchases.isEmpty
                              ? Center(
                                  child: emptyState(
                                      AppAssets.noCourseEmptyStateSvg,
                                      appText.noCourses,
                                      appText.noCourseClassesDesc),
                                )
                              : SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  padding: padding(),
                                  child: Column(
                                    children: [
                                      ...List.generate(
                                          isLoading ? 3 : purchases.length,
                                          (index) {
                                        return isLoading
                                            ? classesCourseItemShimmer()
                                            : ClassessWidget.classesItem(
                                                purchases[index].webinar == null
                                                    ? purchases[index].bundle ??
                                                        CourseModel()
                                                    : purchases[index]
                                                            .webinar ??
                                                        CourseModel(),
                                                expired:
                                                    purchases[index].expired ??
                                                        false,
                                                expiredDate: (purchases[index]
                                                        .expiredAt ??
                                                    0));
                                      }),
                                      space(110),
                                    ],
                                  ),
                                ),

                          // myClasses
                          if (locator<UserProvider>().profile?.roleName !=
                              'user') ...{
                            !isLoading && myClasses.isEmpty
                                ? Center(
                                    child: emptyState(
                                        AppAssets.noCourseEmptyStateSvg,
                                        appText.noCourses,
                                        appText.noCourseClassesDesc),
                                  )
                                : SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    padding: padding(),
                                    child: Column(
                                      children: [
                                        ...List.generate(
                                            isLoading ? 3 : myClasses.length,
                                            (index) {
                                          return isLoading
                                              ? classesCourseItemShimmer()
                                              : ClassessWidget.classesItem(
                                                  myClasses[index], onTap: () {
                                                  nextRoute(
                                                      CourseOverviewPage
                                                          .pageName,
                                                      arguments: [
                                                        myClasses[index].id,
                                                        myClasses[index].type ==
                                                            'bundle',
                                                        myClasses[index]
                                                                .isPrivate ==
                                                            1
                                                      ]);
                                                });
                                        }),
                                        space(110),
                                      ],
                                    ),
                                  ),
                          },

                          if (locator<UserProvider>().profile?.roleName !=
                              'user') ...{
                            // invitations
                            !isLoading && invitations.isEmpty
                                ? Center(
                                    child: emptyState(
                                        AppAssets.noCourseEmptyStateSvg,
                                        appText.noCourses,
                                        appText.noCourseClassesDesc),
                                  )
                                : SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    padding: padding(),
                                    child: Column(
                                      children: [
                                        ...List.generate(
                                            isLoading ? 3 : invitations.length,
                                            (index) {
                                          return isLoading
                                              ? classesCourseItemShimmer()
                                              : ClassessWidget.classesItem(
                                                  invitations[index]);
                                        }),
                                        space(110),
                                      ],
                                    ),
                                  ),
                          },
                        ])),
          ),
        );
      }));
    });
  }
}
