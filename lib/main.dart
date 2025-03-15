import 'package:flutter/material.dart';
import 'package:select_with_search/flutter_select.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Route Management',
      theme: ThemeData(primarySwatch: Colors.blue, scaffoldBackgroundColor: Colors.grey[100]),
      home: Scaffold(
        body: Column(
          children: [
            // MaterialSelect<String>(
            //   options: const ['Apple', 'Banana', 'Orange', 'Mango'],
            //   itemBuilder: (value) => Text(value),
            //   onChanged: (selected) => print(selected),
            //   multiple: true,
            //   searchable: false,
            //   hint: const Text('Select fruits...'),
            //   popupMaxHeight: 400,
            //   decoration: const InputDecoration(
            //     labelText: 'Fruits',
            //     border: OutlineInputBorder(),
            //     prefixIcon: Icon(Icons.search),
            //   ),
            // ),
            FlutterSelect<String>.withSearch(
              onSearchChanged: (value) {
                print('Search: $value');
              },
              placeholder: Text('Select an option'),
              selectedOptionBuilder: (context, value) => Text(value),
              options: [
                FlutterOption(value: 'option1', child: Text('Option 1')),
                FlutterOption(value: 'option2', child: Text('Option 2')),
              ],
              onChanged: (value) {
                print('Selected: $value');
              },
              footer: Text('300'),
            ),
          ],
        ),
      ),
    );
  }
}

