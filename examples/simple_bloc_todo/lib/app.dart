import 'package:flutter/material.dart';
import 'package:simple_bloc_flutter/simple_bloc_flutter.dart';
import 'package:simple_bloc_todo/bloc/todo.dart';
import 'package:simple_bloc_todo/model/todo.dart';
import 'package:simple_bloc_todo/theme.dart';

import 'screens/add_todo_screen.dart';
import 'screens/home_screen.dart';

class ToDoApp extends StatefulWidget {

  @override
  State createState() => ToDoAppState();

}

class ToDoAppState extends State<ToDoApp> {

  TodoController todoController = TodoController();

  @override
  void initState() {
    todoController.state.todos = [
      Todo('Do Thing A'),
      Todo('Do Thing B'),
      Todo('Do Thing C'),
      Todo('Do Thing D'),
      Todo('Do Thing E'),
    ];
    super.initState();
  }

  Widget scaffold(BuildContext cxt, Widget child) {
    return InheritedBloc(
      bloc: todoController,
      child: child,
    );
  }

  @override
  Widget build(BuildContext cxt) {
    return MaterialApp(
      title: 'Todo Application',
      theme: TodoAppTheme.theme,
      routes: {
        '/': (cxt) => scaffold(cxt, HomeScreen()),
        '/addTodo': (cxt) => scaffold(cxt, AddTodoScreen()),
      },
    );
  }

}