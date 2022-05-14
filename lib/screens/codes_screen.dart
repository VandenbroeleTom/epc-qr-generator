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

          var codes = preferences.getString('codes') ?? '[]';
          List codesJson = jsonDecode(codes);

          return ListView.builder(
            itemCount: codesJson.length,
            itemBuilder: (context, index) {
              var name = codesJson[index]['name'];
              var code = codesJson[index]['code'];

              return ListTile(
                title: Text(name),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: QrImage(
                          data: code,
                        ),
                      );
                    }
                  );
                },
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
                              codesJson.removeAt(index);
                              preferences.setString('codes', jsonEncode(codesJson));

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