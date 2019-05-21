import 'package:flutter/material.dart';
import 'package:simple_bloc_flutter/simple_bloc_flutter.dart';
import 'package:simple_bloc_todo/bloc/todo_controller.dart';

class StatsCounter extends StatelessWidget {

  @override
  Widget build(BuildContext cxt) {
    return BlocStateWidget<TodoController, TodoState>.inherited(
      context: cxt,
      builder: (_, bloc, state) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'Completed Todos',
                style: Theme.of(cxt).textTheme.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Text(
                '${state.numCompleted}',
                style: Theme.of(cxt).textTheme.subhead,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'Active Todos',
                style: Theme.of(cxt).textTheme.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Text(
                '${state.numActive}',
                style: Theme.of(cxt).textTheme.subhead,
              ),
            ),
          ],
        ),
      ),
    );
  }

}