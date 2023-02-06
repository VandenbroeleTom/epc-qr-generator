import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          final prefs = snapshot.data as SharedPreferences;

          nameController.text = prefs.getString('name') ?? '';

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child:  FormBuilderTextField(
                    name: 'name',
                    decoration: InputDecoration(
                      labelText: 'Your name',
                    ),
                    controller: nameController,
                  )
                )
              ],
            )
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () async {
          // Save the settings.
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('name', nameController.value.text);

          // Show a confirmation snackbar.
          const snackBar = SnackBar(content: Text('The configuration options have been saved.'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      ),
    );
  }

}