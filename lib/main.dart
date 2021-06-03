import 'package:beachu/providers/bath_provider.dart';
import 'package:beachu/views/bath_list.dart';
import 'package:beachu/views/bath_page.dart';
import 'package:beachu/views/edit_bath.dart';
import 'package:beachu/views/home.dart';
import 'package:beachu/views/login.dart';
import 'package:beachu/views/new_bath.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BathProvider(),
      child: MaterialApp(
        title: 'BeachU',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.orange,
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF232329),
            foregroundColor: Colors.white60,
          ),
        ),
        initialRoute: HomePage.id,
        routes: {
          HomePage.id: (context) => HomePage(),
          BathListPage.id: (context) => BathListPage(),
          BathPage.id: (context) => BathPage(),
          LoginPage.id: (context) => LoginPage(),
          NewBath.id: (context) => NewBath(),
          EditBath.id: (context) => EditBath(),
        },
      ),
    );
  }
}
