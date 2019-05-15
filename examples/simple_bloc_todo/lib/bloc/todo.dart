import 'package:simple_bloc/simple_bloc.dart';
import 'package:simple_bloc_todo/model/enums.dart';
import 'package:simple_bloc_todo/model/todo.dart';

class TodoController extends BlocController with BlocControllerWithState<TodoState> {
  
  @override
  TodoState get initialState => TodoState();

  void clearCompleted() {
    state.mutate(() {
      state.todos.removeWhere((todo) => todo.complete);
    });
  }

  void toggleAll() {
    state.mutate(() {
      final allCompleted = state.allComplete;
      state.todos.forEach((todo) => todo.complete = !allCompleted);
    });
  }

}

class TodoState extends BlocState {

  bool isLoading = false;
  List<Todo> todos = [];

  bool get allComplete => todos.every((todo) => todo.complete);
  bool get hasCompletedTodos => todos.any((todo) => todo.complete);
  int get numActive => todos.fold(0, (sum, todo) => !todo.complete ? ++sum : sum);
  int get numCompleted => todos.fold(0, (sum, todo) => todo.complete ? ++sum : sum);

  List<Todo> filterTodos(VisibilityFilter filter) =>
    todos.where((todo) {
      if (filter == VisibilityFilter.all) return true;
      if (filter == VisibilityFilter.active) return !todo.complete;
      return todo.complete;
    }).toList();

}