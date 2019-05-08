import 'package:bloc_widgets/bloc_widgets.dart';
import 'package:flutter/material.dart';

import 'simple_counter_page.dart';
import 'state_counter_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExampleHome(),
    );
  }
}

class ExampleHome extends StatelessWidget {

  @override
  Widget build(BuildContext cxt) {
    return Scaffold(
      appBar: AppBar(
        title: Text('simple_bloc example'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: SimpleCounterPage(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: StateCounterPage(),
            ),
          ),
        ],
      ),
    );
  }

}


