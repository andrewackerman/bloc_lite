import 'package:flutter/material.dart';
import 'package:simple_bloc/simple_bloc.dart';
import 'package:simple_bloc_flutter/simple_bloc_flutter.dart';

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
          title: Text('simple_counter_page'),
        ),
        body: Center(
          child: SimpleCounterPage(),
        ),
      ),
    );
  }
}

class SimpleCounterPage extends StatefulWidget {

  @override
  State createState() => SimpleCounterPageState();

}

class SimpleCounterPageState extends State<SimpleCounterPage> {

  final CounterBlocController controller = CounterBlocController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
          BlocWidget(controller: controller, builder: (cxt, bloc) {
            return Text(
              '${bloc.counter}',
              style: Theme.of(context).textTheme.display1,
            );
          }),
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

  CounterBlocController()  {
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
