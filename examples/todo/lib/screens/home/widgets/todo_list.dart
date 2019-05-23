import 'package:flutter/material.dart';
import 'package:bloc_lite_flutter/bloc_lite_flutter.dart';
import 'package:bloc_lite_todo/bloc/todo_controller.dart';
import 'package:bloc_lite_todo/model/todo.dart';

import '../../../utility.dart';
import '../home_screen_controller.dart';

class TodoList extends StatelessWidget {

  TodoList({
    this.onTodoItemTapped,
    this.onTodoItemDismissed,
    this.onTodoItemCheckboxChanged,
  });

  final void Function(Todo) onTodoItemTapped;
  final void Function(Todo) onTodoItemDismissed;
  final void Function(Todo, bool) onTodoItemCheckboxChanged;

  @override
  Widget build(BuildContext cxt) {
    return BlocWidget<HomeScreenController>.inherited(
      context: cxt,
      builder: (cxt, homeBloc) => BlocStateWidget<TodoController, TodoState>.inherited(
        context: cxt,
        builder: (cxt, todoBloc, todoState) {
          final filteredTodos = todoState.filterTodos(homeBloc.activeFilter);
          return Container(
            child: homeBloc.isLoading
              ? Center(
              child: CircularProgressIndicator()
            )
              : ListView.builder(
              itemCount: filteredTodos.length,
              itemBuilder: (listCxt, idx) {
                final todo = filteredTodos[idx];
                return TodoListItem(
                  todo: todo,
                  onTodoItemTapped: onTodoItemTapped,
                  onTodoItemDismissed: onTodoItemDismissed,
                  onTodoItemCheckboxChanged: onTodoItemCheckboxChanged,
                );
              },
            ),
          );
        },
      ),
    );
  }

}

class TodoListItem extends StatelessWidget {

  final Todo todo;
  final void Function(Todo) onTodoItemTapped;
  final void Function(Todo) onTodoItemDismissed;
  final void Function(Todo, bool) onTodoItemCheckboxChanged;

  TodoListItem({
    this.todo,
    this.onTodoItemTapped,
    this.onTodoItemDismissed,
    this.onTodoItemCheckboxChanged,
  });

  @override
  Widget build(BuildContext cxt) {
    return Dismissible(
      key: keyGenerator(todo.id, suffix: 'todoListItem'),
      onDismissed: (direction) => onTodoItemDismissed(todo),
      child: ListTile(
        onTap: () => onTodoItemTapped(todo),
        leading: Checkbox(
          value: todo.complete,
          onChanged: (changed) => onTodoItemCheckboxChanged(todo, changed),
        ),
        title: Text(
          todo.task,
          style: Theme.of(cxt).textTheme.title,
        ),
        subtitle: Text(
          todo.note,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(cxt).textTheme.subhead,
        ),
      ),
    );
    // return Text(todo.task);
  }

}