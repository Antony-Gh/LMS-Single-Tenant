import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:esoi/app/pages/main_page/providers_page/providers_filter.dart';
import 'package:esoi/app/pages/main_page/providers_page/user_profile_page/user_profile_page.dart';
import 'package:esoi/app/providers/app_language_provider.dart';
import 'package:esoi/app/providers/theme_provider.dart';
import 'package:esoi/app/services/guest_service/providers_service.dart';
import 'package:esoi/common/components.dart';
import 'package:esoi/common/common.dart';
import 'package:esoi/common/shimmer_component.dart';
import 'package:esoi/common/utils/app_text.dart';
import 'package:esoi/config/assets.dart';
import 'package:esoi/config/colors.dart';
import 'package:esoi/locator.dart';

import '../../../../common/utils/object_instance.dart';
import '../../../../common/utils/tablet_detector.dart';
import '../../../models/user_model.dart';
import '../../../providers/providers_provider.dart';

class ProvidersPage extends StatefulWidget {
  const ProvidersPage({super.key});

  @override
  State<ProvidersPage> createState() => _ProvidersPageState();
}

class _ProvidersPageState extends State<ProvidersPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int currentTab = 1;

  List<UserModel> instructorsData = [];
  List<UserModel> consultantsData = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);

    locator<ProvidersProvider>().clearFilter();

    getInstructors();
    getConsultants();
  }

  onChangeTab(int i) {
    setState(() {
      currentTab = i;
    });
  }

  getInstructors() async {
    setState(() {
      isLoading = true;
    });

    instructorsData = await ProvidersService.getInstructors(
        availableForMeetings: locator<ProvidersProvider>().availableForMeeting,
        freeMeetings: locator<ProvidersProvider>().free,
        discount: locator<ProvidersProvider>().discount,
        downloadable: locator<ProvidersProvider>().downloadable,
        sort: locator<ProvidersProvider>().sort,
        categories: locator<ProvidersProvider>().categorySelected);

    setState(() {
      isLoading = false;
    });
  }

  getConsultants() async {
    setState(() {
      isLoading = true;
    });

    consultantsData = await ProvidersService.getConsultations(
        availableForMeetings: locator<ProvidersProvider>().availableForMeeting,
        freeMeetings: locator<ProvidersProvider>().free,
        discount: locator<ProvidersProvider>().discount,
        downloadable: locator<ProvidersProvider>().downloadable,
        sort: locator<ProvidersProvider>().sort,
        categories: locator<ProvidersProvider>().categorySelected);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppLanguageProvider>(
        builder: (context, appLanguageProvider, _) {
      context.watch<ThemeProvider>();

      return directionality(
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: appbar(
              title: appText.providers,
              rightIcon: AppAssets.filterSvg,
              leftIcon: AppAssets.menuSvg,
              onTapLeftIcon: () {
                drawerController.showDrawer();
              },
              onTapRightIcon: () async {
                bool? res =
                    await baseBottomSheet(child: const ProvidersFilter());

                if (res != null && res) {
                  getInstructors();
                  getConsultants();
                }
              },
              rightWidth: 22),
          body: NestedScrollView(
              physics: const BouncingScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    backgroundColor: backgroundColor,
                    shadowColor: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(.2),
                    elevation: 10,
                    titleSpacing: 0,
                    title: tabBar(onChangeTab, tabController, [
                      Tab(
                        text: appText.instrcutors,
                        height: 32,
                      ),
                      Tab(
                        text: appText.consultants,
                        height: 32,
                      ),
                    ]),
                  )
                ];
              },
              body: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  controller: tabController,
                  children: [
                    !isLoading && instructorsData.isEmpty
                        ? emptyState(AppAssets.providersEmptyStateSvg,
                            appText.noInstructor, appText.noInstructorDesc)
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        TabletDetector.isTablet() ? 3 : 2,
                                    mainAxisSpacing: 22,
                                    crossAxisSpacing: 22,
                                    mainAxisExtent: 195),
                            padding: const EdgeInsets.only(
                                right: 21, left: 21, bottom: 100),
                            itemCount: isLoading ? 6 : instructorsData.length,
                            itemBuilder: (context, index) {
                              return isLoading
                                  ? userProfileCardShimmer()
                                  : userProfileCard(instructorsData[index], () {
                                      nextRoute(UserProfilePage.pageName,
                                          arguments: instructorsData[index].id);
                                    });
                            },
                          ),
                    !isLoading && consultantsData.isEmpty
                        ? emptyState(AppAssets.providersEmptyStateSvg,
                            appText.noConsultants, appText.noConsultantsDesc)
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        TabletDetector.isTablet() ? 3 : 2,
                                    mainAxisSpacing: 22,
                                    crossAxisSpacing: 22,
                                    mainAxisExtent: 195),
                            padding: const EdgeInsets.only(
                                right: 21, left: 21, bottom: 100),
                            itemCount: isLoading ? 6 : consultantsData.length,
                            itemBuilder: (context, index) {
                              return isLoading
                                  ? userProfileCardShimmer()
                                  : userProfileCard(consultantsData[index], () {
                                      nextRoute(UserProfilePage.pageName,
                                          arguments: consultantsData[index].id);
                                    });
                            },
                          ),
                  ])),
        ),
      );
    });
  }
}
