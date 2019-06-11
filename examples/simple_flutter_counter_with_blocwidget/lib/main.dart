import 'package:flutter/material.dart';
import 'package:bloc_lite/bloc_lite.dart';
import 'package:bloc_lite_flutter/bloc_lite_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('simple_counter_page_with_blocwidget'),
        ),
        body: Center(
          child: SimpleCounterPage(),
        ),
      ),
    );
  }
}

class SimpleCounterPage extends BlocWidget<CounterBlocController> {
  @override
  createController(BuildContext cxt) => CounterBlocController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Current value of the counter bloc:',
          ),
          Text(
            '${controller.counter}',
            style: Theme.of(context).textTheme.display1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: controller.decrementCounter,
                tooltip: 'Decrement',
                child: Icon(Icons.remove),
              ),
              FloatingActionButton(
                onPressed: controller.incrementCounter,
                tooltip: 'Increment',
                child: Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CounterBlocController extends BlocController {
  int counter;

  CounterBlocController() {
    counter = 0;
  }

  incrementCounter() {
    counter++;
    publishUpdate();
  }

  decrementCounter() {
    counter--;
    publishUpdate();
  }
}
