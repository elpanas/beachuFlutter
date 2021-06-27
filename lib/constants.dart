import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String url = dotenv.env['URI']!;
final String hashAuth = dotenv.env['HASH_AUTH']!;

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
    const TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
  ),
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
const kBathOpacTextStyle = TextStyle(
  color: Colors.white54,
  fontSize: 16,
);
const kV30Padding = EdgeInsets.symmetric(vertical: 30.0);
// ----------------------------------------------------

// NEW/EDIT BATH PAGE
const kH20Padding = EdgeInsets.symmetric(horizontal: 20.0);

// BATH LIST PAGE
const kTitleListStyle = TextStyle(
  fontSize: 20.0,
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
const kMessageStyle = TextStyle(
  color: Colors.white70,
  fontSize: 18.0,
);
// ----------------------------------------------------

// HOME PAGE

// Login Button
final kLogInOutButtonStyle = kButtonStyle.copyWith(
  foregroundColor: MaterialStateProperty.all(Colors.white60),
);
const kH30Padding = EdgeInsets.symmetric(horizontal: 30.0);

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

// Font Family
final kFontFamily = ThemeData.dark().textTheme.apply(
      fontFamily: 'ComicNeue',
    );

// AppBar Theme
const kAppBarTheme = AppBarTheme(
  backgroundColor: Color(0xFF232329),
  foregroundColor: Colors.white60,
);
// ----------------------------------------------------