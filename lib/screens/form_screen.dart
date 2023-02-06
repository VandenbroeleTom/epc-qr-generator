import 'dart:collection';
import 'dart:convert';

import 'package:epcqrgenerator/screens/code_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormScreen extends StatelessWidget {

  final _formKey = GlobalKey<FormBuilderState>();

  LinkedHashMap<String, String> configuration = {
    'service_tag': 'BCD',
    'version': '001',
    'identification': 'SCT',
    'name': 'Tom Vandenbroele',
    'iban': 'BE92 0015 5020 7823',
    'amount': 'EUR1',
    'reason': '',
    'invoice': '',
    'text': 'This is a test',
    'information': '',
  } as LinkedHashMap<String, String>;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new code'),
      ),
      body: _EPCForm(_formKey),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.download),
        onPressed: () async {
          // redirect to the code screen with this code.
          _formKey.currentState?.save();
          var values = _formKey.currentState!.value;

          configuration['amount'] = values['amount'];
          configuration['text'] = values['text'];

          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CodeScreen(data: configuration.values),
          ));
        },
      ),
    );
  }
}

class _EPCForm extends StatelessWidget {

  final GlobalKey<FormBuilderState> _formKey;

  _EPCForm(this._formKey) : super();

  List<Map<String, dynamic>> fields() {
    return [
      {
        'name': 'amount',
        'label': 'Amount',
        'value': 'EUR',
      },
      {
        'name': 'text',
        'label': 'Text',
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
            ],
          ),
        )
    );
  }
}
