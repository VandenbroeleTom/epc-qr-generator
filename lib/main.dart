import 'package:epcqrgenerator/router.dart';
import 'package:epcqrgenerator/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:qr/qr.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'EPC QR',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: MyAppRouter.routes(),
        initialRoute: MyAppRouter.HOME,
        home: HomeScreen(),
    );
  }
}

