import 'package:flutter/material.dart';
import 'package:simple_bloc_flutter/simple_bloc_flutter.dart';
import 'package:simple_bloc_todo/bloc/todo.dart';
import 'package:simple_bloc_todo/model/todo.dart';

class HomeScreen extends StatefulWidget {

  @override
  State createState() => HomeScreenState();

}

class HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext cxt) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Bloc Example'),
      ),
      body: SafeArea(
        child: BlocStateWidget<TodoController, TodoState>.inherited(
          context: cxt,
          builder: (blocCxt, bloc, state) {
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (listCxt, idx) {
                final todo = state.todos[idx];
                return TodoListItem(todo: todo);
              },
            );
          },
        ),
      ),
    );
  }

}

class TodoListItem extends StatelessWidget {

  final Todo todo;

  TodoListItem({
    this.todo,
  });

  @override
  Widget build(BuildContext cxt) {
    return Text(todo.note);
  }

}