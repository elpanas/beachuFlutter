import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final url = env['URI']!;
final String hashAuth = env['HASH_AUTH']!;

final kButtonStyle = ButtonStyle(
  padding: MaterialStateProperty.all(
    EdgeInsets.symmetric(vertical: 12.0),
  ),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  ),
  textStyle: MaterialStateProperty.all(
    TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
  ),
);

const kTitleListStyle = TextStyle(
  fontSize: 20.0,
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

const kBathTextStyle = TextStyle(
  color: Colors.white60,
  fontWeight: FontWeight.bold,
);

const kMessageStyle = TextStyle(
  color: Colors.white70,
  fontSize: 18.0,
);

const kBathOpacTextStyle = TextStyle(
  color: Colors.white54,
  fontSize: 16,
);

const kBathPadding = EdgeInsets.symmetric(
  vertical: 30.0,
);

const kErrorTextContent = Text(
  'Qualcosa è andato storto',
  style: TextStyle(color: Colors.black),
);
