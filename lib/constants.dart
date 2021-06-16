import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String url = env['URI']!;
final String hashAuth = env['HASH_AUTH']!;

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

const kBathTitlePadding = EdgeInsets.symmetric(
  vertical: 50.0,
);

final kBathTitleDecoration = BoxDecoration(
  color: Color(0xFF232329),
  boxShadow: [BoxShadow(blurRadius: 3.0)],
  borderRadius: BorderRadius.circular(10.0),
);

const kBathOpacTextStyle = TextStyle(
  color: Colors.white54,
  fontSize: 16,
);

const kBathPadding = EdgeInsets.symmetric(vertical: 30.0);
// ----------------------------------------------------

// NEW BATH PAGE
const kNewBathPadding = EdgeInsets.symmetric(horizontal: 20.0);

// LOGIN PAGE
const kDecorationMail = InputDecoration(
  labelText: 'Scrivi la tua email',
  labelStyle: kBathOpacTextStyle,
);

const kDecorationPassword = InputDecoration(
  labelText: 'Scrivi la tua password',
  labelStyle: kBathOpacTextStyle,
);
// ----------------------------------------------------

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
// Google Button
final kGoogleButtonStyle = kButtonStyle.copyWith(
  foregroundColor: MaterialStateProperty.all(Colors.red),
);

// Login Button
final kLogInOutButtonStyle = kButtonStyle.copyWith(
  foregroundColor: MaterialStateProperty.all(Colors.white60),
);

// Simple Button
final kSimpleButtonStyle = kButtonStyle.copyWith(
  backgroundColor: MaterialStateProperty.all(Colors.orange),
  foregroundColor: MaterialStateProperty.all(Colors.black87),
  fixedSize: MaterialStateProperty.all(Size.fromWidth(300.0)),
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
