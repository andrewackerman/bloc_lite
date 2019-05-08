import 'package:bloc_widgets/bloc_widgets.dart';
import 'package:flutter/material.dart';

class StateCounterPage extends StatefulWidget {

  @override
  _StateCounterPageState createState() => _StateCounterPageState();

}

class _StateCounterPageState extends State<StateCounterPage> {
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
          EventBlocBuilder<CounterEvent, int>(bloc: bloc, builder: (cxt, event, value) {
            return Column(
              children: [
                Text(event == null ? 'No events have been received yet' : 'The most recent event was $event'),
                Text(
                  '$value',
                  style: Theme.of(context).textTheme.display1,
                ),
              ],
            );
          }),
          FloatingActionButton(
            onPressed: () => bloc.dispatch(CounterEvent.decrement, null),
            tooltip: 'Decrement',
            child: Icon(Icons.remove),
          ),
          FloatingActionButton(
            onPressed: () => bloc.dispatch(CounterEvent.increment, null),
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () => bloc.dispatch(CounterEvent.setToValue, 0),
            tooltip: 'Reset',
            child: Icon(Icons.exposure_zero),
          ),
        ],
      ),
    );
  }
}

enum CounterEvent {
  decrement,
  increment,
  setToValue,
}

class CounterBloc extends EventBloc<CounterEvent, int> {

  CounterBloc(int initialState) 
    : super(initialState);

  @override
  Stream<int> handleEvent(CounterEvent event, payload) async* {
    switch(event) {
      case CounterEvent.increment:
        yield currentValue + 1;
        break;
      case CounterEvent.decrement:
        yield currentValue - 1;
        break;
      case CounterEvent.setToValue:
        yield payload;
        break;
    }
  }
  
}