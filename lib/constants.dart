import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sizer/sizer.dart';

final String url = dotenv.env['URI']!;
final String hashAuth = dotenv.env['HASH_AUTH']!;

// APPBAR
final kAppBarTextStyle = TextStyle(
  fontSize: 18.sp,
);

// BUTTON
final kButtonStyle = ButtonStyle(
  padding: MaterialStateProperty.all(
    const EdgeInsets.symmetric(vertical: 12.0),
  ),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  ),
  textStyle: MaterialStateProperty.all(
    TextStyle(
      fontSize: 22.sp,
      fontWeight: FontWeight.bold,
      fontFamily: 'ComicNeue',
    ),
  ),
  fixedSize: MaterialStateProperty.all(
    Size(70.w, 9.h),
  ),
);
final kSimpleButtonStyle = kButtonStyle.copyWith(
  backgroundColor: MaterialStateProperty.all(Colors.orange),
  foregroundColor: MaterialStateProperty.all(Colors.black87),
);
// BATH PAGE

// Bath Container - Bath Title - Bath Subtitle - Bath Field
const kBathTextStyle = TextStyle(
  color: Colors.white60,
  fontWeight: FontWeight.bold,
);
const kBathMargin = EdgeInsets.symmetric(
  horizontal: 10.0,
  vertical: 10.0,
);
const kBathTitlePadding = EdgeInsets.symmetric(vertical: 50.0);
final kBathTitleDecoration = BoxDecoration(
  color: const Color(0xFF232329),
  boxShadow: [const BoxShadow(blurRadius: 3.0)],
  borderRadius: BorderRadius.circular(10.0),
);
final kBathOpacTextStyle = TextStyle(
  color: Colors.white54,
  fontSize: 16.sp,
);
const kV30Padding = EdgeInsets.symmetric(vertical: 30.0);
// ----------------------------------------------------

// NEW/EDIT BATH PAGE
const kH20Padding = EdgeInsets.symmetric(horizontal: 20.0);

// BATH LIST PAGE
final kTitleListStyle = TextStyle(
  fontSize: 20.sp,
  fontWeight: FontWeight.bold,
);
const kBathCardLeadingIcon = Icon(
  Icons.beach_access,
  color: Colors.green,
);
const kBathCardMargin = EdgeInsets.symmetric(
  horizontal: 10.0,
  vertical: 4.0,
);
final kMessageStyle = TextStyle(
  color: Colors.white70,
  fontSize: 18.sp,
);
// ----------------------------------------------------

// HOME PAGE

// Login Button
final kLogInOutButtonStyle = kButtonStyle.copyWith(
  foregroundColor: MaterialStateProperty.all(Colors.white60),
);
const kH30Padding = EdgeInsets.symmetric(horizontal: 30.0);

// Google Button
final kGoogleButtonStyle = kButtonStyle.copyWith(
  foregroundColor: MaterialStateProperty.all(Colors.red),
);

// Facebook Button
final kFacebookButtonStyle = kButtonStyle.copyWith(
  foregroundColor: MaterialStateProperty.all(Colors.blue),
);

// SnackBar
const kSnackBarTextStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
);
const kSnackbarPadding = EdgeInsets.symmetric(
  vertical: 3.0,
  horizontal: 10.0,
);
// ----------------------------------------------------

// MAIN PAGE

// Locales
const kListLocales = [
  Locale('en', 'US'),
  Locale('it', 'IT'),
];
const kDefaultLocale = Locale('en', 'US');

// Font Family
final kFontFamily = ThemeData.dark().textTheme.apply(
      fontFamily: 'ComicNeue',
    );

// AppBar Theme
const kAppBarTheme = AppBarTheme(
  backgroundColor: Color(0xFF232329),
  foregroundColor: Colors.white60,
);

// Dark Theme
final kDarkTheme = ThemeData.dark().copyWith(
  textTheme: kFontFamily,
  primaryTextTheme: kFontFamily,
  primaryColor: Colors.orange,
  appBarTheme: kAppBarTheme,
);
// ----------------------------------------------------