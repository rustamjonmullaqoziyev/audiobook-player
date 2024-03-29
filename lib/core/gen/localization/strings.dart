import 'dart:ui';

import 'package:easy_localization_generator/easy_localization_generator.dart';

// https://docs.google.com/spreadsheets/d/1zq48lZ3HExTG0odngdfeEj_Y5uLkGhT9wdp_uu8opqw/edit?usp=sharing

part 'strings.g.dart';

@SheetLocalization(
  docId: '1zq48lZ3HExTG0odngdfeEj_Y5uLkGhT9wdp_uu8opqw',
  version: 2,
  // the `1` is the generated version.
  //You must increment it each time you want to regenerate a new version of the labels.
  outDir: 'assets/localization',
  //default directory save downloaded CSV file
  outName: 'translations.csv',
  //default CSV file name
  preservedKeywords: [
    'few',
    'many',
    'one',
    'other',
    'two',
    'zero',
    'male',
    'female',
  ],
)
class _Strings {}
