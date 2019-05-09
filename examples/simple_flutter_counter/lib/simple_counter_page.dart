import 'package:flutter/material.dart';
import 'package:simple_bloc/simple_bloc.dart';
import 'package:simple_bloc_flutter/simple_bloc_flutter.dart';

class SimpleCounterPage extends StatefulWidget {

  @override
  _SimpleCounterPageState createState() => _SimpleCounterPageState();

}

class _SimpleCounterPageState extends State<SimpleCounterPage> {
  CounterBloc bloc = CounterBloc(0);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFCCCCCC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Current value of the counter bloc:',
          ),
          BlocBuilder(bloc: bloc, builder: (cxt, value) {
            return Text(
              '$value',
              style: Theme.of(context).textTheme.display1,
            );
          }),
          FloatingActionButton(
            onPressed: bloc.decrementCounter,
            tooltip: 'Decrement',
            child: Icon(Icons.remove),
          ),
          FloatingActionButton(
            onPressed: bloc.incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class CounterBloc extends Bloc<int> {

  CounterBloc(int initialState) 
    : super(initialState) {
    counter = initialState;
  }

  int counter;

  incrementCounter() {
    counter++;

    publishValue(counter);
  }

  decrementCounter() {
    counter--;

    publishValue(counter);
  }
  
}