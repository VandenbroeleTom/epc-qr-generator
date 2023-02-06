import 'dart:convert';

import 'package:epcqrgenerator/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          final prefs = snapshot.data as SharedPreferences;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // H1 > Hi {name}
              Text("Hi " + (prefs.getString('name') ?? ''), style: Theme.of(context).textTheme.headlineLarge),

              const SizedBox(height: 32),
              
              // button > Create a new code
              ElevatedButton(
                child: const Text('Create a new code'),
                onPressed: () => Navigator.of(context).pushNamed(MyAppRouter.FORM),
              ),

              const SizedBox(height: 16),

              // button > View saved codes
              ElevatedButton(
                child: const Text('View saved codes'),
                onPressed: () => Navigator.of(context).pushNamed(MyAppRouter.CODES),
              ),

              const SizedBox(height: 16),

              // button > View all codes.
              ElevatedButton(
                child: const Text('Configure settings'),
                onPressed: () => Navigator.of(context).pushNamed(MyAppRouter.SETTINGS),
              )
            ],
          );
        }
      ),
    );
  }
}