import 'package:flutter/material.dart';
import 'package:bloc_lite_flutter/bloc_lite_flutter.dart';
import 'package:bloc_lite_todo/bloc/todo_controller.dart';

class StatsCounter extends StatelessWidget {
  @override
  Widget build(BuildContext cxt) {
    return BlocBuilder<TodoController>.inherited(
      context: cxt,
      builder: (_, bloc) => Center(
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
                    '${bloc.state.numCompleted}',
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
                    '${bloc.state.numActive}',
                    style: Theme.of(cxt).textTheme.subhead,
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
