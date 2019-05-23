import 'package:flutter/material.dart';
import 'package:bloc_lite/bloc_lite.dart';
import 'package:bloc_lite_flutter/bloc_lite_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  State createState() => MyAppState();

}

class MyAppState extends State<MyApp> {

  final blocA = CounterBlocControllerA();
  final blocB = CounterBlocControllerB();

  @override
  void dispose() {
    blocA.dispose();
    blocB.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedBlocTree(
      blocProviders: [
        InheritedBloc<CounterBlocControllerA>(bloc: blocA),
        InheritedBloc<CounterBlocControllerB>(bloc: blocB),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('simple_counter_page_with_inheritence_tree'),
          ),
          body: Center(
            child: SimpleCounterPage(),
          ),
        ),
      ),
    );
  }

}

class SimpleCounterPage extends StatelessWidget {

  @override
  Widget build(BuildContext cxt) {
    final blocA = InheritedBloc.of<CounterBlocControllerA>(cxt);
    final blocB = InheritedBloc.of<CounterBlocControllerB>(cxt);
    
    return Container(
      padding: EdgeInsets.all(8),
      child: BlocWidget(
        controller: blocA, 
        builder: (_, __) => BlocWidget(
          controller: blocB,
          builder: (_, __) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${blocA.value} + ${blocB.value} = ${blocA.value + blocB.value}',
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text('Value 1'),
                        SizedBox(height: 16),
                        Text('${blocA.value}'),
                        SizedBox(height: 16),
                        FloatingActionButton(
                          onPressed: blocA.decrementCounter,
                          tooltip: 'Decrement',
                          child: Icon(Icons.remove),
                        ),
                        SizedBox(height: 16),
                        FloatingActionButton(
                          onPressed: blocA.incrementCounter,
                          tooltip: 'Increment',
                          child: Icon(Icons.add),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Value 2'),
                        SizedBox(height: 16),
                        Text('${blocB.value}'),
                        SizedBox(height: 16),
                        FloatingActionButton(
                          onPressed: blocB.decrementCounter,
                          tooltip: 'Decrement',
                          child: Icon(Icons.remove),
                        ),
                        SizedBox(height: 16),
                        FloatingActionButton(
                          onPressed: blocB.incrementCounter,
                          tooltip: 'Increment',
                          child: Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

}

class CounterBlocControllerA extends BlocController {

  int value = 0;

  incrementCounter() {
    value++;
    publishUpdate();
  }

  decrementCounter() {
    value--;
    publishUpdate();
  }
  
}

class CounterBlocControllerB extends BlocController {

  int value = 0;

  incrementCounter() {
    value++;
    publishUpdate();
  }

  decrementCounter() {
    value--;
    publishUpdate();
  }
  
}
