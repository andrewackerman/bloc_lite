import 'package:flutter/material.dart';
import 'package:bloc_lite/bloc_lite.dart';
import 'package:bloc_lite_todo/bloc/todo_controller.dart';
import 'package:bloc_lite_todo/model/enums.dart';
import 'package:bloc_lite_todo/model/todo.dart';
import 'package:bloc_lite_todo/screens/home/widgets/detail_screen.dart';

import 'home_screen.dart';

class HomeScreenController extends BlocController {

  HomeScreenController(this.widgetState) : super();

  HomeScreenState widgetState;
  VisibilityFilter activeFilter = VisibilityFilter.all;
  bool isLoading = false;
  AppTab activeTab = AppTab.todos;

  void updateVisibility(TodoController todoController, VisibilityFilter newFilter) {
    final oldFilter = activeFilter;
    activeFilter = newFilter;

    if (oldFilter != activeFilter) {
      publishUpdate();
    }
  }

  void handleExtraAction(TodoController todoController, ExtraAction action) {
    if (action == ExtraAction.toggleAllComplete) {
      todoController.toggleAll();
    } else if (action == ExtraAction.clearCompleted) {
      todoController.clearCompleted();
    }
  }

  void onTodoItemTapped(Todo item) {
    Navigator.push(
      widgetState.context,
      MaterialPageRoute(builder: (_) => DetailScreen(todo: item)),
    );
  }

  void onTodoItemCheckboxChanged(TodoController todoController, Todo item, bool value) {
    todoController.updateTodo(item, complete: value);
  }

  void onTodoItemDismissed(TodoController todoController, Todo item) {
    todoController.removeTodo(item);

    Scaffold.of(widgetState.context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Theme.of(widgetState.context).backgroundColor,
        content: Text(
          item.task,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => todoController.addTodo(item),
        )
      ),
    );
  }

  void onTabTap(int index) {
    final oldTab = activeTab;
    activeTab = index == 0 ? AppTab.todos : AppTab.stats;

    if (oldTab != activeTab) {
      publishUpdate();
    }
  }

}