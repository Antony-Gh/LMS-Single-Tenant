import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:esoi/config/app_config.dart';
import 'package:esoi/core/storage/secure_storage_helper.dart';
import 'package:esoi/core/network/api_client.dart';
import 'package:esoi/core/network/api/auth_api.dart';
import 'package:esoi/app/services/authentication_service/authentication_service.dart';
import 'package:esoi/core/network/api/user_api.dart';
import 'package:esoi/app/services/user_service/user_service.dart';
import 'package:esoi/core/network/api/course_api.dart';
import 'package:esoi/app/services/guest_service/course_service.dart';
import 'package:esoi/app/providers/app_language_provider.dart';
import 'package:esoi/app/providers/drawer_provider.dart';
import 'package:esoi/app/providers/home_provider.dart';
import 'package:esoi/app/providers/theme_provider.dart';
import 'package:esoi/common/data/app_language.dart';
import 'app/providers/filter_course_provider.dart';
import 'app/providers/page_provider.dart';
import 'app/providers/providers_provider.dart';
import 'app/providers/user_provider.dart';
import 'common/utils/currency_utils.dart';

GetIt locator = GetIt.instance;

locatorSetup(AppConfig config) async {
  locator.registerSingleton<AppConfig>(config);
  locator.registerSingleton<SecureStorageHelper>(SecureStorageHelper());
  locator.registerSingleton<ApiClient>(ApiClient());
  locator.registerSingleton<Dio>(Dio());
  locator.registerSingleton<AuthApi>(AuthApi());
  locator.registerSingleton<AuthenticationService>(AuthenticationService(locator<AuthApi>()));
  locator.registerSingleton<UserApi>(UserApi());
  locator.registerSingleton<UserService>(UserService(locator<UserApi>()));
  locator.registerSingleton<CourseApi>(CourseApi());
  locator.registerSingleton<CourseService>(CourseService(locator<CourseApi>()));

  locator.registerSingleton<AppLanguage>(AppLanguage());
  locator.registerSingleton<CurrencyUtils>(CurrencyUtils());
  // locator.registerSingleton<AdvancedDrawerController>(AdvancedDrawerController());

  // Providers
  locator.registerSingleton<AppLanguageProvider>(AppLanguageProvider());
  locator.registerSingleton<PageProvider>(PageProvider());
  locator.registerSingleton<FilterCourseProvider>(FilterCourseProvider());
  locator.registerSingleton<ProvidersProvider>(ProvidersProvider());
  locator.registerSingleton<UserProvider>(UserProvider());
  locator.registerSingleton<DrawerProvider>(DrawerProvider());
  locator.registerSingleton<HomeProvider>(HomeProvider());
  locator.registerSingleton<ThemeProvider>(ThemeProvider());
}
