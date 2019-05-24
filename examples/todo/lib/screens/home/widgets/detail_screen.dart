import 'package:flutter/material.dart';
import 'package:bloc_lite_flutter/bloc_lite_flutter.dart';
import 'package:bloc_lite_todo/bloc/todo_controller.dart';
import 'package:bloc_lite_todo/model/todo.dart';
import 'package:bloc_lite_todo/screens/add_todo/add_edit_screen.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({
    @required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext cxt) {
    return BlocStateWidget<TodoController, TodoState>.inherited(
      context: cxt,
      builder: (_, bloc, state) => Scaffold(
            appBar: AppBar(
              title: Text('Todo Details'),
              actions: [
                IconButton(
                    tooltip: 'Delete Todo',
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      bloc.removeTodo(todo);
                      Navigator.pop(cxt, todo);
                    }),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(16),
              child: ListView(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Checkbox(
                          value: todo.complete,
                          onChanged: (value) {
                            bloc.updateTodo(todo, complete: value);
                          },
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 8, bottom: 16),
                              child: Text(
                                todo.task,
                                style: Theme.of(cxt).textTheme.headline,
                              ),
                            ),
                            Text(
                              todo.note,
                              style: Theme.of(cxt).textTheme.subhead,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              tooltip: 'Edit Todo',
              child: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(cxt).push(
                  MaterialPageRoute(
                    builder: (_) {
                      return AddEditScreen(
                        todo: todo,
                      );
                    },
                  ),
                );
              },
            ),
          ),
    );
  }
}
