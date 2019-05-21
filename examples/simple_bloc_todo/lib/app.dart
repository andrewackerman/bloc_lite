import 'package:flutter/material.dart';
import 'package:simple_bloc_flutter/simple_bloc_flutter.dart';
import 'package:simple_bloc_todo/bloc/todo_controller.dart';
import 'package:simple_bloc_todo/theme.dart';

import 'package:simple_bloc_todo/screens/add_todo/add_edit_screen.dart';
import 'package:simple_bloc_todo/screens/home/home_screen.dart';
import 'mock/todo_mock.dart' as MockTodo;

class ToDoApp extends StatefulWidget {

  @override
  State createState() => ToDoAppState();

}

class ToDoAppState extends State<ToDoApp> {

  TodoController todoController;

  @override
  void initState() {
    todoController = TodoController.withState(MockTodo.data);
    super.initState();
  }

  @override
  void dispose() {
    todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext cxt) {
    return InheritedBloc(
      bloc: todoController,
      child: MaterialApp(
        title: 'Todo Application',
        theme: TodoAppTheme.theme,
        routes: {
          '/': (cxt) => HomeScreen(),
          '/addTodo': (cxt) => AddEditScreen(),
        },
      ),
    );
  }

}