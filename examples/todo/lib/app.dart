import 'package:flutter/material.dart';
import 'package:bloc_lite_flutter/bloc_lite_flutter.dart';
import 'package:bloc_lite_todo/bloc/todo_controller.dart';
import 'package:bloc_lite_todo/theme.dart';

import 'package:bloc_lite_todo/screens/add_todo/add_edit_screen.dart';
import 'package:bloc_lite_todo/screens/home/home_screen.dart';
import 'mock/todo_mock.dart' as MockTodo;

class ToDoApp extends StatefulWidget {

  @override
  State createState() => ToDoAppState();

}

class ToDoAppState extends State<ToDoApp> {

  TodoController todoController;

  @override
  void initState() {
    todoController = TodoController(MockTodo.data);
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