import 'package:epcqrgenerator/router.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CodeScreen extends StatelessWidget {

  final Iterable<String> data;

  const CodeScreen({ Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: QrImage(
          data: data.join("\n"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          // save this data for future use.
          final prefs = await SharedPreferences.getInstance();
          var codes = prefs.getStringList('codes') ?? [];
          codes.add(data.join("\n"));
          await prefs.setStringList('codes', codes);

          // show a confirmation snackbar.
          var snackBar = SnackBar(
            content: Text('Code saved'),
            action: SnackBarAction(
              label: 'View',
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(MyAppRouter.CODES, (route) => false) 
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      ),
    );
  }

}