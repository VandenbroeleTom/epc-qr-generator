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
        appBar: AppBar(title: Text('EPC QR'), actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () => Navigator.of(context).pushNamed(MyAppRouter.CODES),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () =>
                Navigator.of(context).pushNamed(MyAppRouter.SETTINGS),
          )
        ]),
        body: Center(
          child: EPCForm(),
        ));
  }
}

class EPCForm extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  List<Map<String, dynamic>> fields() {
    return [
      {
        'name': 'service_tag',
        'label': 'Service tag',
        'value': 'BCD',
      },
      {'name': 'version', 'label': 'Version', 'value': '001'},
      {
        'name': 'character_set',
        'label': 'Character set',
        'value': '1',
      },
      {'name': 'identification', 'label': 'Identification', 'value': 'SCT'},
      {
        'name': 'bic',
        'label': 'BIC',
        'value': '',
      },
      {
        'name': 'name',
        'label': 'Name',
        'value': '',
      },
      {
        'name': 'iban',
        'label': 'IBAN',
        'value': '',
      },
      {
        'name': 'amount',
        'label': 'Amount',
        'value': 'EUR',
      },
      {
        'name': 'reason',
        'label': 'Reason',
        'value': '',
      },
      {
        'name': 'invoice_reference',
        'label': 'Invoice reference',
        'value': '',
      },
      {
        'name': 'text',
        'label': 'Text',
        'value': '',
      },
      {
        'name': 'information',
        'label': 'Information',
        'value': '',
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ...fields().map((e) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: FormBuilderTextField(
                      name: e['name'],
                      decoration: InputDecoration(labelText: e['label']),
                      initialValue: e['value'],
                    ),
                  )),
              ElevatedButton(
                child: Text('Create qr code'),
                onPressed: () async {
                  _formKey.currentState?.save();

                  var values = _formKey.currentState!.value;
                  var string = "";

                  for (var field in fields()) {
                    string += values[field['name']];
                    string += "\n";
                  }

                  final qrImage =
                      QrImage(data: string, version: QrVersions.auto);

                  final qrCode = QrCode(4, QrErrorCorrectLevel.H)
                    ..addData(string);

                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(content: qrImage);
                      });
                },
              ),
              ElevatedButton(
                child: Text('Save as template'),
                onPressed: () async {
                  _formKey.currentState!.save();

                  var values = _formKey.currentState!.value;
                  var string = "";

                  for (var field in fields()) {
                    string += values[field['name']];
                    string += "\n";
                  }

                  final _dialogFormKey = GlobalKey<FormBuilderState>();

                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Save as template'),
                          content: FormBuilder(
                            key: _dialogFormKey,
                            child: FormBuilderTextField(
                              name: 'name',
                              decoration: InputDecoration(labelText: 'Name'),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required()
                              ]),
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            TextButton(
                              child: Text('Save'),
                              onPressed: () async {
                                _dialogFormKey.currentState!.validate();
                                _dialogFormKey.currentState!.save();

                                final preferences = await SharedPreferences.getInstance();

                                final String codesString = await preferences.getString('codes') ?? '[]';

                                final codesJson = jsonDecode(codesString);

                                codesJson.add({
                                  'name': _dialogFormKey.currentState!.value['name'],
                                  'code': string,
                                });

                                print(codesJson);

                                await preferences.setString('codes', jsonEncode(codesJson));

                                // Close this dialog.
                                Navigator.of(context).pop();

                                // Show a snackbar.
                                var snackbar = SnackBar(content: Text('QR code saved'));
                                ScaffoldMessenger.of(context).showSnackBar(snackbar);
                              },
                            ),
                          ],
                        );
                      });
                },
              )
            ],
          ),
        ));
  }
}
