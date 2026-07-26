import 'package:flutter/material.dart';
import 'package:esoi/common/data/app_language.dart';
import 'package:esoi/config/l10n/app_localizations.dart';
import 'package:esoi/locator.dart';

AppLocalizations get appText {
  return lookupAppLocalizations(Locale(locator<AppLanguage>().currentLanguage));
}
