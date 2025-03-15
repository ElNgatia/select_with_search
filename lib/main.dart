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
      title: 'Flutter Select',
      theme: ThemeData(primarySwatch: Colors.blue, scaffoldBackgroundColor: Colors.grey[100]),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 16,
            children: [
              Text('Flutter Select with search', style: Theme.of(context).textTheme.bodyMedium),
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
              Text('Flutter Select', style: Theme.of(context).textTheme.bodyMedium),
              FlutterSelect<String>(
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
              Text('Flutter Select multiple', style: Theme.of(context).textTheme.bodyMedium),
              FlutterSelect<String>.multiple(
                placeholder: Text('Select an option'),
                selectedOptionsBuilder: (context, value) => Text(value.join(', ')),
                options: [
                  FlutterOption(value: 'option1', child: Text('Option 1')),
                  FlutterOption(value: 'option2', child: Text('Option 2')),
                ],
                onChanged: (value) {
                  print('Selected: $value');
                },
                footer: Text('300'),
              ),
              Text(
                'Flutter Select multiple with search',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              FlutterSelect<String>.multipleWithSearch(
                onSearchChanged: (value) => print('Search: $value'),
                placeholder: Text('Select an option'),
                selectedOptionsBuilder: (context, value) => Text(value.join(', ')),
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
      ),
    );
  }
}
