import 'package:beachu/constants.dart';
import 'package:beachu/models/hive_model.dart';
import 'package:beachu/providers/bath_provider.dart';
import 'package:beachu/views/bath_list.dart';
import 'package:beachu/views/bath_page.dart';
import 'package:beachu/views/edit_bath.dart';
import 'package:beachu/views/fav_list.dart';
import 'package:beachu/views/home.dart';
import 'package:beachu/views/login.dart';
import 'package:beachu/views/new_bath.dart';
import 'package:beachu/views/registration.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sizer/sizer.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  Hive.registerAdapter(LocalBathAdapter());
  await Hive.initFlutter();
  await Hive.openBox('favourites');
  //await Hive.deleteBoxFromDisk('favourites');
  runApp(
    EasyLocalization(
      supportedLocales: kListLocales,
      path: 'assets/translations',
      fallbackLocale: kDefaultLocale,
      child: MyApp(),
    ),
  );
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BathProvider(),
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            title: 'BeachU',
            theme: kDarkTheme,
            initialRoute: HomePage.id,
            routes: {
              HomePage.id: (context) => HomePage(),
              BathListPage.id: (context) => BathListPage(),
              BathPage.id: (context) => BathPage(),
              RegistrationPage.id: (context) => RegistrationPage(),
              LoginPage.id: (context) => LoginPage(),
              NewBath.id: (context) => NewBath(),
              EditBath.id: (context) => EditBath(),
              FavListPage.id: (context) => FavListPage(),
            },
          );
        },
      ),
    );
  }
}
