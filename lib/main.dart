import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
    return MaterialApp(
        title: 'EPC QR',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('EPC QR'),
          ),
          body: Center(
            child: FormBuilder(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...fields().map((e) => Padding(
                            padding: const EdgeInsets.all(8),
                            child: FormBuilderTextField(
                              name: e['name'],
                              decoration:
                                  InputDecoration(labelText: e['label']),
                              initialValue: e['value'],
                            ),
                          )),
                      ElevatedButton(
                        child: Text('Create qr code'),
                        onPressed: () {
                          _formKey.currentState?.save();

                          var values = _formKey.currentState!.value;
                          var string = "";

                          for (var field in fields()) {
                            string += values[field['name']];
                            string += "\n";
                          }

                          print(string);
                        },
                      )
                    ],
                  ),
                )),
          ),
        ));
  }
}
