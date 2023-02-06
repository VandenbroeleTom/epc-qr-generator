import 'dart:convert';

import 'package:epcqrgenerator/router.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CodesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Codes')
      ),
      body: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator.adaptive()
            );
          }

          SharedPreferences preferences = snapshot.data as SharedPreferences;

          var codes = preferences.getStringList('codes') ?? [];

          if (codes.isEmpty) {
            // todo: add a button to create a new code
            return const Center(
              child: Text('No saved codes yet.'),
            );
          }

          return ListView.builder(
            itemCount: codes.length,
            itemBuilder: (context, index) {

              return ListTile(
                title: Text(codes[index]),
                onLongPress: () async {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Delete qr code?'),
                        actions: [
                          TextButton(
                              child: Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: Text('Confirm'),
                            onPressed: () {
                              codes.removeAt(index);
                              preferences.setStringList('codes', codes);

                              // Close dialog.
                              Navigator.of(context).pop();
                              // Refresh page.
                              Navigator.of(context).pushReplacementNamed(MyAppRouter.CODES);
                            },
                          )
                        ]
                      );
                    }
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}