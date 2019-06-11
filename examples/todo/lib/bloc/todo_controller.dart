import 'package:bloc_lite/bloc_lite.dart';
import 'package:bloc_lite_todo/model/enums.dart';
import 'package:bloc_lite_todo/model/todo.dart';

class TodoController extends BlocController {
  TodoController([TodoState state]) : this.state = state ?? TodoState();

  final TodoState state;

  void addTodo(Todo todo) {
    state.todos.add(todo);
    publishUpdate();
  }

  void removeTodo(Todo todo) {
    state.todos.remove(todo);
    publishUpdate();
  }

  void updateTodo(Todo todo, {String task, String note, bool complete}) {
    final idx = state.todos.indexOf(todo);
    state.todos[idx].task = task ?? todo.task;
    state.todos[idx].note = note ?? todo.note;
    state.todos[idx].complete = complete ?? todo.complete;
    publishUpdate();
  }

  void clearCompleted() {
    state.todos.removeWhere((todo) => todo.complete);
    publishUpdate();
  }

  void toggleAll() {
    final allCompleted = state.allComplete;
    state.todos.forEach((todo) => todo.complete = !allCompleted);
    publishUpdate();
  }
}

class TodoState {
  bool isLoading = false;
  List<Todo> todos = [];

  bool get allComplete => todos.every((todo) => todo.complete);
  bool get hasCompletedTodos => todos.any((todo) => todo.complete);
  int get numActive =>
      todos.fold(0, (sum, todo) => !todo.complete ? ++sum : sum);
  int get numCompleted =>
      todos.fold(0, (sum, todo) => todo.complete ? ++sum : sum);

  List<Todo> filterTodos(VisibilityFilter filter) => todos.where((todo) {
        if (filter == VisibilityFilter.all) return true;
        if (filter == VisibilityFilter.active) return !todo.complete;
        return todo.complete;
      }).toList();
}
